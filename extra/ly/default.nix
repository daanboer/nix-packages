{ fetchurl, stdenv, unzip, autoPatchelfHook, xorg, linux-pam }:

stdenv.mkDerivation rec {
  pname = "ly";
  version = "0.5.0";

  src = fetchurl {
    url =
      "https://github.com/fairyglade/ly/releases/download/v${version}/ly_${version}.zip";
    sha256 = "sha256-94mykjoByoEUZlGAkgwLzwA+0fp2jF1ICsAcDqL9lMc=";
  };

  nativeBuildInputs = [ unzip autoPatchelfHook ];
  buildInputs = [ xorg.libxcb linux-pam ];

  unpackPhase = ''
    unzip $src
    cd ly_${version}
  '';

  installPhase = ''
    mkdir -p $out/bin
    # install -Dm644 bin/ly $out/bin/ly
    cp bin/ly $out/bin
  '';
}
