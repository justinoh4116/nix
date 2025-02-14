let
  justinf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgdHCdGZodbvK9TY80cidEaV5dQAsKTrovljnH1RE8y";
  justini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqwBsJTddM3gFPxkuuavq96qUqMewIrwrHtZqyJ3aw3";
  users = [justinf justini];

  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKN8HCItH6bPag8hX1IqYlwQ3hIk4wcz3b+hWZUV5z5";
  iceberg = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKaNliWdKb+cCNLeAugK89ED1+O/lFicXvKsXt7xfh7a";
  systems = [framework iceberg];
in {
  "tailscale-auth.age".publicKeys = users ++ systems;
  "duckdns.age".publicKeys = users ++ systems;
  #"secret2.age".publicKeys = users ++ systems;
}
