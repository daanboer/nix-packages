{ fetchFromGitHub, stdenv, gnumake, scdoc }:

stdenv.mkDerivation rec {
  pname = "tessen";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "ayushnix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MkZM/Au0nC2DPkgGDH5XuSJcGfwOtcjFHvMQhKfqSgY=";
  };

  buildInputs = [ gnumake scdoc ];

  # buildPhase = ''
  #   make bin
  # '';

  installPhase = ''
    PREFIX=$out make install
  '';
}
