{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  dpkg,
}:

stdenv.mkDerivation rec {
  pname = "arangodb";
  version = "3.7.12";

  src = fetchurl {
    url = "https://download.arangodb.com/arangodb37/Community/Linux/arangodb3_3.7.12-1_amd64.deb";
    sha256 = "12n1iskif3g8bv1drkifg0f9a9kkmpi4ql6wxcibpj9awnjkgncz";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  unpackCmd = ''
    mkdir tmp
    dpkg -x $curSrc tmp'';

  installPhase = ''
            # with nixpkgs, it does not make sense to check for a version update
            substituteInPlace usr/share/arangodb3/js/client/client.js --replace "require('@arangodb').checkAvailableVersions();" ""
            substituteInPlace usr/share/arangodb3/js/server/server.js --replace "require('@arangodb').checkAvailableVersions();" ""

            # Cleanup
    				rm -r var lib

    				# Create output directory
        		mkdir -p $out/usr

    				# Move files
        		mv usr/sbin/arangod usr/bin
        		mv usr/bin $out/usr
        		mv usr/share $out/usr
    				mv etc $out
  '';

  postFixup = ''
    cd $out/usr/bin
    for file in *
    do
    	makeWrapper $out/usr/bin/$file $out/bin/$file \
    	  --set ICU_DATA $out/usr/share/arangodb3
    done
    cd -
  '';
}
