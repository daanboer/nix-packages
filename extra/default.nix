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
}
