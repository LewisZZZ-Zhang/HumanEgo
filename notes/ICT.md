ICT means **Interaction-Centric Token** in this repo: a fixed-length token representation of the current hands and objects, designed so the policy can reason about “where is the hand relative to each object?” rather than only absolute poses.

The clearest definition is in [utils/ict.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/utils/ict.py:1):

```text
[TypeID(1), pose_in_ref(9), hand_in_entity(9), flag(1)] = 20 dims
```

For single-hand training, one ICT token has:

```text
type_id          1 dim
pose_in_ref      9 dims = normalized xyz position + 6D rotation
hand_in_entity   9 dims = hand pose expressed in this token/entity frame
flag             1 dim = grasp for hand tokens, -1 for object tokens
```

So:

```text
1 + 9 + 9 + 1 = 20 dims
```

For dual-hand, it stores both hands’ relative poses:

```text
1 + 9 + 18 + 1 = 29 dims
```

Evidence: `FlowMatchingDataloader` sets `self.ict_dim = 20 if self.single_hand else 29` and comments the layout directly in [FlowMatchingDataloader.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/training/FlowMatchingDataloader.py:211). The model repeats the same ICT dimension contract in [FlowMatchingModel.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/training/FlowMatchingModel.py:212).

**Token Types**

Defined in [FlowMatchingDataloader.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/training/FlowMatchingDataloader.py:68):

```text
0 = padding
1 = left hand
2 = right hand
3 = anchor object
4 = other object
```

**How It Is Built**

`_build_ict()` reads `training_data.json`, gets hand and object transforms, chooses a reference frame, and emits tokens plus a validity mask.

Reference frame evidence: [FlowMatchingDataloader.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/training/FlowMatchingDataloader.py:279)

```text
anchor_frame -> virtual_static_anchor
camera_frame -> cam0
```

Geometry encoding evidence: [FlowMatchingDataloader.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/training/FlowMatchingDataloader.py:289)

```text
4x4 transform -> normalized position xyz + normalized 6D rotation
```

Hand token evidence: [FlowMatchingDataloader.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/training/FlowMatchingDataloader.py:336)

```text
[type_id, pose_in_ref, hand_in_hand/entity, grasp]
```

Object token evidence: [FlowMatchingDataloader.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/training/FlowMatchingDataloader.py:362)

```text
anchor object token first, then other object tokens
[type_id, pose_in_ref, hand_in_object, -1]
```

Finally it pads to `max_ict` and creates `ict_mask` in [FlowMatchingDataloader.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/training/FlowMatchingDataloader.py:390).

**Why It Is “Interaction-Centric”**

The important part is `hand_in_entity`: for each entity token, the code computes the hand pose in that entity’s coordinate frame:

```python
T_w2ent = np.linalg.inv(T_ent_w)
hand_relative = T_w2ent @ T_h
```

That happens in [FlowMatchingDataloader.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/training/FlowMatchingDataloader.py:325). So an object token does not just say “the plate is here”; it also says “the hand is here relative to the plate.” That is the core interaction signal.

**Train/Inference Match**

At robot inference, `policy.py` rebuilds the same ICT format from robot end-effector poses and object poses. It explicitly says token order must match training: hands first, then anchor object, then other objects ([policy.py](/Users/lewis/SchoolWorks/06_Junior_Spring/research1/HumanEgo/inference/policy.py:197)). This is how human-hand demonstrations transfer to robot EE control: the robot EE is encoded as the same kind of “hand” token.