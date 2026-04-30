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
          "--port"
          "8787"
          "--no-telemetry"
        ];
        Environment = [
          "HEADROOM_TELEMETRY=off"
          "HEADROOM_HOST=127.0.0.1"
          "HEADROOM_PORT=8787"
          "HEADROOM_MODE=cost_savings"
          "ORT_LOG_LEVEL=3" # suppress onnxruntime provider bridge warnings (no CUDA on AMD GPU)
          # Chain: Claude → headroom (8787) → better-ccflare (8788) → api.anthropic.com.
          # headroom's click CLI reads this via os.environ.get("ANTHROPIC_TARGET_API_URL")
          # in headroom/cli/proxy.py and passes it into ProxyConfig.anthropic_api_url.
          "ANTHROPIC_TARGET_API_URL=http://127.0.0.1:8788"
        ];
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
