{ fetchFromGitHub, stdenv, hidapi }:

let
  rule = ''
    ACTION==\"add\", SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"046d\", ATTRS{idProduct}==\"c337\", MODE=\"666\" RUN+=\"$out/bin/g810-led -a 00CDFF\"'';
in stdenv.mkDerivation rec {
  pname = "g810-led";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "MatMoul";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ymkp7i7nc1ig2r19wz0pcxfnpawkjkgq7vrz6801xz428cqwmhl";
  };

  buildInputs = [ hidapi ];

  buildPhase = ''
    make bin
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/udev/rules.d/
    mv bin/g810-led $out/bin/

    echo ${rule} > $out/lib/udev/rules.d/g810-led.rules
            # cp udev/g810-led.rules $out/lib/udev/rules.d/
  '';
}
