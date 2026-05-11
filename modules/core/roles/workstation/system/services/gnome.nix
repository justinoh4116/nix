{pkgs, ...}: {
  config = {
    # security.pam.services.justin.enableGnomeKeyring = true;
    programs.seahorse.enable = true;
    services = {
      dbus.packages = with pkgs; [
        # gcr
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
