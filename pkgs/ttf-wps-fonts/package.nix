{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "ttf-wps-fonts";
  version = "0-unstable-2024-10-29";

  srcs = [
    (fetchFromGitHub {
      owner = "dv-anomaly";
      repo = "ttf-wps-fonts";
      rev = "8c980c24289cb08e03f72915970ce1bd6767e45a";
      sha256 = "sha256-x+grMnpEGLkrGVud0XXE8Wh6KT5DoqE6OHR+TS6TagI=";
      name = "wps";
    })
    (fetchFromGitHub {
      owner = "streetsamurai00mi";
      repo = "ttf-ms-win10";
      rev = "417eb232e8d037964971ae2690560a7b12e5f0d4";
      sha256 = "sha256-UwkHlrSRaXhfoMlimyXFETV9yq1SbvUXykrhigf+wP8=";
      name = "win";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    install -D win/*.ttf $out/share/fonts/truetype/
    install -D win/*.ttc $out/share/fonts/
    install -D wps/*.{ttf,TTF} $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = {
    description = "Symbol fonts required by wps-office";
    homepage = "https://github.com/dv-anomaly/ttf-wps-fonts";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ CnTeng ];
    platforms = lib.platforms.all;
  };
}
