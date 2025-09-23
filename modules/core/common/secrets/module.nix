{
  config,
  lib,
  ...
}: let
  inherit (lib) mkAgenixSecret;
  inherit (lib.strings) optionalString;

  sys = config.modules.system;
  cfg = sys.services;
in {
  age.identityPaths = [
    "${optionalString sys.impermanence.root.enable "/persist"}/etc/ssh/ssh_host_ed25519_key"
    "${optionalString sys.impermanence.home.enable "/persist"}/home/justin/.ssh/id_ed25519"
  ];

  age.secrets = {
    nix-access-tokens-github = mkAgenixSecret true {
      file = "nix-access-tokens-github.age";
    };

    tailscale-auth = mkAgenixSecret true {
      file = "tailscale-auth.age";
    };

    framework-cachix-agent-token = mkAgenixSecret true {
      file = "framework-cachix-agent-token.age";
    };

    zfs-pushover-token = mkAgenixSecret true {
      file = "zfs-pushover-token.age";
    };

    pushover-user-key = mkAgenixSecret true {
      file = "pushover-user-key.age";
    };
  };
}
