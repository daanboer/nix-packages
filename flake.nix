{
  description = "Custom Nixpkgs flake (stable with unstable and custom overlays).";

  inputs = {
    stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # A small helper to get a standard list of systems
    systems.url = "github:nix-systems/default";

    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs.nixpkgs.follows = "stable";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      self,
      stable,
      unstable,
      systems,
      bun2nix,
    }:
    let
      allSystems = import systems;

      unstableOverlay = final: prev: {
        unstable = import unstable {
          system = prev.system or final.system;
          config.allowUnfree = true;
        };
      };

      customOverlay = import ./packages;

      mkPkgs =
        system:
        import stable {
          inherit system;
          overlays = [
            unstableOverlay
            bun2nix.overlays.default
            customOverlay
          ];
          config.allowUnfree = true;
        };

      isDerivationSafe =
        d:
        let
          eval = builtins.tryEval (d.type or null);
        in
        eval.success;

      nixosSystem =
        args@{
          system ? builtins.currentSystem,
          pkgs ? null,
          ...
        }:
        stable.lib.nixosSystem (if pkgs == null then args // { pkgs = mkPkgs system; } else args);

      lib = stable.lib // {
        inherit nixosSystem;
      };
    in
    {
      # Expose the same lib as nixpkgs
      inherit lib;

      # Named overlays users can import/compose
      overlays = {
        unstable = unstableOverlay;
        custom = customOverlay;
      };

      # `legacyPackages` like nixpkgs (per-system package sets)
      legacyPackages = lib.genAttrs allSystems mkPkgs;

      # Many flakes expect `packages.${system}` to mirror legacyPackages.
      # Provide a filtered version of `legacyPackages` such that `packages` can
      # be used in `nix search`.
      packages = lib.mapAttrs (
        _system: pkgs: lib.filterAttrs (_name: pkg: isDerivationSafe pkg) pkgs
      ) self.legacyPackages;
    };
}
