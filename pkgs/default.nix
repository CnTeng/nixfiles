final: prev:
prev.lib.packagesFromDirectoryRecursive {
  callPackage = prev.lib.callPackageWith (prev.pkgs // { inherit prev; });
  directory = ./.;
}
