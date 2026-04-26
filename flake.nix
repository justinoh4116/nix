{
  description = "i may have fallen too deep into the hole";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      # attributes of perSystem will be built for all systems in this list
      systems = import inputs.systems;

      imports = [
        ./parts
        ./hosts
      ];
    };

  inputs = {
    # stable?!? hardly even
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-2405.url = "github:NixOS/nixpkgs/nixos-24.05";

    flake-parts.url = "github:hercules-ci/flake-parts";

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions.url = "github:vicinaehq/extensions";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    impermanence.url = "github:nix-community/impermanence";

    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";

    # nix user repositories
    nur.url = "github:nix-community/NUR";

    agenix.url = "github:ryantm/agenix";

    microvm.url = "github:astro/microvm.nix";

    # pin fixed freecad
    # nixpkgs-freecad.url = "github:squalus/nixpkgs/freecad";

    # pin nixpkgs for m16 logisim version 4.1.0
    nixpkgs-logisim-m16.url = "github:nixos/nixpkgs/4c79e748f16806804beaab7ce2b263d9893c3ca6";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    schizofox.url = "github:schizofox/schizofox";

    niri-flake.url = "github:sodiboo/niri-flake";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stasis.url = "github:saltnpepper97/stasis";

    hyprland = {
      # url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.50.1";
      # type = "git";
      url = "github:hyprwm/Hyprland";
      # submodules = true;
      # rev = "04ac46c54357278fc68f0a95d26347ea0db99496";
      # inputs.aquamarine.follows = "aquamarine";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprtasking = {
      url = "github:raybbian/hyprtasking";
      inputs.hyprland.follows = "hyprland";
    };

    # aylur's gtk shell
    ags.url = "github:Aylur/ags/v1";

    # quickshell
    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    # zen-browser = {
    #   url = "github:youwen5/zen-browser-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # anyrun launcher
    anyrun = {
      url = "github:anyrun-org/anyrun";
    };

    tailray = {
      url = "github:NotAShelf/tailray";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyprland.url = "github:hyprland-community/pyprland";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    gestures.url = "github:riley-martin/gestures";

    # apple fonts
    apple-fonts.url = "github:LYndeno/apple-fonts.nix";

    # keyboard remapping tool
    kmonad.url = "github:kmonad/kmonad?dir=nix";

    # caddy with porkbun support

    crowdsec = {
      url = "git+https://codeberg.org/kampka/nix-flake-crowdsec.git";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nyx = {
      url = "github:NotAShelf/nyx";
    };

    zjstatus.url = "github:dj95/zjstatus";

    copyparty.url = "github:9001/copyparty";
  };
}
