{
  source,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit (source) src;
}
