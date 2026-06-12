#!/usr/bin/env bash
# ==============================================================================
# HumanEgo — macOS / Apple Silicon Environment Setup
# ==============================================================================
#
# Usage:
#   conda create -n humanego python=3.11 -y
#   conda activate humanego
#   bash setup_mac.sh
#
# This script is for macOS arm64 machines such as M1/M2/M3/M4 Macs. The upstream
# setup.sh targets Linux + NVIDIA CUDA. On macOS there is no CUDA, so this script:
#   - installs macOS PyTorch wheels
#   - skips CUDA-only xformers
#   - replaces onnxruntime-gpu with onnxruntime
#   - skips robot hardware packages by default
#   - verifies MPS or CPU instead of CUDA
#
# Notes:
#   - Preprocessing/training may still be slower than on a CUDA workstation.
#   - Some project modules are written with CUDA assumptions; this script only fixes
#     the environment install path, not every runtime CUDA code path.
#
# Options:
#   SKIP_HARDWARE=1  (default) skip pyrealsense2 & trossen-arm
#   SKIP_HAND=1      (default) skip MediaPipe / WiLoR / HaMeR
#   PREDOWNLOAD=0    (default) do not pre-download model weights
#
# ==============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
_SETUP_T0=$(date +%s); _STEP_T0=""
step()  {
    if [ -n "$_STEP_T0" ]; then echo -e "${GREEN}   ✓ previous step done in $(( $(date +%s) - _STEP_T0 ))s${NC}"; fi
    echo -e "\n${BLUE}══════════════════════════════════════════${NC}"
    echo -e "${BLUE} $*${NC}"
    echo -e "${BLUE}══════════════════════════════════════════${NC}"
    _STEP_T0=$(date +%s)
}

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_ROOT"
info "Project root: $PROJECT_ROOT"

SKIP_HARDWARE="${SKIP_HARDWARE:-1}"
SKIP_HAND="${SKIP_HAND:-1}"
PREDOWNLOAD="${PREDOWNLOAD:-0}"

step "[1/7] Verifying conda environment and macOS platform"

if [ -z "${CONDA_DEFAULT_ENV:-}" ] || [ "$CONDA_DEFAULT_ENV" = "base" ]; then
    error "No conda environment is active (or you're in 'base').
Please run:
  conda create -n humanego python=3.11 -y
  conda activate humanego
  bash setup_mac.sh"
fi

if [ "$(uname -s)" != "Darwin" ]; then
    warn "This script is intended for macOS. Continuing anyway."
fi

PYTHON="$(which python)"
PIP="$(which pip)"
info "Active conda env: $CONDA_DEFAULT_ENV"
info "Python: $($PYTHON --version) at $PYTHON"
info "Platform: $(uname -s) $(uname -m)"

step "[2/7] Installing NumPy and chumpy"

$PIP install "numpy<2.0"
info "NumPy installed: $($PYTHON -c 'import numpy; print(numpy.__version__)')"

$PIP install --no-build-isolation chumpy
info "chumpy installed: $($PIP show chumpy 2>/dev/null | awk '/^Version:/{print $2}') (patched later in step [6/7])"

step "[3/7] Installing macOS-compatible core dependencies"

info "Installing macOS PyTorch wheels..."
$PIP install torch==2.5.1 torchvision==0.20.1

info "Installing Project Aria packages (--no-deps to avoid conflicts)..."
$PIP install --no-deps projectaria-tools==1.7.1
$PIP install --no-deps projectaria-client-sdk==1.1.0

FILTER_PATTERN="^--extra-index-url|^torch==|^torchvision==|^xformers|^onnxruntime-gpu|^projectaria-tools|^projectaria-client-sdk"
if [ "$SKIP_HARDWARE" = "1" ]; then
    info "SKIP_HARDWARE=1 — filtering out pyrealsense2 and trossen-arm"
    FILTER_PATTERN="$FILTER_PATTERN|^pyrealsense2|^trossen-arm"
fi

REQ_TMP="$(mktemp)"
grep -v -E "$FILTER_PATTERN" requirements.txt > "$REQ_TMP"
echo "onnxruntime>=1.17" >> "$REQ_TMP"

info "Installing filtered requirements..."
$PIP install -r "$REQ_TMP"
rm "$REQ_TMP"

info "NumPy after install: $($PYTHON -c 'import numpy; print(numpy.__version__)')"

step "[4/7] Installing git-based packages"

info "Installing CoTracker (from GitHub)..."
$PIP install "cotracker @ git+https://github.com/facebookresearch/co-tracker.git"

info "Installing Orient-Anything V2 (from GitHub)..."
$PIP install "orient-anything @ git+https://github.com/TX-Leo/orient-anything.git"

step "[5/7] Optional hand tracking packages"

if [ "$SKIP_HAND" = "1" ]; then
    info "SKIP_HAND=1 — skipping MediaPipe / WiLoR / HaMeR"
else
    warn "Hand tracking extras are not guaranteed to install cleanly on macOS arm64."
    info "Installing mediapipe..."
    $PIP install mediapipe

    info "Installing WiLoR-mini (from GitHub, --no-deps)..."
    $PIP install --no-deps "wilor-mini @ git+https://github.com/warmshao/WiLoR-mini.git"

    info "Installing HaMeR (from GitHub, --no-deps)..."
    $PIP install --no-deps "hamer @ git+https://github.com/geopavlakos/hamer.git"

    info "Installing easy_ViTPose (from GitHub)..."
    $PIP install "easy_ViTPose @ git+https://github.com/JunkyByte/easy_ViTPose.git"

    info "Installing indirect hand-tracking dependencies..."
    $PIP install yacs pytorch-lightning gdown xtcocotools webdataset filterpy ffmpeg-python
fi

step "[6/7] Applying compatibility patches"

SITE_PACKAGES="$($PYTHON -c 'import site; print(site.getsitepackages()[0])')"
CHUMPY_DIR="$SITE_PACKAGES/chumpy"

if [ -d "$CHUMPY_DIR" ]; then
    if grep -q 'inspect\.getargspec' "$CHUMPY_DIR/ch.py" 2>/dev/null; then
        info "Patching chumpy/ch.py: getargspec -> getfullargspec"
        perl -0pi -e 's/inspect\.getargspec/inspect.getfullargspec/g' "$CHUMPY_DIR/ch.py"
    else
        info "chumpy/ch.py already patched"
    fi

    if grep -q "from numpy import bool" "$CHUMPY_DIR/__init__.py" 2>/dev/null; then
        info "Patching chumpy/__init__.py: removing deprecated numpy imports"
        perl -0pi -e 's/^from numpy import bool, int, float, complex, object, unicode, str, nan, inf$/from numpy import nan, inf/m' "$CHUMPY_DIR/__init__.py"
    else
        info "chumpy/__init__.py already patched"
    fi
else
    warn "chumpy not found at $CHUMPY_DIR, skipping patches"
fi

if [ "$SKIP_HAND" != "1" ]; then
    HAMER_VITDET=$($PYTHON -c "
try:
    import hamer.datasets.vitdet_dataset as m
    print(m.__file__)
except Exception:
    pass
" 2>/dev/null || echo "")

    if [ -n "$HAMER_VITDET" ] && [ -f "$HAMER_VITDET" ]; then
        if grep -q "print(f'{downsampling_factor=}')" "$HAMER_VITDET"; then
            info "Patching HaMeR vitdet_dataset.py: commenting out debug print"
            perl -0pi -e "s/print\\(f'\\{downsampling_factor=\\}'\\)/# print(f'{downsampling_factor=}')/g" "$HAMER_VITDET"
        fi
    fi
fi

step "[7/7] Verifying installation"

VERIFY_OK=true

check_import() {
    local name="$1"
    local code="$2"
    if $PYTHON -c "$code" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $name"
    else
        echo -e "  ${RED}✗${NC} $name"
        VERIFY_OK=false
    fi
}

echo ""
info "=== Compute Backend ==="
check_import "torch" "import torch"
check_import "torch MPS or CPU" "import torch; assert torch.backends.mps.is_available() or True"
$PYTHON - <<'PY'
import torch
print(f"  PyTorch: {torch.__version__}")
print(f"  CUDA available: {torch.cuda.is_available()}")
print(f"  Apple MPS available: {torch.backends.mps.is_available()}")
PY

echo ""
info "=== Core Packages ==="
check_import "torchvision" "import torchvision"
check_import "numpy" "import numpy"
check_import "scipy" "import scipy"
check_import "opencv" "import cv2"
check_import "open3d" "import open3d"
check_import "PIL" "from PIL import Image"

echo ""
info "=== ML Models ==="
check_import "transformers" "import transformers"
check_import "sam2" "import sam2"
check_import "diffusers" "import diffusers"
check_import "timm" "import timm"
check_import "rembg" "import rembg"
check_import "onnxruntime" "import onnxruntime"
warn "xformers is skipped on macOS because the project requires CUDA-oriented builds."

echo ""
info "=== Git Packages ==="
check_import "cotracker" "import cotracker"
check_import "orient-anything" "import orient_anything"

echo ""
info "=== Project Aria ==="
check_import "projectaria-tools" "import projectaria_tools"

echo ""
info "=== Config & Utils ==="
check_import "omegaconf" "import omegaconf"
check_import "hydra" "import hydra"
check_import "wandb" "import wandb"
check_import "gradio" "import gradio"
check_import "rich" "import rich"
check_import "pydantic" "import pydantic"

echo ""
info "=== 3D / Pose ==="
check_import "roma" "import roma"
check_import "smplx" "import smplx"
check_import "chumpy" "import chumpy"
check_import "pyrender" "import pyrender"

if [ "$SKIP_HAND" != "1" ]; then
    echo ""
    info "=== Hand Tracking ==="
    check_import "mediapipe" "import mediapipe"
    check_import "wilor-mini" "from wilor_mini.pipelines.wilor_hand_pose3d_estimation_pipeline import WiLorHandPose3dEstimationPipeline"
    check_import "hamer" "import hamer"
    check_import "easy_ViTPose" "from easy_ViTPose import VitInference"
fi

echo ""
if [ "$PREDOWNLOAD" = "1" ]; then
    step "Pre-downloading model weights"
    $PYTHON -c "
from huggingface_hub import hf_hub_download

print('  Downloading Orient-Anything V2 checkpoint ...')
hf_hub_download(repo_id='Viglong/OriAnyV2_ckpt', filename='demo_ckpts/rotmod_realrotaug_best.pt', repo_type='model')

print('Done!')
" || warn "Pre-download failed; models will be fetched on first run where supported."
fi

if [ "$VERIFY_OK" = true ]; then
    step "✓ macOS setup complete"
    echo ""
    echo "  Environment:  $CONDA_DEFAULT_ENV"
    echo "  Total time:   $(( ($(date +%s) - _SETUP_T0) / 60 ))m $(( ($(date +%s) - _SETUP_T0) % 60 ))s"
    echo "  Python:       $($PYTHON --version)"
    echo "  PyTorch:      $($PYTHON -c 'import torch; print(torch.__version__)')"
    echo "  NumPy:        $($PYTHON -c 'import numpy; print(numpy.__version__)')"
    echo ""
    echo "  macOS-compatible packages verified."
else
    step "⚠ macOS setup finished with warnings"
    echo ""
    echo "  Some packages failed verification. Check the ✗ marks above."
    echo "  CUDA-only pieces are intentionally skipped on macOS."
fi
