{config, ...}: {
  config = {
    programs.sioyek = {
      enable = true;
      config = {
        shared_database_path = "${config.home.homeDirectory}/safe/nextcloud/sync/sioyek";
      };
    };
  };
}
