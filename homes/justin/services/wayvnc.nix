{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  desktop = osConfig.modules.usrEnv.desktop;
  waylandTarget = config.wayland.systemd.target;

  writeRuntimeConfig = pkgs.writeShellApplication {
    name = "wayvnc-write-runtime-config";
    runtimeInputs = with pkgs; [coreutils];
    text = ''
      runtime_dir="$XDG_RUNTIME_DIR/wayvnc"
      config_file="$runtime_dir/config"
      password="$(<${osConfig.age.secrets.wayvnc-password.path})"

      if [[ -z "$password" ]]; then
        echo "WayVNC password secret is empty" >&2
        exit 1
      fi

      install -d -m 700 "$runtime_dir"
      umask 077
      {
        printf '%s\n' 'address=0.0.0.0'
        printf '%s\n' 'enable_auth=true'
        printf '%s\n' 'relax_encryption=true'
        printf '%s\n' 'allow_broken_crypto=true'
        printf 'password=%s\n' "$password"
      } > "$config_file"
    '';
  };
in {
  config = lib.mkIf (desktop.enable && desktop.wms.niri.enable) {
    # Do not permit a manually launched WayVNC instance without authentication.
    # The systemd service below creates the complete, password-bearing runtime
    # configuration in $XDG_RUNTIME_DIR.
    xdg.configFile."wayvnc/config".text = ''
      address=0.0.0.0
      enable_auth=true
    '';

    systemd.user.services.wayvnc = {
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "WayVNC remote desktop server";
        After = [waylandTarget];
        PartOf = [waylandTarget];
        X-Restart-Triggers = [config.xdg.configFile."wayvnc/config".source];
      };

      Service = {
        ExecStartPre = lib.getExe writeRuntimeConfig;
        ExecStart = "${lib.getExe pkgs.wayvnc} --config %t/wayvnc/config";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };
}
