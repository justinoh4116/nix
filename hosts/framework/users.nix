{
  pkgs,
  config,
  lib,
  ...
}: {
  users = {
    mutableUsers = false;
    users.root.initialHashedPassword = "$6$1q.Wc8znfb/9VYmg$G4qUsfrKXAOXg7byXw5KBicZXMRm.q70si8RrBHSH94HQdGUY0iYOogjb.jksEkS7MwbgiFKWSg25G1tpYYoz1";

    users.justin = {
      initialHashedPassword = "$6$.k75B0CMN/S7.SOR$7VR.R7nxwXSIFtjOKFD9tn8QC9HZ0IhlPwd8/zdxGUFwFYBySUG6ehckw23OCHxqvDx.anuS99RAm7tPjo5NI0";
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "wheel"
        "uinput"
        "input"
        "tty"
        "dialout"
        "networkmanager"
        "libvirtd"
        "kvm"
        "qemu-libvirtd"
        "ydotool"
      ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        htop
        tree
        cmake
      ];
    };
  };
}
