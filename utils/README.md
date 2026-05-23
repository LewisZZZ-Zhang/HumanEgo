# Installation

## One-Click (Recommended)
```bash
git clone https://github.com/TX-Leo/AriaMimic.git
cd AriaMimic
conda env create -n aria python=3.11
conda activate aria
bash setup.sh
```

This creates a conda environment `aria` (Python 3.11) and installs everything automatically, including:
- Core ML stack (PyTorch + CUDA, transformers, SAM2, etc.)
- Orient-Anything V2 (auto-installed from GitHub as pip package)
- CoTracker (auto-installed from GitHub)
- Hand tracking methods (MediaPipe, WiLoR, HaMeR)
- Robot hardware SDKs (RealSense, Trossen Arm)

**Options:**
```bash
SKIP_HAND=1 bash scripts/setup.sh       # skip other hand tracking packages (MediaPipe, WiLoR, HaMeR)
SKIP_HARDWARE=1 bash scripts/setup.sh    # skip pyrealsense2 & trossen-arm
PREDOWNLOAD=1 bash scripts/setup.sh      # pre-download all model weights
```

# Collect Your Own Data
Pipeline and tips for data collection: [README_aria_data_collection.md](./README_aria_data_collection.md)


# Download My Training Data
for all data (70 data, ~20k): 

```
python -m script.hf_data_download
``` 

for example data(1 data, ~300):

```
python -m script.hf_data_download_examples
``` 

# Download My Orig Aria Data
for one testing vrs file:
```
python -m scripts.hf_data_download_examples_orig_aria_data
```


# Preprocess The Example Orig Aria Data
```
python -m preprocess.Preprocess --mps_path  "./data/water_flowers/water_flowers_1/mps_water_flowers_1_000_vrs_test/"
```


# Trainining
## Download My Training Data for Serve Bread
Totally I got 43 data for serve_bread_0.

```
python -m scripts.hf_data_download_examples_training_data_serve_bread_0 --limit 11
```

## training
Flow Matching - Stable Version 1 (03/10/2026)
```
python -m training.stable_FM_v1.ManipTrainerFM \
    --out_dir ./runs/serve_bread/serve_bread_0/stable_FM_v1/baseline \
    --single_hand --single_hand_side "right" \
    --no_mask --no_guide \
    --pred_horizon 50 \
    \
    --batch_size 32 \
    --epochs 400 \
    --lr 1e-4 \
    --weight_decay 1e-4 \
    --num_workers 8 \
    \
    --use_ema --ema_decay 0.999 \
    \
    --vision_embed_dim 384 \
    --num_decoder_layers 6 \
    --num_heads 8 \
    --mlp_ratio 4.0 \
    --dropout 0.05 \
    \
    --num_inference_steps 20 \
    --model_h_weighting "uniform" \
    \
    --eval_every 1 --rollout_every 10 --vis_every 10 --vis_eval_every 10 \
    \
    --w_pos 2.0 --w_rot 1.0 --w_g 10.0 \
    \
    --train_mps \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_001_vrs" \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_002_vrs" \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_003_vrs" \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_004vrs" \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_005_vrs" \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_006_vrs" \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_007_vrs" \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_008_vrs" \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_009_vrs" \
        "./data/serve_bread/serve_bread_0/mps_serve_bread_0_010_vrs" \
    --eval_mps "./data/serve_bread/serve_bread_0/mps_serve_bread_0_000_vrs"
```

Flow Matching - Beta Version 1 (03/11/2026)
```
python -m training.ManipTrainerFM \
    --out_dir ./runs/serve_bread/serve_bread_0_FM_v2/00_baseline \
    --single_hand --single_hand_side "right" \
    --pred_horizon 50 \
    --batch_size 32 \
    --epochs 400 \
    --lr 1e-4 \
    --weight_decay 1e-4 \
    --num_workers 8 \
    --use_ema --ema_decay 0.999 \
    --vision_embed_dim 384 \
    --num_decoder_layers 6 \
    --num_heads 8 \
    --dropout 0.05 \
    --num_inference_steps 20 \
    --model_h_weighting "uniform" \
    --eval_every 1 --vis_eval_every 50 \
    --w_flow 1.0 --w_foresight 20.0 --w_contrastive 0.1 \
    --w_pos 2.0 --w_rot 1.0 --w_g 10.0 \
    --img_name "rgb_WoArm_WArmObjKpts.png" \
    --frame_mode "object_centric" \
    --action_mode "absolute" \
    --use_ot_cfm \
    --no_aug_stride
```

# Inference

## Serve Bread
```
bash scripts/inference_serve_bread.sh
```




Acknowledgement:
- Meta Aria Gen1 Glasses / Aria MPS
- Trossen Arm
- CoTracker3
- Grounding DINO
- SAM2
- HaMeR
- WiLoR
- MediaPipe
- LaMa
- OrientAnything V2