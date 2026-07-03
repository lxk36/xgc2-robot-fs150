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

## Package

- Product id: `xgc2-fs150`
- Source path: `products/robotics/fs150`
- Release branch: `main`
- Package type: mixed Debian profile package
- Published package:
  - `xgc2-fs150`

The package is a real-vehicle aggregation package.  It installs the FS150
resources under `/opt/xgc2/robots/fs150` and depends on the ROS Noetic,
MAVROS, VRPN, MAVLink router, and XGC2 Linux utility packages expected on the
onboard computer.

`pymavlink` is useful for low-level MAVLink debugging, but it is not available
as a standard Ubuntu Focal/ROS Noetic APT package in the checked repositories.
Install it separately for debug sessions if needed.

The `xgc2-fs150` package itself does not install, enable, or start FS150
flight-runtime systemd services.  Services that can claim serial ports, change
CPU governor behavior, or alter flight-runtime state should be added and
enabled by an explicit deployment step.  Dependency packages may still keep
their own standard Debian service behavior.

## Install

Configure both the ROS Noetic APT source and the XGC2 APT source first.  Then:

```bash
sudo apt update
sudo apt install xgc2-fs150
```

Smoke test:

```bash
test -d /opt/xgc2/robots/fs150/docs
test -f /opt/xgc2/robots/fs150/docs/rk356x_performance_mode.md
dpkg -s xgc2-fs150
```

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
- real-vehicle port, sensor, and field-test records;
- the `xgc2-fs150` real-vehicle aggregation Debian package.

This repository does not own:

- Gazebo SDF/URDF models;
- SITL launch files;
- controller source code;
- generated logs, rosbags, PX4 ULog files, or packet captures.

## License

Proprietary.  This repository is public for integration visibility, but it does
not grant redistribution or reuse rights beyond the project owner's intent.
