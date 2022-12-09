{ stdenv, lib, fetchurl, pkgs, gzip, autoPatchelfHook, ... }:

stdenv.mkDerivation rec {
  pname = "naiveproxy";
  version = "108.0.5359.94-1";

  src = fetchurl {
    url = "https://github.com/klzgrad/naiveproxy/releases/download/v${version}/naiveproxy-v${version}-linux-x64.tar.xz";
    sha256 = "sha256-LjEri00BKdySZzqb3pBR2kSHve0nd4NILmEBTfGnya8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    install -m755 -D naive $out/bin/naive
  '';

  meta = with lib; {
    homepage = "https://github.com/klzgrad/naiveproxy";
    description = "naiveproxy";
    platforms = platforms.linux;
  };
}
