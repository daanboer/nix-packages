{ fetchurl, lib, perl, perlPackages, stdenv, shortenPerlShebang, unzip }:

perlPackages.buildPerlPackage rec {
  pname = "latexindent";
  version = "3.20.4";

  src = fetchurl {
    url =
      "https://github.com/cmhughes/latexindent.pl/releases/download/V${version}/latexindent.zip";
    sha256 = "sha256-qWv7gWp/swmHjwG4svnqAFk/l6zAu0W9mus+fO4y+So=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ unzip ]
    ++ lib.optional stdenv.isDarwin shortenPerlShebang;
  propagatedBuildInputs = with perlPackages; [
    FileHomeDir
    LogDispatch
    LogLog4perl
    UnicodeLineBreak
    YAMLTiny
  ];

  # TODO: Fix: FATAL Could not open defaultSettings.yaml
  postPatch = ''
    substituteInPlace latexindent/LatexIndent/GetYamlSettings.pm \
    --replace '$FindBin::RealBin/defaultSettings.yaml' \
              $out/defaultSettings.yaml
  '';

  unpackPhase = ''
    unzip ${src}
  '';

  # Dirty hack to apply perlFlags, but do no build
  preConfigure = ''
    touch Makefile.PL
  '';
  dontBuild = true;

  installPhase = ''
    install -D ./latexindent/latexindent.pl $out/bin/latexindent
    mv ./latexindent/defaultSettings.yaml $out
    mkdir -p $out/${perl.libPrefix}
    cp -r ./latexindent/LatexIndent $out/${perl.libPrefix}/
  '' + lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang "$out"/bin/latexindent
  '';
}
