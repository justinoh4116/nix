{
  config,
  lib,
  pkgs,
  ...
}: let
  statePath = "/persist/etc/ssh";
in {
  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = statePath + "/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
      {
        path = statePath + "/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
  programs.ssh.knownHosts = {
    iceberg = {
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKaNliWdKb+cCNLeAugK89ED1+O/lFicXvKsXt7xfh7a";
    };
  };
}
