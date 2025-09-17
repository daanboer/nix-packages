{
  description = "Custom Nixpkgs flake (stable with unstable and custom overlays).";

  inputs = {
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # A small helper to get a standard list of systems
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      stable,
      unstable,
      systems,
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
            customOverlay
          ];
          config.allowUnfree = true;
        };

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

      # Many flakes expect `packages.${system}` to mirror legacyPackages
      packages = self.legacyPackages;
    };
}
