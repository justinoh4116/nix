{
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
      "https://walker.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
  nix.gc = {
    randomizedDelaySec = "15min";
    automatic = true;
    dates = "weekly";
  };
  # nixpkgs.overlays = [
  #   # inputs.neovim-nightly-overlay.overlay.default
  # ];
}
