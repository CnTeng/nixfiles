{ lib, ... }:
{
  importModule =
    path:
    let
      getFileNames = exclude: lib.subtractLists exclude (lib.attrNames (builtins.readDir path));
    in
    map (n: path + "/${n}") (getFileNames [
      "default.nix"
      "secrets.yaml"
    ]);

  removeHashTag = hex: lib.removePrefix "#" hex;
}
