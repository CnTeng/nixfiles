{
  lib,
  stdenvNoCC,
  gtk-engine-murrine,
  source,
}:
stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a themes/* $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "A GTK theme with the Kanagawa colour palette.";
    homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [garaiza-93];
  };
}
