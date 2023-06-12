{ stdenv, fetchurl, autoPatchelfHook, dpkg }:

stdenv.mkDerivation rec {
  pname = "widevine";
  version = "95.0.4638.69";

  src = fetchurl {
    url =
      "https://dl.google.com/linux/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${version}-1_amd64.deb";
    sha256 = "1jhxm12sdlgvgnny0p56xsfyxd78mwn9qwc20c33qfvwxrzp9ajp";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];
  buildInputs = [ stdenv.cc.cc.lib ];

  unpackCmd = ''
    mkdir tmp
    dpkg --fsys-tarfile $curSrc | tar --extract --directory tmp
  '';

  installPhase = ''
    # Create output directory
    mkdir -p $out/lib

    # Install files
    install -Dm644 opt/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so -t $out/lib
    install -Dm644 opt/google/chrome/WidevineCdm/LICENSE -t $out/lib

    # Cleanup
    # rm -r *
  '';
}
