{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers = {
    wg-easy = {
      image = "ghcr.io/wg-easy/wg-easy:15";
      ports = [
        "51820:51820/udp"
        "51821:51821/tcp"
      ];
      volumes = [
        "/persist/wireguard/etc_wireguard:/etc/wireguard"
      ];
      capabilities = {
        NET_ADMIN = true;
        SYS_MODULE = true;
        NET_RAW = true;
      };
      environment = {
        # GENERATE_NEW_SAVE = "false";
        # LOAD_LATEST_SAVE = "true";
        #SAVE_NAME = "nutty-factory";
      };
      # networks = [
      #   "wg-easy"
      # ];
      extraOptions = [
        "--network=wg-easy:ip=10.42.42.42"
        "--network=wg-easy:ip6=fdcc:ad94:bacf:61a3::2a"
        "--sysctl=net.ipv4.ip_forward=1"
        "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
        "--sysctl=net.ipv6.conf.all.disable_ipv6=0"
        "--sysctl=net.ipv6.conf.all.forwarding=1"
        "--sysctl=net.ipv6.conf.default.forwarding=1"
      ];
    };
  };
  system.activationScripts.mkVPNNetwork = let
    docker = config.virtualisation.oci-containers.backend;
    dockerBin = "${pkgs.${docker}}/bin/${docker}";
  in ''
    ${dockerBin} network inspect wg-easy >/dev/null 2>&1 || ${dockerBin} network create wg-easy --ipv6 --subnet 10.42.42.0/24 --subnet fdcc:ad94:bacf:61a3::/64
  '';

  networking = {
    firewall = {
      allowedTCPPorts = [51821];
      allowedUDPPorts = [51820];
    };
  };
}
