{
  keys,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault mkForce mkMerge;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.lists) elemAt;
  inherit (lib) mkPubkeyFor;
in {
  services = {
    openssh = {
      # enable openssh
      enable = true;
      openFirewall = true; # the ssh port(s) should be automatically passed to the firewall's allowedTCPports
      startWhenNeeded = true; # automatically start the ssh daemon when it's required
      settings = {
        # no root login
        PermitRootLogin = mkForce "no";

        # no password auth
        # force publickey authentication only
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        PubkeyAuthentication = "yes";
        ChallengeResponseAuthentication = "no";
        UsePAM = false;

        # remove sockets as they get stale
        # this will unbind gnupg sockets if they exists
        StreamLocalBindUnlink = "yes";

        KbdInteractiveAuthentication = mkDefault false;
        UseDns = false; # no
        X11Forwarding = false; # ew xorg

        # key exchange algorithms recommended by `nixpkgs#ssh-audit`
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
          "diffie-hellman-group-exchange-sha256"
          "sntrup761x25519-sha512@openssh.com"
        ];

        # message authentication code algorithms recommended by `nixpkgs#ssh-audit`
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];

        # kick out inactive sessions
        ClientAliveCountMax = 5;
        ClientAliveInterval = 60;

        # max auth attempts
        MaxAuthTries = 3;
      };

      hostKeys = mkDefault [
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    fail2ban.jails = {
      # sshd jail
      sshd = {
        settings = {
          enabled = true;
          filter = "sshd[mode=aggressive]";
          port = concatStringsSep "," (map toString config.services.openssh.ports);
        };
      };
    };
  };

  # Add my SSH keys to initrd for remote unlocking. Backdoor?!
  boot.initrd.network.ssh.authorizedKeys = keys.justins;
  programs.ssh = let
    # a list of hosts that are connected over Tailscale
    # it would be better to construct this list dynamically
    # but we hardcode it because we cannot check if a host is
    # authenticated - that needs manual intervention
    hosts = ["framework" "iceberg" "titanic"];

    # generate the ssh config for the hosts
    mkHostConfig = hostname: ''
      # Configuration for ${hostname}
      Host ${hostname}
       HostName ${hostname}
      Port ${toString (elemAt config.services.openssh.ports 0)}
       StrictHostKeyChecking=accept-new
    '';

    hostConfig = concatStringsSep "\n" (map mkHostConfig hosts);
  in {
    # startAgent = !config.modules.system.yubikeySupport.enable;
    startAgent = true;
    extraConfig = ''
      ${hostConfig}
    '';
  };
}
