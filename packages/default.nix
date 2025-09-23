final: prev: {
  mfem = prev.callPackage ./mfem { enableTests = false; };
  glvis = prev.callPackage ./glvis { enableTests = false; };
  arangodb_deb = prev.callPackage ./arangodb-deb { };
  g810-led = prev.callPackage ./g810-led { };
  latexindent = prev.callPackage ./latexindent { };
  pdfcrop = prev.callPackage ./pdfcrop { };
  widevine = prev.callPackage ./widevine { };
  yp-tools = prev.callPackage ./yp-tools { };
  ypbind-mt = prev.callPackage ./ypbind-mt { };
  ly = prev.callPackage ./ly { };
  mendeley-reference-manager = prev.callPackage ./mendeley-reference-manager { };

  davmail = prev.davmail.overrideAttrs (prev: rec {
    version = "6.0.1";
    src = prev.fetchurl {
      url = "mirror://sourceforge/${prev.pname}/${version}/${prev.pname}-${version}-3390.zip";
      sha256 = "sha256-QK0G4p5QQPou67whuvzGHOgH21PL0Rb9PY8x+toMP8Q=";
    };
  });

  waybar-experimental = prev.unstable.waybar.overrideAttrs (old: {
    mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ];
  });
}
