{ source, stdenvNoCC, lib }:
stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes/
    cp -r src/* $out/share/fcitx5/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for Fcitx5";
    homepage = "https://github.com/catppuccin/fcitx5";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
