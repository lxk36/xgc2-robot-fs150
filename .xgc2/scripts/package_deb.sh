#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

OUTPUT_DIR=""
PACKAGE="xgc2-fs150"
INSTALL_PREFIX="/opt/xgc2/robots/fs150"

product_version() {
  awk -F': *' '/^version:[[:space:]]*/ {print $2; exit}' "${REPO_ROOT}/.xgc2/product.yml"
}

VERSION="${PACKAGE_VERSION:-$(product_version)}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output-dir)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --install-root)
      # Accepted for compatibility with other XGC2 package scripts.  This
      # repository packages source-owned data directly.
      shift 2
      ;;
    *)
      echo "unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "${OUTPUT_DIR}" ]]; then
  echo "--output-dir is required" >&2
  exit 1
fi

if [[ -z "${VERSION}" ]]; then
  echo "package version is missing" >&2
  exit 1
fi

BUILD_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "${BUILD_DIR}"
}
trap cleanup EXIT

mkdir -p "${OUTPUT_DIR}"
rm -f "${OUTPUT_DIR}/${PACKAGE}_"*.deb

pkg_root="${BUILD_DIR}/${PACKAGE}"
target_root="${pkg_root}${INSTALL_PREFIX}"
mkdir -p \
  "${pkg_root}/DEBIAN" \
  "${pkg_root}/usr/share/doc/${PACKAGE}" \
  "${target_root}"

for path in README.md docs onboard px4; do
  if [[ -e "${REPO_ROOT}/${path}" ]]; then
    cp -a "${REPO_ROOT}/${path}" "${target_root}/"
  fi
done

cat > "${pkg_root}/DEBIAN/control" <<EOF
Package: ${PACKAGE}
Version: ${VERSION}
Section: metapackages
Priority: optional
Architecture: all
Maintainer: XGC2 <apt@example.com>
Depends: chrony, python3, ros-noetic-ros-base, ros-noetic-mavros, ros-noetic-mavros-extras, ros-noetic-vrpn-client-ros, ros-noetic-xgc2-linux-utils, xgc2-mavlink-router
Recommends: htop, i2c-tools, iproute2, net-tools, python3-pip, socat, tmux, usbutils
Description: XGC2 FS150 real-vehicle profile
 Real FS150 robot/onboard aggregation package for XGC2.
 It installs FS150 vehicle resources under /opt/xgc2/robots/fs150 and pulls
 the ROS Noetic, MAVROS, VRPN, MAVLink router, and Linux utility dependencies
 expected on the FS150 onboard computer.
EOF

cat > "${pkg_root}/usr/share/doc/${PACKAGE}/README" <<EOF
XGC2 FS150 Robot

Installed resources:
  ${INSTALL_PREFIX}

This package does not enable or start flight-runtime services automatically.
EOF

find "${pkg_root}" -type d -exec chmod 0755 {} +
find "${pkg_root}" -type f -exec chmod 0644 {} +
chmod 0755 "${pkg_root}/DEBIAN"

fakeroot dpkg-deb --build "${pkg_root}" "${OUTPUT_DIR}/${PACKAGE}_${VERSION}_all.deb" >/dev/null
find "${OUTPUT_DIR}" -maxdepth 1 -type f -name "${PACKAGE}_*.deb" -print | sort
