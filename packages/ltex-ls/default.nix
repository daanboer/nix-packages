{ fetchurl, stdenv, jdk, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "ltex-ls";
  version = "16.0.0";

  src = fetchurl {
    url =
      "https://github.com/valentjn/ltex-ls/releases/download/${version}/ltex-ls-${version}.tar.gz";
    sha256 = "sha256-ygjCFjYaP9Lc5BLuOHe5+lyaKpfDhicR783skkBgo7I=";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/raw
    mv bin/ltex-cli bin/ltex-ls $out/raw
    mv lib $out

    makeWrapper $out/raw/ltex-ls $out/bin/ltex-ls --set JAVA_HOME ${jdk}/lib/openjdk
    makeWrapper $out/raw/ltex-cli $out/bin/ltex-cli --set JAVA_HOME ${jdk}/lib/openjdk
  '';
}
