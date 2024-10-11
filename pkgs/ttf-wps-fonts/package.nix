{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "ttf-wps-fonts";
  version = "0-unstable-2024-06-10";

  src = fetchFromGitHub {
    owner = "ferion11";
    repo = "ttf-wps-fonts";
    rev = "f4131f029934a76ea90336c8ee4929c5c78588f4";
    sha256 = "sha256-LB7/VHTB3tPOqXoq0kaCw7VmaE4ZRSbwDvzhxPMsz+k=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    install -D *.{ttf,TTF} $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = {
    description = "Symbol fonts required by wps-office";
    homepage = "https://github.com/ferion11/ttf-wps-fonts";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ CnTeng ];
    platforms = lib.platforms.all;
  };
}
