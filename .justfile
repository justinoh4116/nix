set positional-arguments

set shell := ["bash", "-cu"]

alias b := build
alias h := buildhome
alias i := iceberg
alias ir := iceberg-remote

up:
  nix flake update

# update specific input
# ie: just upp home-manager
upp:
  nix flake lock --update-input $1

build:
  nix fmt ./
  @echo "Rebuilding system..."
  sudo nixos-rebuild switch --flake ./
  #current := $(nixos-rebuild list-generations | grep current)
  git commit -am "`nixos-rebuild list-generations | grep current`"
  @notify-send -e "NixOS rebuild OK!" --icon=software-update-available

buildhome:
  nix fmt ./homes
  @echo "Rebuilding home..."
  home-manager switch --flake ".#justin"
  git add -u ./homes/*
  git add -u flake.nix flake.lock
  git commit -m "`home-manager generations | sed -n '1p'`"
  @notify-send -e "Home rebuild OK!" --icon=software-update-available

iceberg:
  nix fmt ./
  @echo "Rebuilding iceberg..."
  nixos-rebuild --flake .#iceberg --target-host root@192.168.100.3  switch
  #current := $(nixos-rebuild list-generations | grep current)
  git commit -am "`nixos-rebuild list-generations | grep current`"
  @notify-send -e "iceberg build OK!" --icon=software-update-available

iceberg-remote:
  nix fmt ./
  @echo "Rebuilding iceberg..."
  nixos-rebuild --flake .#iceberg --target-host root@192.168.100.3 --build-host root@192.168.0.13  switch
  #current := $(nixos-rebuild list-generations | grep current)
  git commit -am "`nixos-rebuild list-generations | grep current`"
  @notify-send -e "iceberg build OK!" --icon=software-update-available

test:
  echo "`nixos-rebuild list-generations | grep current`"
