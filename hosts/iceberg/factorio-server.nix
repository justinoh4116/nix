{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers = {
    factorio = {
      image = "factoriotools/factorio:2.0.44";
      ports = [
        "34197:34197/udp"
        "27015:27015/tcp"
      ];
      volumes = [
        "/persist/factorio/space:/factorio"
      ];
      environment = {
        GENERATE_NEW_SAVE = "false";
        LOAD_LATEST_SAVE = "true";
        #SAVE_NAME = "nutty-factory";
      };
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [27015];
      allowedUDPPorts = [34197];
    };
  };
}
