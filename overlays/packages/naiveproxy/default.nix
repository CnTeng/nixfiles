# Copy from https://github.com/nix-community/nur-combined/blob/master/repos/oluceps/pkgs/naiveproxy/default.nix
{
  lib,
  stdenv,
  autoPatchelfHook,
  sources,
  glib,
  ...
}:
stdenv.mkDerivation {
  inherit (sources.naiveproxy) pname version src;

  nativeBuildInputs = [autoPatchelfHook glib];

  installPhase = ''
    install -m755 -D naive $out/bin/naive
  '';

  meta = with lib; {
    description = "Make a fortune quietly";
    homepage = "https://github.com/klzgrad/naiveproxy";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
