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

    impermanence.url = "github:nix-community/impermanence";

    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";

    # nix user repositories
    nur.url = "github:nix-community/NUR";

    agenix.url = "github:ryantm/agenix";

    microvm.url = "github:astro/microvm.nix";

    # pin fixed freecad
    # nixpkgs-freecad.url = "github:squalus/nixpkgs/freecad";

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

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.50.1";
      # type = "git";
      # url = "https://github.com/hyprwm/hyprland";
      # submodules = true;
      # rev = "04ac46c54357278fc68f0a95d26347ea0db99496";
      # inputs.aquamarine.follows = "aquamarine";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    # aquamarine = {
    #   url = "github:Hyprwm/aquamarine";
    #   #   # inputs.nixpkgs.follows = "nixpkgs-2405";
    # };
    hyprland-plugins = {
      # url = "git+https://github.com/hyprwm/hyprland-plugins?rev=98cb18c6fcfe8196ef4150d09fbae305b7bb2954";
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
    };
    # hyprcursor = {
    #   url = "github:hyprwm/hyprcursor";
    #   inputs.hyprland.follows = "hyprland";
    # };
    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
    };

    hyprpicker.url = "github:hyprwm/hyprpicker";

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
    };

    hypridle.url = "github:hyprwm/hypridle";

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.50.0";
      inputs.hyprland.follows = "hyprland";
    };

    hyprfocus = {
      url = "github:pyt0xic/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };

    # aylur's gtk shell
    ags.url = "github:Aylur/ags/v1";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    zen-nebula.url = "github:justinoh4116/Zen-Nebula?ref=aaa";

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
  };
}
