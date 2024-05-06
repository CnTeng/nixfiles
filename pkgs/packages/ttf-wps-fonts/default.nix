{
  lib,
  stdenv,
  source,
}:
stdenv.mkDerivation {
  inherit (source) pname version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    install -D *.{ttf,TTF} $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Symbol fonts required by wps-office";
    homepage = "https://github.com/dv-anomaly/ttf-wps-fonts";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
