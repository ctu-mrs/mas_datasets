# MAS Datasets

Public datasets for research on state estimation based on motor angular speeds (MAS).
The datasets are open-sourced as part of our T-RO publication [1].
There are 6 datasets in total, each with a specific type of motion: *Hover, Forward, Lateral, Vertical, Rectangle, Loop*.

The rosbags contain unsynchronized LiDAR points, MAS, measurments, IMU measurements, and raw sensor data. 
Ground truth is provided via RTK GPS (Emlid Reach) INT FIX solution.

| Loop                   | Rectangle                   |
| ---                    | ---                         |
| ![](.fig/map_loop.png) | ![](.fig/map_rectangle.png) |

## Publication

- [1] Petrlik, M.; Penicka, R.; Saska, M. *Motor Angular Speed Preintegration for Multirotor UAV State Estimation*, IEEE Transactions on Robotics (in review), 2024

## Download Datasets

- To download the datasets, run script `download.sh`.
  - **Beware**, the datasets can be large!
  - All datasets will be downloaded into the `bag_files` directory.

## Requirements

The [ouster_ros](https://github.com/ctu-mrs/ouster/) for interpreting the Ouster OS-128 LiDAR data.
The [mavros_msgs](https://github.com/mavlink/mavros) for interpreting the `mavros_msgs/ESCStatus` messages containing the MAS measurements.
The [mrs_msgs](https://github.com/ctu-mrs/mrs_msgs) for interpreting the `mrs_msgs/RtkGps` messages containing the raw RTK data.

## Sensors
| X500 Back               | X500 Front               |
| ---                     | ---                      |
| ![](.fig/x500_back.png) | ![](.fig/x500_front.png) |

- OS0-128 LiDAR (128 rows, 90 deg vFoV) (top-mounted):
  - LiDAR packets: `/os_lidar_packets` of type `ouster_ros/PacketMsg`
  - IMU: `/os_imu_packets` of type `ouster_ros/PacketMsg`
  - use the [ouster_ros](https://github.com/ctu-mrs/ouster/) to decode the packets into point cloud and IMU data
- Garmin Lidar Lite (down-facing rangefinder):
  - data: `/distance_sensor` of type `sensor_msgs/Range`
- Pixhawk4 FCU
  - MAS measurements: `/pixhawk_esc_status` of type `mavros_msgs/ESCStatus`
  - IMU measurements: `/pixhawk_imu` of type `sensor_msgs/Imu`
  - Magnetic field measurements: `/pixhawk_mag_field` of type `sensor_msgs/MagneticField`
  - Barometer pressure measurements: `/pixhawk_baro` of type `sensor_msgs/FluidPressure`
- MRS IMU 
  - Measurements `/mrs_imu` of type `sensor_msgs/Imu`
  - Acceleration, angular velocity (no orientation)
  - Connected to camera which was not recorded
- Emlid Reach RTK
  - Latitude, longitude, altitude measurements: `/rtk_raw` of type `mrs_msgs/RtkGps`
- Fused ground truth
  - More accurate: `/rtk_fused_odom` of type `nav_msgs/Odometry`
  - Less accurate: `/gps_fused_odom` of type `nav_msgs/Odometry`
  - GPS (RTK) fused with barometer, distance sensor, and IMU
   
## Frames

Sensor frames:
- baselink, pixhawk: `uav25/fcu`
- os_points: `uav25/os_lidar`
- os_imu: `uav25/os_imu`
- mrs_imu: `uav25/vio_imu`
- distance sensor: `uav25/garmin`
- 

```
uav25/fcu
├───> uav25/os_sensor
│     ├───> uav25/os_lidar
│     └───> uav25/os_imu
├───> uav25/garmin
├───> uav25/vio_imu
```

## Dataset parameters

![](.fig/dataset_params.png)

## Example tmuxinator session

The `./tmux` folder contains an example _tmuxinator_ session that shows the recorded data in rviz.
