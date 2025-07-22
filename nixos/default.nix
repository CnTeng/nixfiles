{ lib, ... }:
let
  listModules =
    dir:
    lib.flatten (
      lib.mapAttrsToList (
        name: type:
        let
          path = dir + "/${name}";
          isNixDir = builtins.pathExists (path + "/default.nix");
          isNixFile = type == "regular" && lib.hasSuffix ".nix" name;
        in
        if type == "directory" then
          if isNixDir then path else listModules path
        else
          lib.optional isNixFile path
      ) (builtins.readDir dir)
    );
in
{
  flake.nixosModules.default = {
    imports = (listModules ./modules) ++ (listModules ./profiles);
  };
}
