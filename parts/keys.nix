# inspired by notashelf/nyx
let
  users = {
    justin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgdHCdGZodbvK9TY80cidEaV5dQAsKTrovljnH1RE8y";
  };

  machines = {
    framework = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPxpWExHrdaG5QSBFPKqD0DBeyBqFJJ/lZDEwHSVKf60"];
    iceberg = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKaNliWdKb+cCNLeAugK89ED1+O/lFicXvKsXt7xfh7a"];
    titanic = ["AAAAC3NzaC1lZDI1NTE5AAAAIJ8fK3X5ba9r0WtkdVaoMKXxZuQCd3oJk0lj2dOWW5oY"];
  };

  servers = [
    machines.iceberg
    machines.titanic
  ];

  workstations = [
    machines.framework
  ];

  all = [
    machines.framework
    machines.iceberg
    machines.titanic

    users.justin
  ];
in {
  inherit (users) justin;
  inherit (machines) framework iceberg titanic;
  inherit servers workstations all;
}
