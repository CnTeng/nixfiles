{ lib, ... }:
with lib;
{
  importModule =
    {
      dir,
      exclude ? [ ],
    }:
    map (n: dir + "/${n}") (
      subtractLists
        (
          [
            "default.nix"
            "secrets.yaml"
          ]
          ++ exclude
        )
        (attrNames (builtins.readDir dir))
    );
}
