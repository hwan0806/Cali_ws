#ROOT="/home/gil/Downloads/Livox_cali"
ROOT="./"
CAM_MODEL="fisheye"
INTRINSIC="511.244537,511.573395,986.686218,562.944397"
DIST_COEF="0.117343001,-0.0315180011,0.000775000022,0.000146000006"

# Preprocessing
docker run \
  -it \
  --rm \
  --net host \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v $ROOT/bags:/tmp/input_bags \
  -v $ROOT/results:/tmp/preprocessed \
  koide3/direct_visual_lidar_calibration:noetic \
  rosrun direct_visual_lidar_calibration preprocess -adv \
  --camera_model $CAM_MODEL \
  --camera_intrinsic $INTRINSIC \
  --camera_distortion_coeffs $DIST_COEF \
  /tmp/input_bags /tmp/preprocessed

# Initial guess
docker run \
  --rm \
  --net host \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v $ROOT/results:/tmp/preprocessed \
  koide3/direct_visual_lidar_calibration:noetic \
  rosrun direct_visual_lidar_calibration initial_guess_manual /tmp/preprocessed

# Fine registration
docker run \
  --rm \
  --net host \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v $ROOT/results:/tmp/preprocessed \
  koide3/direct_visual_lidar_calibration:noetic \
  rosrun direct_visual_lidar_calibration calibrate /tmp/preprocessed

# Result inspection
docker run \
  --rm \
  --net host \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v $ROOT/results:/tmp/preprocessed \
  koide3/direct_visual_lidar_calibration:noetic \
  rosrun direct_visual_lidar_calibration viewer /tmp/preprocessed
