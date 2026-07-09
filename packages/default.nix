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

  napi-rs-cli = prev.callPackage ./napi-rs-cli { };

  waybar-experimental = prev.unstable.waybar.overrideAttrs (old: {
    mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ];
  });
}
