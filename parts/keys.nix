# inspired by notashelf/nyx
let
  users = {
    justin = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILgx9v+lydEnbl6EznPlrZk/2Gr0a9n18GHU/7xdz3NLAAAABHNzaDo=";
    justin_backup = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJndMoIyT69gdEdAGeFDnR7zOIHwUA6lzMdT+JQsC6MeAAAABHNzaDo=";
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
    users.justin_backup
  ];

  justins = [
    users.justin
    users.justin_backup
  ];

in {
  inherit (users) justin;
  inherit (machines) framework iceberg titanic;
  inherit servers workstations all justins;
}
