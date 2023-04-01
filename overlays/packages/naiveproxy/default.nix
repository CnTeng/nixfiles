# Copy from https://github.com/nix-community/nur-combined/blob/master/repos/oluceps/pkgs/naiveproxy/default.nix
{ lib, stdenv, autoPatchelfHook, sources, ... }:
stdenv.mkDerivation {
  inherit (sources.naiveproxy) pname version src;

  nativeBuildInputs = [ autoPatchelfHook ];

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
