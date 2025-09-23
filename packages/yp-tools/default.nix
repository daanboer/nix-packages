{
  fetchFromGitHub,
  stdenv,
  libnsl,
  libtirpc,
  libxcrypt,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "yp-tools";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e9Q9bNr5ZpLJQ6QqIBxVbv/ShXC4pOdwgrCA6/QAcL0=";
  };

  buildInputs = [
    libnsl
    libtirpc
    libxcrypt
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  autoreconfPhase = ''
    ./autogen.sh
    ./configure --prefix=$out --sbindir=$out/bin
  '';

  buildPhase = ''
    cd lib; make
    cd ../src; make
  '';

  installPhase = ''
    mkdir -p $out/bin
    make install
    # install -D -m644 ../etc/nicknames $out/var/yp/nicknames
    install -D -m644 ../etc/nicknames $out/etc/nicknames
  '';
}
