{ fetchFromGitHub, stdenv, cmake, enableTests ? true }:

stdenv.mkDerivation rec {
  pname = "mfem";
  version = "4.6";

  src = fetchFromGitHub {
    owner = "mfem";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XR3cv7029u6ypm1VQ4FpAXzFeV4pwqADyoKwBULQI28=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = enableTests;

  cmakeFlags = [ "DBUILD_SHARED_LIBS=1" ];
}
