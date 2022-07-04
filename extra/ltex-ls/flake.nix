{
  description = "A flake defining a package for the ltex language server.";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.ltex-ls = with pkgs;
        stdenv.mkDerivation rec {
          pname = "ltex-ls";
          version = "15.2.0";

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
        };

      packages.${system}.default = self.packages.${system}.ltex-ls;

    };
}
