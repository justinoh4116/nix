{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.system.services.copyparty;
in {
  imports = [
    inputs.copyparty.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    services.copyparty = {
      enable = true;
      package = inputs.copyparty.packages."${pkgs.system}".default;
      # the user to run the service as
      user = "copyparty";
      # the group to run the service as
      group = "copyparty";
      # directly maps to values in the [global] section of the copyparty config.
      # see `copyparty --help` for available options
      settings = {
        # i = "0.0.0.0";
        # use lists to set multiple values
        p = [3210];
        xff-src = "lan";
        # use booleans to set binary flags
        no-reload = true;
        # using 'false' will do nothing and omit the value when generating a config
        ignored-flag = false;
        theme = 2;
        shr = "/shares";
      };

      # create users
      accounts = {
        # specify the account name as the key
        j = {
          # provide the path to a file containing the password, keeping it out of /nix/store
          # must be readable by the copyparty service user
          passwordFile = config.age.secrets.copyparty-password.path;
        };
      };

      # create a group
      groups = {
        # users "ed" and "k" are part of the group g1
        g1 = ["j"];
      };

      # create a volume
      volumes = {
        # create a volume at "/" (the webroot), which will
        "/" = {
          path = "/persist/copyparty";
          # see `copyparty --help-accounts` for available options
          access = {
            # everyone gets read-access, but
            G = "*";
            A = ["j"];
          };
          # see `copyparty --help-flags` for available options
          flags = {
            # "fk" enables filekeys (necessary for upget permission) (4 chars long)
            fk = 16;
            # scan for new files every 60sec
            scan = 60;
            # volflag "e2d" enables the uploads database
            e2dsa = true;
            # "d2t" disables multimedia parsers (in case the uploads are malicious)
            # d2t = true;
            # skips hashing file contents if path matches *.iso
            nohash = "\.iso$";
            og = true;
          };
        };
      };
      # you may increase the open file limit for the process
      openFilesLimit = 8192;
    };

    networking.firewall.allowedTCPPorts = [3210];
  };
}
