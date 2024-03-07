{
  inputs,
  self,
  pkgs,
  config,
  ...
}: let
  discord-wrapped =
    (pkgs.discord-canary.override {
      nss = pkgs.nss_latest;
      withOpenASAR = true;
      # withVencord = true;
    })
    .overrideAttrs (old: {
      libPath = old.libPath + ":${pkgs.libglvnd}/lib";
      nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.makeWrapper];

      postFixup = ''
        wrapProgram $out/opt/DiscordCanary/DiscordCanary \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
      '';
    });
in {
  nixpkgs.config.allowUnfreePredicate = _: true;
  home.packages = [
    discord-wrapped
  ];
}
