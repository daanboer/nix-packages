final: prev: {
  mfem = final.callPackage ./mfem { enableTests = false; };
  glvis = final.callPackage ./glvis { enableTests = false; };
  arangodb_deb = final.callPackage ./arangodb-deb { };
  g810-led = final.callPackage ./g810-led { };
  latexindent = final.callPackage ./latexindent { };
  pdfcrop = final.callPackage ./pdfcrop { };
  widevine = final.callPackage ./widevine { };
  yp-tools = final.callPackage ./yp-tools { };
  ypbind-mt = final.callPackage ./ypbind-mt { };
  ly = final.callPackage ./ly { };
  mendeley-reference-manager = final.callPackage ./mendeley-reference-manager { };

  davmail = final.davmail.overrideAttrs (prev: rec {
    version = "6.0.1";
    src = final.fetchurl {
      url = "mirror://sourceforge/${prev.pname}/${version}/${prev.pname}-${version}-3390.zip";
      sha256 = "sha256-QK0G4p5QQPou67whuvzGHOgH21PL0Rb9PY8x+toMP8Q=";
    };
  });

  waybar-experimental = final.unstable.waybar.overrideAttrs (old: {
    mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ];
  });
}
