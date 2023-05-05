{
  lib,
  stdenvNoCC,
  sources,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (sources.catppuccin-plymouth) pname version src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth
    cp -r themes $out/share/plymouth/

    for i in $out/share/plymouth/themes/*/*.plymouth; do
      substituteInPlace $i \
        --replace /usr/share $out/share
    done

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for Plymouth";
    homepage = "https://github.com/catppuccin/plymouth";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
