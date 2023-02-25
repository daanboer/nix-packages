prev: final: {
  arangodb_deb = final.callPackage ./arangodb-deb { };
  g810-led = final.callPackage ./g810-led { };
  latexindent = final.callPackage ./latexindent { };
  ltex-ls = final.callPackage ./ltex-ls { };
  pdfcrop = final.callPackage ./pdfcrop { };
  widevine = final.callPackage ./widevine { };
  tessen = final.callPackage ./tessen { };
  yp-tools = final.callPackage ./yp-tools { };
  ypbind-mt = final.callPackage ./ypbind-mt { };
  ly = final.callPackage ./ly { };
  mendeley-reference-manager =
    final.callPackage ./mendeley-reference-manager { };

  davmail = final.davmail.overrideAttrs (prev: rec {
    version = "6.0.1";
    src = final.fetchurl {
      url =
        "mirror://sourceforge/${prev.pname}/${version}/${prev.pname}-${version}-3390.zip";
      sha256 = "sha256-QK0G4p5QQPou67whuvzGHOgH21PL0Rb9PY8x+toMP8Q=";
    };
  });

  unstable.waybar = final.unstable.waybar.overrideAttrs
    (old: { mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ]; });
}
