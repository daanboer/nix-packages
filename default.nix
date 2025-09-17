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
      system = prev.system or system;
      config.allowUnfree = true;
    };
  };

  customOverlay = import ./packages;

  # Gate custom overlay to x86_64-linux only
  customIfX86_64 =
    final: prev: if (prev.system or system) == "x86_64-linux" then (customOverlay final prev) else { };
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
