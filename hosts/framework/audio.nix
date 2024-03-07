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
  };
}
