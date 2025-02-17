{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.gh-nix-ci-token.file = ../../secrets/gh-nix-ci-token.age;

  containers.nix-gh-runner = {
    autoStart = true;
    privateNetwork = true;
    #hostAddress = "192.168.100.9";
    hostBridge = "br0";
    localAddress = "192.168.100.10/24";
    bindMounts = {
      "${config.age.secrets.gh-nix-ci-token.path}".isReadOnly = true;
    };
    config = let
      hostConfig = config;
    in
      {
        config,
        pkgs,
        ...
      }: {
        #networking.useHostResolvConf = lib.mkForce false;
        #services.resolved.enable = true;
        system.stateVersion = "24.11";

        services.github-runners.nix-ci = {
          enable = true;
          url = "https://github.com/justinoh4116/nix";
          tokenFile = "/run/agenix/gh-nix-ci-token";
          ephemeral = true;
        };

	networking = {
	  defaultGateway = "192.168.100.1";
	  nameservers = [
	    "192.168.100.1"
	    "8.8.8.8"
	    ];
	};
        networking.firewall.enable = false;
        # networking.firewall.allowedTCPPorts = [
        #   80
        #   443
        # ];
      };
  };
}
