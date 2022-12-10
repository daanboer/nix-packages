{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec { # or wrapType1
  name = "mendeley-reference-manager";
  version = "2.80.1";
  src = fetchurl {
    url =
      "https://static.mendeley.com/bin/desktop/${name}-${version}-x86_64.AppImage";
    sha256 = "sha256-uqmu7Yf4tXDlNGkeEZut4m339S6ZNKhAmej+epKLB/8=";
  };
  # extraPkgs = pkgs: with pkgs; [ ];
}
