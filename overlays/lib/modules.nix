{ lib, ... }:
{
  importModule =
    {
      dir,
      exclude ? [ ],
    }:
    map (n: dir + "/${n}") (
      lib.subtractLists (
        [
          "default.nix"
          "secrets.yaml"
        ]
        ++ exclude
      ) (lib.attrNames (builtins.readDir dir))
    );
}
