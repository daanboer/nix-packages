{
  system ? builtins.currentSystem,
  overlays ? [ ],
  config ? { },
  ...
}@args:

let
  flake = builtins.getFlake (toString ./.);

  stable = flake.inputs.stable;
  unstable = flake.inputs.unstable;

  unstableOverlay = final: prev: {
    unstable = import unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  customOverlay = import ./packages;

  # Gate custom overlay to x86_64-linux only
  customIfX86_64 = final: prev: if system == "x86_64-linux" then (customOverlay final prev) else { };
in
import stable (
  args
  // {
    overlays = [
      unstableOverlay
      customIfX86_64
    ]
    ++ overlays;
    config = (config) // {
      allowUnfree = true;
    };
  }
)
