{
  fetchurl,
  lib,
  ghostscript,
  perlPackages,
  stdenv,
  shortenPerlShebang,
  texlive,
}:

perlPackages.buildPerlPackage rec {
  pname = "pdfcrop";
  version = "1.40";

  src = fetchurl {
    url = "https://github.com/ho-tex/pdfcrop/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-WS6OC6jkYuc2T9Q7TTMRa5JXNlhibrk5G3PEYST2QCk=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
  propagatedBuildInputs = [
    ghostscript
    texlive.combined.scheme-basic
  ];

  preConfigure = ''
    touch Makefile.PL
  '';
  dontBuild = true;

  installPhase = ''
    install -D ./pdfcrop.pl $out/bin/pdfcrop
  ''
  + lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang "$out"/bin/pdfcrop
  '';
}
