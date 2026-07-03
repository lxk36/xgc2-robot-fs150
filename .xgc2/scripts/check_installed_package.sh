#!/usr/bin/env bash
set -euo pipefail

dpkg -s xgc2-fs150 >/dev/null
test -d /opt/xgc2/robots/fs150/docs
test -f /opt/xgc2/robots/fs150/README.md
test -f /opt/xgc2/robots/fs150/docs/rk356x_performance_mode.md
test -f /opt/xgc2/robots/fs150/onboard/README.md
test -f /opt/xgc2/robots/fs150/px4/README.md
test -f /usr/share/doc/xgc2-fs150/README

echo "Installed FS150 robot package check passed"
