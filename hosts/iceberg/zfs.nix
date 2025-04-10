{
  config,
  lib,
  pkgs,
  ...
}: let
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
    -F "title=zpool status" \
    -F "message=$notify" https://api.pushover.net/1/messages.json
  '';
in {
  services.zfs.autoScrub.enable = true;

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

  age.secrets.zfs-pushover-token.file = ../../secrets/zfs-pushover-token.age;
  age.secrets.pushover-user-key.file = ../../secrets/pushover-user-key.age;
}
