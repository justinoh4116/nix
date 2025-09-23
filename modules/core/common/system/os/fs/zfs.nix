{
  config,
  lib,
  pkgs,
  ...
}: let
  sys = config.modules.system;
  cfg = sys.fs.zfs;

  check-pool-health = pkgs.writeShellScript "check-pool-health" ''
    PO_TOKEN=$(cat "${config.age.secrets.zfs-pushover-token.path}")
    PO_UK=$(cat "${config.age.secrets.pushover-user-key.path}")

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
in {
  config = lib.mkIf cfg.enable {
    modules = {
      # makes sure the kernel is compatible with zfs if zfs is enabled
      system.boot.kernel = lib.mkForce latestZfsKernelPackage;
    };

    services.zfs.autoScrub.enable = cfg.autoScrub;

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
