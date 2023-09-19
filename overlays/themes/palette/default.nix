{
  source,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit (source) src;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontInstall = true;
}
