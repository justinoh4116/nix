{
  config,
  pkgs,
  inputs,
  ...
}: let
  hibernateEnvironment = {
    HIBERNATE_SECONDS = "1800";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };
in {
  imports = [
    inputs.auto-cpufreq.nixosModules.default
  ];

  services.power-profiles-daemon.enable = false;

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

  programs.auto-cpufreq.enable = true;
  # optionally, you can configure your auto-cpufreq settings, if you have any
  programs.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      energy_performance_preference = "performance";
      turbo = "auto";
    };

    battery = {
      governor = "powersave";
      energy_performance_preference = "power";
      turbo = "never";
    };
  };

  services.logind = {
    extraConfig = ''
      HandlePowerKey=hibernate
      HandleLidSwitch=suspend
    '';
  };

  # systemd.services."awake-after-suspend-for-a-time" = {
  #   description = "Sets up the suspend so that it'll wake for hibernation only if not on AC power";
  #   wantedBy = ["suspend.target"];
  #   before = ["systemd-suspend.service"];
  #   environment = hibernateEnvironment;
  #   script = ''
  #     if [ $(cat /sys/class/power_supply/ACAD/online) -eq 0 ]; then
  #       curtime=$(date +%s)
  #       echo "$curtime $1" >> /tmp/autohibernate.log
  #       echo "$curtime" > $HIBERNATE_LOCK
  #       ${pkgs.utillinux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
  #     else
  #       echo "System is on AC power, skipping wake-up scheduling for hibernation." >> /tmp/autohibernate.log
  #     fi
  #   '';
  #   serviceConfig.Type = "simple";
  # };

  # systemd.services."hibernate-after-recovery" = {
  #   description = "Hibernates after a suspend recovery due to timeout";
  #   wantedBy = ["suspend.target"];
  #   after = ["systemd-suspend.service"];
  #   environment = hibernateEnvironment;
  #   script = ''
  #     curtime=$(date +%s)
  #     sustime=$(cat $HIBERNATE_LOCK)
  #     rm $HIBERNATE_LOCK
  #     if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
  #       systemctl hibernate
  #     else
  #       ${pkgs.utillinux}/bin/rtcwake -m no -s 1
  #     fi
  #   '';
  #   serviceConfig.Type = "simple";
  # };
}
