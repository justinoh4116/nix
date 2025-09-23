{
  # keys,
  pkgs,
  ...
}: {
  users.users.justin = {
    isNormalUser = true;

    # Home directory
    createHome = true;
    home = "/home/justin";

    # Should be generated manually. See option documentation
    # for tips on generating it. For security purposes, it's
    # a good idea to use a non-default hash.
    initialHashedPassword = "$6$.k75B0CMN/S7.SOR$7VR.R7nxwXSIFtjOKFD9tn8QC9HZ0IhlPwd8/zdxGUFwFYBySUG6ehckw23OCHxqvDx.anuS99RAm7tPjo5NI0";
    # openssh.authorizedKeys.keys = [keys.justin];
    extraGroups = [
      "wheel"
      "systemd-journal"
      "audio"
      "video"
      "uinput"
      "tty"
      "dialout"
      "ydotool"
      "input"
      "plugdev"
      "lp"
      "tss"
      "power"
      "nix"
      "network"
      "networkmanager"
      "wireshark"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
    ];
  };
}
