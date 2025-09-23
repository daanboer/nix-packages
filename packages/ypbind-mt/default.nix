{
  fetchFromGitHub,
  stdenv,
  libnsl,
  libtirpc,
  autoreconfHook,
  pkg-config,
  libxslt,
  docbook-xsl-ns,
  libxml2,
  docbook_xml_dtd_45,
}:

stdenv.mkDerivation rec {
  pname = "ypbind-mt";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P8LH1vBTrNdgUQhzeixxBZR4atXyRVF+DuUbR6UeBJY=";
  };

  buildInputs = [
    libnsl
    libtirpc
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

    # pwd
    # ls
    # ls $src
    # cp $src/build/sbin/ypbind $out/bin
    # cp ypbind $out/bin
  '';
}
