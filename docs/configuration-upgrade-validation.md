# Configuration upgrade validation

The first version carrying the conffiles fix is 0.1.0-18. The old 0.1.0-17
package treats router.conf and onboard.env as ordinary payload. Upgrade with the
operator's explicit conffile policy (the tests use `--force-confold`); dpkg records
migration conflicts and preserves local content before replacing payload. No
post-unpack restoration script or second configuration store is required.

Two complementary tests exist:

- `test_configuration_upgrade.py router.deb` inspects the actual new package's
  conffiles and payload, then uses dependency-free fixtures for unchanged/changed
  upstream defaults, local edits, repeated upgrades, and remove versus purge.
- `test_actual_configuration_upgrade.py old.deb new.deb` installs the complete
  unmodified old/new packages in a fresh disposable Docker container, with the
  real declared router dependency installed and no `--force-depends`. It checks
  edited and factory configurations, repeated upgrade, dpkg conffile metadata,
  user config.d preservation on upgrade/remove and removal on purge, and executes
  the actual maintainer scripts. A systemctl boundary recorder records all calls;
  enable/start/restart are forbidden. This does not exercise a running systemd
  manager, UART, MAVROS, or flight hardware.

Build both packages using each version's original `.xgc2/scripts/package_deb.sh`.
The legacy source is e09c035d164ded2ad66258d543cf18358d56fe5d. Run only in a disposable
container, not on a workstation or robot:

```bash
dpkg -i /artifacts/xgc2-mavlink-router_*.deb
python3 .xgc2/scripts/test_actual_configuration_upgrade.py \
  /artifacts/old/xgc2-fs150-mavlink-router_0.1.0-17_all.deb \
  /artifacts/new/xgc2-fs150-mavlink-router_0.1.0-18_all.deb
```

Local Focal validation used the genuine router dependency built from
056580c563080e48bc7f60380b288e02b3b7cb31 with its standard Meson build/test/install
and Debian packager, version 3.0.0-13+focal. Both complete-package upgrade scenarios
passed and 74 actual maintainer-script systemctl calls contained no enable/start/
restart. The four existing payload fixture tests also passed. These local build
artifacts do not establish that the central APT repository has published a version;
release and parent pin acceptance remain separate.
