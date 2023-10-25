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
    install -D *.ttf $out/share/fonts/truetype/
    install -D *.ttc $out/share/fonts/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Microsoft Windows 10 TrueType fonts for Linux";
    homepage = "https://github.com/streetsamurai00mi/ttf-ms-win10";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
