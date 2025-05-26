let
  justinf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgdHCdGZodbvK9TY80cidEaV5dQAsKTrovljnH1RE8y";
  justini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqwBsJTddM3gFPxkuuavq96qUqMewIrwrHtZqyJ3aw3";
  users = [justinf justini];

  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPxpWExHrdaG5QSBFPKqD0DBeyBqFJJ/lZDEwHSVKf60";
  iceberg = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKaNliWdKb+cCNLeAugK89ED1+O/lFicXvKsXt7xfh7a";
  systems = [framework iceberg];
in {
  "syncthing-cert.age".publicKeys = users ++ systems;
  "syncthing-key.age".publicKeys = users ++ systems;
  "authelia-jwt-secret.age".publicKeys = users ++ systems;
  "nix-access-tokens-github.age".publicKeys = users ++ systems;
  "authelia-session-secret.age".publicKeys = users ++ systems;
  "authelia-storage-encryption-key.age".publicKeys = users ++ systems;
  "tailscale-auth.age".publicKeys = users ++ systems;
  "crowdsec-enroll-key.age".publicKeys = users ++ systems;
  "crowdsec-firewall-bouncer-key.age".publicKeys = users ++ systems;
  "crowdsec-caddy-bouncer-key.age".publicKeys = users ++ systems;
  "porkbun-api-key.age".publicKeys = users ++ systems;
  "porkbun-secret-key.age".publicKeys = users ++ systems;
  "duckdns.age".publicKeys = users ++ systems;
  "framework-cachix-agent-token.age".publicKeys = users ++ systems;
  "iceberg-cachix-agent-token.age".publicKeys = users ++ systems;
  "gh-nix-ci-token.age".publicKeys = users ++ systems;
  "paperless-admin-password.age".publicKeys = users ++ systems;
  "nextcloud-admin-password.age".publicKeys = users ++ systems;
  "zfs-pushover-token.age".publicKeys = users ++ systems;
  "pushover-user-key.age".publicKeys = users ++ systems;
  #"secret2.age".publicKeys = users ++ systems;
}
