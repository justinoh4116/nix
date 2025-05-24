{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zpool/local/root@blank
  '';

  environment.persistence."/persist" = {
    enable = true; # NB: Defaults to true, not needed
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/fprint"
      "/var/lib/tailscale"
      "/etc/ssh"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.justin = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "VirtualBox VMs"
        ".zen"
        ".vim"
        ".local/share/fish"
        ".local/share/z"
        ".local/state/nvim"
        ".local/state/wireplumber"
        ".local/share/nvim"
        "persist"
        "nextcloud"
        ".config/fish"

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".local/share/direnv"
      ];
      files = [
        ".screenrc"
      ];
    };
  };
}
