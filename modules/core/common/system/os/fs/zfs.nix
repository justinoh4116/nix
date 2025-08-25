{
  config,
  lib,
  pkgs,
  ...
}: let
  check-pool-health = pkgs.writeShellScript "check-pool-health" ''
    PO_TOKEN=$(cat "${config.age.pushover-zfs-token.path}")
    PO_UK=$(cat "${config.age.pushover-zfs-user.path}")

    SUDO=""
    if [[ $(id -u) -ne 0 ]]; then
      SUDO="sudo"
    fi

    notify="$($SUDO ${pkgs.zfs}/bin/zpool status -x)"

    ${pkgs.curl}/bin/curl -s -F "token=$PO_TOKEN" \
    -F "user=$PO_UK" \
    -F "title=${config.networking.hostName} zpool status" \
    -F "message=$notify" https://api.pushover.net/1/messages.json
  '';

  zfsCompatibleKernelPackages =
    lib.filterAttrs (
      name: kernelPackages:
        (builtins.match "linux_[0-9]+_[0-9]+" name)
        != null
        && (builtins.tryEval kernelPackages).success
        && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
    )
    pkgs.linuxKernel.packages;
  latestZfsKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version
      b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );

  cfg = config.modules.system.fs.zfs;
  sys = config.modules.system;
in {
  config = lib.mkIf cfg.enable {
    services.zfs.autoScrub.enable = cfg.autoScrub;

    # makes sure the kernel is compatible with zfs if zfs is enabled
    sys.boot.kernel = latestZfsKernelPackage;

    systemd.timers = {
      checkpoolhealth = {
        timerConfig = {
          Unit = "checkpoolhealth.service";
          OnCalendar = "*-*-* 8:00:00";
        };
        wantedBy = ["timers.target"];
      };
    };

    systemd.services = {
      checkpoolhealth = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${check-pool-health}";
        };
      };
    };

    services = {
      sanoid = {
        enable = cfg.snapshots;
        datasets."zpool/safe" = {
          autosnap = true;
          autoprune = true;
          recursive = true;
          frequently = 8;
          hourly = 24;
          daily = 7;
          weekly = 12;
        };
      };
    };

    boot.zfs.extraPools = cfg.poolsToImport;
  };
}
