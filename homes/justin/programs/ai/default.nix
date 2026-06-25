{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./codex.nix
    ./t3code.nix
    ./headroom.nix
  ];
  config = {
    home.packages = with pkgs;
      [
        rtk
        pi-coding-agent
        worktrunk
      ]
      ++ [
        # inputs.seance.packages.${pkgs.stdenv.hostPlatform.system}.seance
      ];
  };
}
