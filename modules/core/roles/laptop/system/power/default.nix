{
  config,
  pkgs,
  ...
}: {
  imports = [./auto-cpufreq.nix];
  config = {
    environment.systemPackages = with pkgs; [
      acpi
      powertop
    ];

    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };

    # Brightness control via xbacklight from users in the video group. This is
    # unnecessary on most systems as brightnessctl in combination with hardware keys
    # will allow you to control the brightness without additional privileges.
    hardware.acpilight.enable = false;

    services = {
      # DBus service that provides power management support to applications. In addition
      # to providing a standard interface for applications to query the power state and
      # request changes, it also provides a central place for applications to listen for
      # power changes. Some services (such as AGS) will inherently depend on this being
      # enabled, so we enable it unconditionally on laptops for power management.
      upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        # criticalPowerAction = "Hibernate";
      };

      # Handle ACPI events via the ACPI daemon. Some functionality
      # is already provided by logind.
      acpid = {
        enable = true;
        logEvents = true;
      };
    };

    systemd.services."unload-mediatek-before-hibernate" = {
      description = "Unloads mediatek driver before hibernate (fuck you amd)";
      wantedBy = ["hibernate.target"];
      before = ["systemd-hibernate.service"];
      script = ''
        ${pkgs.kmod}/bin/modprobe -r mt7921e
      '';
      serviceConfig.Type = "simple";
    };

    systemd.services."reload-mediatek-after-hibernate" = {
      description = "Reloads mediatek driver after hibernate (fuck you amd)";
      wantedBy = ["hibernate.target"];
      after = ["systemd-hibernate.service"];
      script = ''
        ${pkgs.kmod}/bin/modprobe mt7921e
      '';
      serviceConfig.Type = "simple";
    };
  };
}
