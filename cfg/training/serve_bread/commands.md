## Baselines

```bash
# HumanEgo (Ours)
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp Baselines --job 01_HumanEgo

# EgoZero
python -m training.baselines.EgoZero.trainer --task serve_bread --exp Baselines --job 02_EgoZero
python -m training.baselines.EgoZero.trainer --task serve_bread --exp Baselines --job 02_EgoZero_ObjectCentric

# PointPolicy
python -m training.baselines.PointPolicy.trainer --task serve_bread --exp Baselines --job 03_PointPolicy
python -m training.baselines.PointPolicy.trainer --task serve_bread --exp Baselines --job 03_PointPolicy_ObjectCentric

# SPOT
python -m training.baselines.SPOT.trainer --task serve_bread --exp Baselines --job 04_SPOT
python -m training.baselines.SPOT.trainer --task serve_bread --exp Baselines --job 04_SPOT_ObjectCentric

# Track2Act
python -m training.baselines.Track2Act.trainer --task serve_bread --exp Baselines --job 05_Track2Act
python -m training.baselines.Track2Act.trainer --task serve_bread --exp Baselines --job 05_Track2Act_ObjectCentric

# ZeroMimic
python -m training.baselines.ZeroMimic.trainer --task serve_bread --exp Baselines --job 06_ZeroMimic
python -m training.baselines.ZeroMimic.trainer --task serve_bread --exp Baselines --job 06_ZeroMimic_ObjectCentric
```

## DataSource

```bash
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp DataSource --job 00_Human
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp DataSource --job 01_Teleop
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp DataSource --job 02_Teaching
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp DataSource --job 03_CoTraining_TeleopAndTeaching
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp DataSource --job 04_CoTraining_TeleopAndHuman
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp DataSource --job 05_CoTraining_TeachingAndHuman
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp DataSource --job 06_CoTraining_TeleopAndTeachingAndHuman
```

## VisualInput

```bash
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 01_rgb
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 02_rgb_WArmKpts
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 03_rgb_WArmObjKpts
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 04_rgb_WoArm
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 05_rgb_WoArm_WArmKpts
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 06_rgb_WoArm_WArmObjKpts
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 07_rgb_WoArmObj
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 08_rgb_WoArmObj_WArmKpts
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 09_rgb_WoArmObj_WArmObjKpts
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp VisualInput --job 10_NoImg
```

## XCentric

```bash
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp XCentric --job 01_EgoCentricCameraFrame
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp XCentric --job 02_EgoCentricAnchorFrame
```

## XFrame

```bash
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp XFrame --job 01_AnchorFrame
```

## ScalingLaw

```bash
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp ScalingLaw --job 01_DataNum1
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp ScalingLaw --job 02_DataNum3
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp ScalingLaw --job 03_DataNum5
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp ScalingLaw --job 04_DataNum10
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp ScalingLaw --job 05_DataNum20
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp ScalingLaw --job 06_DataNum30
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp ScalingLaw --job 07_DataNum40
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp ScalingLaw --job 08_DataNum50
```

## HandTracking

```bash
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp HandTracking --job 01_MediaPipe
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp HandTracking --job 02_WiLoR
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp HandTracking --job 03_HaMeR
```

## AuxTraining

```bash
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 01_AuxObjVisCont
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 01_AuxObjVisCont_DataNum1
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 01_AuxObjVisCont_DataNum3
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 01_AuxObjVisCont_DataNum5
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 01_AuxObjVisCont_DataNum10
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 01_AuxObjVisCont_DataNum20
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 02_AuxObj
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 02_AuxObj_DataNum3
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 02_AuxObj_DataNum5
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 03_AuxVis
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 03_AuxVis_DataNum3
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 03_AuxVis_DataNum5
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 04_AuxCont
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 04_AuxCont_DataNum3
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 04_AuxCont_DataNum5
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 05_AuxObjVis
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 05_AuxObjVis_DataNum3
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 05_AuxObjVis_DataNum5
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 06_AuxObjCont
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 06_AuxObjCont_DataNum3
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 06_AuxObjCont_DataNum5
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 07_AuxVisCont
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 07_AuxVisCont_DataNum3
python -m training.FlowMatchingTrainer --use_cfg --task serve_bread --exp AuxTraining --job 07_AuxVisCont_DataNum5
```

## RobotBaselines

```bash
# ── N=1 ──
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 01_Teleop_ACT_N1
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 01_Teleop_ACT_N1_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 01_Teleop_DP_N1
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 01_Teleop_DP_N1_ObjectCentric
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 01_Teaching_ACT_N1
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 01_Teaching_ACT_N1_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 01_Teaching_DP_N1
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 01_Teaching_DP_N1_ObjectCentric

# ── N=3 ──
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 02_Teleop_ACT_N3
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 02_Teleop_ACT_N3_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 02_Teleop_DP_N3
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 02_Teleop_DP_N3_ObjectCentric
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 02_Teaching_ACT_N3
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 02_Teaching_ACT_N3_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 02_Teaching_DP_N3
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 02_Teaching_DP_N3_ObjectCentric

# ── N=5 ──
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 03_Teleop_ACT_N5
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 03_Teleop_ACT_N5_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 03_Teleop_DP_N5
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 03_Teleop_DP_N5_ObjectCentric
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 03_Teaching_ACT_N5
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 03_Teaching_ACT_N5_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 03_Teaching_DP_N5
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 03_Teaching_DP_N5_ObjectCentric

# ── N=10 ──
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 04_Teleop_ACT_N10
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 04_Teleop_ACT_N10_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 04_Teleop_DP_N10
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 04_Teleop_DP_N10_ObjectCentric
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 04_Teaching_ACT_N10
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 04_Teaching_ACT_N10_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 04_Teaching_DP_N10
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 04_Teaching_DP_N10_ObjectCentric

# ── N=20 ──
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 05_Teleop_ACT_N20
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 05_Teleop_ACT_N20_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 05_Teleop_DP_N20
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 05_Teleop_DP_N20_ObjectCentric
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 05_Teaching_ACT_N20
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 05_Teaching_ACT_N20_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 05_Teaching_DP_N20
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 05_Teaching_DP_N20_ObjectCentric

# ── N=30 ──
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 06_Teleop_ACT_N30
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 06_Teleop_ACT_N30_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 06_Teleop_DP_N30
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 06_Teleop_DP_N30_ObjectCentric
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 06_Teaching_ACT_N30
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 06_Teaching_ACT_N30_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 06_Teaching_DP_N30
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 06_Teaching_DP_N30_ObjectCentric

# ── N=40 ──
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 07_Teleop_ACT_N40
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 07_Teleop_ACT_N40_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 07_Teleop_DP_N40
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 07_Teleop_DP_N40_ObjectCentric
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 07_Teaching_ACT_N40
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 07_Teaching_ACT_N40_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 07_Teaching_DP_N40
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 07_Teaching_DP_N40_ObjectCentric

# ── N=50 ──
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 08_Teleop_ACT_N50
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 08_Teleop_ACT_N50_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 08_Teleop_DP_N50
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 08_Teleop_DP_N50_ObjectCentric
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 08_Teaching_ACT_N50
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 08_Teaching_ACT_N50_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 08_Teaching_DP_N50
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 08_Teaching_DP_N50_ObjectCentric

# ── N=60 ──
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 09_Teleop_ACT_N60
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 09_Teleop_ACT_N60_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 09_Teleop_DP_N60
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 09_Teleop_DP_N60_ObjectCentric
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 09_Teaching_ACT_N60
python -m training.baselines.ACT.trainer --task serve_bread --exp RobotBaselines --job 09_Teaching_ACT_N60_ObjectCentric
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 09_Teaching_DP_N60
python -m training.baselines.DP.trainer  --task serve_bread --exp RobotBaselines --job 09_Teaching_DP_N60_ObjectCentric
```