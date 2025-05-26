{
  config,
  pkgs,
  inputs,
  ...
}: {
  age.secrets.syncthing-key.file = ../../../secrets/syncthing-key.age;
  age.secrets.syncthing-cert.file = ../../../secrets/syncthing-cert.age;

  services.syncthing = {
    enable = true;
    # user = "justin";
    # group = "justin";
    # dataDir = "/home/justin/syncthing_test";
    # configDir = "/home/justin/.config/syncthing";
    key = config.age.secrets.syncthing-key.path;
    cert = config.age.secrets.syncthing-cert.path;

    settings = {
      folders = {
        "/home/justin/safe/obsidian" = {
          id = "obsidian";
        };
      };
    };
  };
}
