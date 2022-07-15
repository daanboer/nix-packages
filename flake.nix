{
  description = "Custom Nix packages flake.";

  inputs = {
    stable.url = "nixpkgs/nixos-22.05";
    unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, stable, unstable }:
    let
      system = "x86_64-linux";

      unstableOverlay = prev: final: {
        unstable = import unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      };

      packages = import stable {
        inherit system;
        overlays = [ (import ./packages) unstableOverlay ];
        config.allowUnfree = true;
      };
    in {
      legacyPackages.${system} = packages;
      lib = stable.lib;
    };
}
