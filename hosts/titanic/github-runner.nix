{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.gh-nix-ci-token.file = ../../secrets/gh-nix-ci-token.age;

  containers.nix-gh-runner = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "192.168.100.9";
    #hostBridge = "br0";
    localAddress = "192.168.100.10";
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
        nix.settings.experimental-features = ["nix-command" "flakes"];

        networking.useHostResolvConf = lib.mkForce false;
        networking.enableIPv6 = false;
        services.resolved.enable = true;
        system.stateVersion = "24.11";

        services.github-runners.nix-ci = {
          enable = true;
          url = "https://github.com/justinoh4116/nix";
          tokenFile = "/run/agenix/gh-nix-ci-token";
          ephemeral = true;
          replace = true;
          extraPackages = with pkgs;
            [
              # custom
              cachix
              tmate
              jq
              git
              # nixos
              openssh
              coreutils-full
              bashInteractive # bash with ncurses support
              bzip2
              cpio
              curl
              diffutils
              findutils
              gawk
              stdenv.cc.libc
              getent
              getconf
              gnugrep
              gnupatch
              gnused
              gnutar
              gzip
              xz
              locale
              less
              ncurses
              netcat
              procps
              time
              zstd
              util-linux
              which
              nix
              nixos-rebuild
            ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              pkgs.strace
              pkgs.mkpasswd
              # nixos
              pkgs.acl
              pkgs.attr
              pkgs.libcap
            ]
            ++ lib.optionals pkgs.stdenv.isDarwin [];
          #++ cfg.extraPackages;
          serviceOverrides = lib.mkMerge [
            (lib.optionalAttrs pkgs.stdenv.isLinux {
              # needed for Cachix installation to work
              ReadWritePaths = ["/nix/var/nix/profiles/"];

              # Allow writing to $HOME
              ProtectHome = "tmpfs";

              # Always restart, which is possible with a PAT.
              Restart = lib.mkForce "always";
              RestartSec = "30s";
            })
            #cfg.serviceOverrides
          ];
        };

        # networking = {
        #   defaultGateway = "192.168.100.1";
        #   nameservers = [
        #     "192.168.100.1"
        #     "8.8.8.8"
        #     ];
        # };
        networking.firewall.enable = false;
        # networking.firewall.allowedTCPPorts = [
        #   80
        #   443
        # ];

        nix.settings = {
          substituters = [
            "https://hyprland.cachix.org"
            "https://anyrun.cachix.org"
            "https://walker.cachix.org"
            "https://lanzaboote.cachix.org"
          ];
          trusted-public-keys = [
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
            "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
            "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
          ];
        };
        nixpkgs.config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
  };
}
