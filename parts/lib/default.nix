# code taken from https://github.com/notashelf/nyx
{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;

  # This defines the custom library and its functions. What happens below is that we extend `nixpkgs.lib` with
  # my own set of functions, designed to be used within this repository.
  # You will come to realize that this is an ugly solution. The lib directory and the contents of this file
  # are frustratingly convoluted, and lib.extend cannot handle merging parent attributes (e.g self.modules
  # and super.modules will override each other, and not merge) so we cannot use the same names as nixpkgs.
  # This is a problem, as I want to use the same names as nixpkgs, but with my own functions. However there
  # is no clear solution to this problem, so we make all custom functions available under
  #  1. self.extendedLib, which is a set containing all custom parent attributes
  #  2. self.lib, which is the extended library.
  # There are technically no limitations to this approach, but if you want to avoid using shorthand aliases
  # to provided function, you would need to do something like `lib.extendedLib.aliases.foo` instead of
  # `lib.aliases.foo`, which is kinda annoying.
  nyxLib = self: let
    inherit (self.trivial) functionArgs;
    inherit (self.attrsets) filterAttrs mapAttrs recursiveUpdate;

    # the below function is by far the most cursed I've put in my configuration
    # if you are, for whatever reason, copying my configuration - PLEASE omit this
    # and do your imports manually
    # credits go to @nrabulinski
    callLibs = path: let
      func = import path;
      args = functionArgs func;
      requiredArgs = filterAttrs (_: val: !val) args;
      defaultArgs = recursiveUpdate (mapAttrs (_: _: null) requiredArgs) {
        inherit inputs;
        lib = self;
      };
      functor = {__functor = _: attrs: func (recursiveUpdate defaultArgs attrs);};
    in
      (func defaultArgs) // functor;
  in {
    extendedLib = {
      # Module builders and utilities for the custom module structure found in this
      # repository.
      modules = callLibs ./modules.nix;

      builders = callLibs ./builders.nix;
    };

    # Get individual functions from the parent attributes
    # inherit (self.extendedLib.aliases) sslTemplate common;
    inherit (self.extendedLib.builders) mkSystem mkNixosSystem mkNixosIso mkSDImage mkRaspi4Image;
    # inherit (self.extendedLib.ci) mkGithubMatrix;
    # inherit (self.extendedLib.dag) entryBefore entryBetween entryAfter entryAnywhere topoSort dagOf;
    # inherit (self.extendedLib.deploy) mkNode;
    # inherit (self.extendedLib.firewall) mkTable mkRuleset mkIngressChain mkPrerouteChain mkInputChain mkForwardChain mkOutputChain mkPostrouteChain;
    # inherit (self.extendedLib.fs) mkBtrfs;
    # inherit (self.extendedLib.hardware) isx86Linux primaryMonitor;
    # inherit (self.extendedLib.misc) filterNixFiles importNixFiles boolToNum fetchKeys containsStrings indexOf intListToStringList;
    inherit (self.extendedLib.modules) mkService mkModuleTree mkModuleTree';
    # inherit (self.extendedLib.namespacing) makeSocketNsPhysical makeServiceNsPhysical unRestrictNamespaces;
    # inherit (self.extendedLib.networking) isValidIPv4;
    # inherit (self.extendedLib.ssh) mkPubkeyFor;
    # inherit (self.extendedLib.secrets) mkAgenixSecret;
    # inherit (self.extendedLib.systemd) hardenService mkGraphicalService mkHyprlandService;
    # inherit (self.extendedLib.themes) serializeTheme compileSCSS;
    # inherit (self.extendedLib.validators) ifTheyExist ifGroupsExist isAcceptedDevice isWayland ifOneEnabled;
  };

  # Merge layers of libraries into one as a subject of convenience
  # and easy access.
  extensions = lib.composeManyExtensions [
    (_: _: inputs.nixpkgs.lib)
    (_: _: inputs.flake-parts.lib)
    # (_: _: inputs.nvf.lib) # neovim configuration wrapper for flakes
  ];

  # Extend default library
  extendedLibrary = (lib.makeExtensible nyxLib).extend extensions;
in {
  perSystem = {
    # Set the `lib` arg of the flake as the extended lib. If I am right, this should
    # override the previous argument (i.e. the original nixpkgs.lib, provided by flake-parts
    # as a reasonable default) with my own, which is the same nixpkgs library, but actually extended
    # with my own custom functions.
    _module.args.lib = extendedLibrary;
  };

  flake = {
    # Also set `lib` as a flake output, which allows for it to be referenced outside
    # the scope of this flake. This is useful for when I want to refer to my extended
    # library from outside this flake, or if someone wants to access my functions
    # but that rarely happens, Ctrl+C and Ctrl+V is the developer way it seems.
    lib = extendedLibrary;
  };
}
