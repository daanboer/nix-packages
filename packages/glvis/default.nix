{
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  unixtools,
  libGL,
  SDL2,
  glew,
  glm,
  freetype,
  fontconfig,
  xorg,
  mfem,
  enableTests ? true,
}:

stdenv.mkDerivation rec {
  pname = "glvis";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "glvis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PiKXwBCpHi7SWr34gESBD01PuZWGN8QhFaG2wt0GZbk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [
    unixtools.xxd
    libGL.dev
    SDL2.dev
    glew.dev
    glm.out
    freetype.dev
    fontconfig.dev
    xorg.libXi.dev
    mfem
  ];

  doCheck = enableTests;

  installPhase = ''
    sed -i 's/build\/GLVis/build\/glvis/g' cmake_install.cmake
    cmake --install . --component "Unspecified"
  '';

  cmakeFlags = [ "-DOpenGL_GL_PREFERENCE=GLVND" ];
}
