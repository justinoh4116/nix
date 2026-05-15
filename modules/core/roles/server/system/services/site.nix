{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.site;
  sitePort = 3000;
  startSite = pkgs.writeShellApplication {
    name = "start-site";
    runtimeInputs = with pkgs; [
      bash
      bun
      jq
      rsync
    ];
    text = ''
      set -euo pipefail

      app_root="/var/lib/site/app"
      mkdir -p "$app_root"

      ${pkgs.rsync}/bin/rsync \
        -a \
        --delete \
        --exclude .git \
        --exclude node_modules \
        /srv/site-source/ \
        "$app_root/"

      cd "$app_root"

      if [[ ! -f package.json ]]; then
        echo "expected /persist/site to contain a Bun app with package.json" >&2
        exit 1
      fi

      if [[ -f bun.lock || -f bun.lockb ]]; then
        bun install --frozen-lockfile --no-progress
      else
        bun install --no-progress
      fi

      run_build="$(${pkgs.jq}/bin/jq -r 'has("scripts") and ((.scripts.build // "") != "")' package.json)"
      if [[ "$run_build" == "true" ]]; then
        bun run build
      fi

      script_name="$(${pkgs.jq}/bin/jq -r '
        if (.scripts.start // "") != "" then "start"
        elif (.scripts.serve // "") != "" then "serve"
        elif (.scripts.preview // "") != "" then "preview"
        elif (.scripts.dev // "") != "" then "dev"
        else empty
        end
      ' package.json)"

      case "$script_name" in
        start)
          exec bun run start
          ;;
        serve)
          exec bun run serve
          ;;
        preview)
          exec bun run preview -- --host "''${HOST:-0.0.0.0}" --port "''${PORT:-3000}"
          ;;
        dev)
          exec bun run dev -- --host "''${HOST:-0.0.0.0}" --port "''${PORT:-3000}"
          ;;
        *)
          echo "no supported Bun script found in package.json; expected start, serve, preview, or dev" >&2
          exit 1
          ;;
      esac
    '';
  };
in {
  config = lib.mkIf cfg.enable {
    containers.site = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.27";
      localAddress = "192.168.100.28";
      bindMounts = {
        "/srv/site-source" = {
          hostPath = "/persist/site";
          isReadOnly = true;
        };
      };
      config = {
        config,
        pkgs,
        lib,
        ...
      }: {
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;
        system.stateVersion = "26.05";

        users.users.site = {
          isSystemUser = true;
          group = "site";
          home = "/var/lib/site";
          createHome = false;
        };
        users.groups.site = {};

        systemd.services.site = {
          description = "justinoh.io Bun web app";
          after = ["network-online.target"];
          wants = ["network-online.target"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            Type = "simple";
            User = "site";
            Group = "site";
            WorkingDirectory = "/var/lib/site/app";
            Restart = "always";
            RestartSec = 5;
            StateDirectory = "site";
            CacheDirectory = "bun";
            Environment = [
              "HOME=/var/lib/site"
              "HOST=0.0.0.0"
              "NODE_ENV=production"
              "PORT=${toString sitePort}"
              "BUN_INSTALL_CACHE_DIR=/var/cache/bun/install/cache"
            ];
            ExecStart = "${startSite}/bin/start-site";
          };
        };

        networking.firewall.allowedTCPPorts = [sitePort];
      };
    };
  };
}
