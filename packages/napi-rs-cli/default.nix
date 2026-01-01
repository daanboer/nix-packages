{
  bun2nix,
  jq,
  fetchurl,
}:
bun2nix.mkDerivation rec {
  pname = "napi";
  version = "3.5.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@napi-rs/cli/-/cli-${version}.tgz";
    hash = "sha256-F35ueQQbInis6EgUv5GlvAtiun0FRQutKnO+0T9cCDg=";
  };

  nativeBuildInputs = [ jq ];

  postPatch = ''
    jq 'del(.devDependencies)' package.json > package.json.new
    mv package.json.new package.json

    cp ${./bun.lock} bun.lock
  '';

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./bun.nix;
  };

  module = "dist/cli.js";
}
