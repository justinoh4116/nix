set shell := ["bash", "-cu"]

alias b := build
alias h := buildhome

up:
  nix flake update

# update specific input
# ie: just upp i=home-manager
upp:
  nix flake lock --update-input $(i)

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
  git commit -m "`home-manager generations | sed -n '1p'`"
  @notify-send -e "Home rebuild OK!" --icon=software-update-available

test:
  echo "`nixos-rebuild list-generations | grep current`"
