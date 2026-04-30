{
  self,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}: {
  config = {
    systemd.user.services.headroom-ai = {
      Unit = {
        Description = "headroom token compression";
        After = ["network-online.target"];
      };
      # environment = {
      # HEADROOM_SAVINGS_PATH = "/tmp/proxy_saving.json";
      # HF_HOME = "/tmp/cache"; # For downloading onnx models
      # };
      # serviceConfig = {
      #   ExecStart = lib.concatStringsSep " " [
      #     "${self.packages.${pkgs.stdenv.hostPlatform.system}.headroom-ai}/bin/headroom"
      #     "proxy"
      #   ];
      # };
      Service = {
        ExecStart = lib.concatStringsSep " " [
          "${self.packages.${pkgs.stdenv.hostPlatform.system}.headroom-ai}/bin/headroom"
          "proxy"
        ];
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
