{ config, pkgs, lib, self, ... }:

let
  cfg = config.services.bcachefsRootBackup;
in {

  imports = [

  ];

  options = {
    services.bcachefsRootBackup = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Will periodically take snapshots of the / subvolume when enabled
        '';
      };
      frequent = mkOption {
        type = types.bool;
	default = false;
	description = ''
	  Will enable snapshots every 15 minutes
	'';
      };
      hourly = mkOption {
        type = types.bool;
	default = false;
	description = ''
	  Will enable hourly snapshots
	'';
      };
      daily = mkOption {
        type = types.bool;
	default = true;
	description = ''
	  Will enable daily snapshots
	'';
      };
      weekly = mkOption {
        type = types.bool;
	default = true;
	description = ''
	  Will enable weekly snapshots
	'';
      };
      monthly = mkOption {
        type = types.bool;
	default = true;
	description = ''
	  Will enable monthly snapshots
	'';
      };
    };

  };

  config = {

  };

}
