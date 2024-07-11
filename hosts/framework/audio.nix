{
  inputs,
  self,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    pavucontrol
    pamixer
  ];

  security.rtkit.enable = true;
  sound.enable = false;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
    alsa.support32Bit = true;
    wireplumber.extraConfig = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
      };
    };
  };
}
