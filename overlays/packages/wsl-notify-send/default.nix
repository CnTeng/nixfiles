{
  lib,
  stdenv,
  source,
  unzip,
  ...
}:
stdenv.mkDerivation {
  inherit (source) pname version src;

  sourceRoot = ".";

  nativeBuildInputs = [unzip];

  installPhase = ''
    mkdir -p $out/bin
    cp wsl-notify-send.exe $out/bin/notify-send
  '';

  meta = with lib; {
    description = "WSL replacement for notify-send";
    homepage = "https://github.com/stuartleeks/wsl-notify-send";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "notify-send";
  };
}
