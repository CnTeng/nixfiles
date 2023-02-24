# Copy from https://github.com/nix-community/nur-combined/blob/master/repos/oluceps/pkgs/naiveproxy/default.nix
{ lib, stdenv, fetchurl, autoPatchelfHook, ... }:

stdenv.mkDerivation rec {
  pname = "naiveproxy";
  version = "110.0.5481.100-1";

  src = fetchurl {
    url = "https://github.com/klzgrad/naiveproxy/releases/download/v${version}/naiveproxy-v${version}-linux-x64.tar.xz";
    sha256 = "sha256-EYJUPXweHDbZiaIW77FoRNRKyMlEUfVIn2FT59WH0R8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    install -m755 -D naive $out/bin/naive
  '';

  meta = with lib; {
    homepage = "https://github.com/klzgrad/naiveproxy";
    description = "Make a fortune quietly";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ CnTeng ];
  };
}
