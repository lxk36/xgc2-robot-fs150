# XGC2 Robot FS150

This repository stores real-vehicle resources for the FS150 aircraft used by
XGC2.  It is separate from the Gazebo/SITL package:

```text
products/robotics/fs150
  Real aircraft resources: onboard computer, PX4 export notes, wiring,
  runtime configuration, field-debug notes.

products/ros1/simulator/gazebo-sim/fs150-sitl
  ROS/Gazebo/PX4 SITL wrapper and simulation model.
```

The repository is intended for resources that are tied to the physical FS150
platform and should follow the aircraft across deployments.

## Source Layout

```text
docs/       Vehicle-level notes and debug records.
onboard/    Onboard-computer resources, service files, router config notes,
            CPU/performance tuning, startup commands.
px4/        Real PX4 firmware/parameter export notes and airframe details.
```

## Current Notes

- RK356x/RK3566 onboard-computer CPU governor modes and performance-mode
  commands are documented in
  [docs/rk356x_performance_mode.md](docs/rk356x_performance_mode.md).

## Repository Boundary

This repository owns:

- real FS150 onboard-computer runtime notes and configuration references;
- real PX4 parameter/firmware export notes;
- real-vehicle port, sensor, and field-test records.

This repository does not own:

- Gazebo SDF/URDF models;
- SITL launch files;
- controller source code;
- generated logs, rosbags, PX4 ULog files, or packet captures.

## License

Proprietary.  This repository is public for integration visibility, but it does
not grant redistribution or reuse rights beyond the project owner's intent.
