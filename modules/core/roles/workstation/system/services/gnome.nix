{pkgs, ...}: {
  config = {
    security.pam.services.justin.enableGnomeKeyring = true;
    services = {
      dbus.packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];
      gnome = {
        gnome-keyring.enable = true;

        gcr-ssh-agent.enable = true;
      };
      gvfs.enable = true;
    };
  };
}
