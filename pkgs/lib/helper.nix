{ lib, ... }:
{
  importModule =
    {
      dir,
      exclude ? [
        "default.nix"
        "secrets.yaml"
      ],
    }:
    map (n: dir + "/${n}") (lib.subtractLists exclude (lib.attrNames (builtins.readDir dir)));
}
