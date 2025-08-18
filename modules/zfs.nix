{
  config,
  lib,
  pkgs,
  ...
}: let
  check-pool-health = pkgs.writeShellScript "check-pool-health" ''
    PO_TOKEN=$(cat "${cfg.pushoverTokenPath}")
    PO_UK=$(cat "${cfg.pushoverUserKeyPath}")

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
  cfg = config.modules.zfs;
in {
  options.modules.zfs = {
    enable = lib.mkEnableOption "zfs stuff";
    enableSnapshots = lib.mkEnableOption "zfs snapshots";
    enableNotifications = lib.mkEnableOption "zfs pool health notifications";
    pushoverTokenPath = lib.mkOption {
      type = lib.types.path;
    };
    pushoverUserKeyPath = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services.zfs.autoScrub.enable = true;

    systemd.timers = lib.mkIf cfg.enableNotifications {
      checkpoolhealth = {
        timerConfig = {
          Unit = "checkpoolhealth.service";
          OnCalendar = "*-*-* 8:00:00";
        };
        wantedBy = ["timers.target"];
      };
    };

    systemd.services = lib.mkIf cfg.enableNotifications {
      checkpoolhealth = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${check-pool-health}";
        };
      };
    };

    services = {
      sanoid = {
        enable = cfg.enableSnapshots;
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
  };
}
