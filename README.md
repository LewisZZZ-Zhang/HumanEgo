# HumanEgo

Public release repository for the HumanEgo project.

This repository hosts the curated, externally-published subset of the HumanEgo
codebase. Files here are mirrored from the internal development repository by
an automated sync step; do not edit them directly here — open issues or PRs
against the relevant upstream files instead.

Project page: https://humanego-ai.github.io

## Contents

- `datacollection/AriaMPS.py` — Project Aria MPS launcher used during capture
- `preprocess/` — preprocessing pipeline (Aria SLAM/Hands, DINO-SAM, depth, etc.)
- `training/FlowMatching*.py` — flow-matching policy: model, dataloader, trainer, evaluator
- `utils/` — shared math / IO / visualisation helpers
- `cfg/datacollection/`, `cfg/preprocess/`, `cfg/training/` — YAML configs

## Project Aria devignetting masks

The `preprocess/aria_devignetting_masks/` calibration binaries are **not**
included here (~240 MB total). They are redistributed assets from Meta's
Project Aria; download them from Project Aria's official channels and place
them at `preprocess/aria_devignetting_masks/{old,new}_isp/*.bin` before running
the preprocessing pipeline.
