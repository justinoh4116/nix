{pkgs, ...}: {
  config = {
    services = {
      dbus.packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];
      gnome = {
        gnome-keyring.enable = true;

        gcr-ssh-agent.enable = false;
      };
      gvfs.enable = true;
    };
  };
}
