{ lib, ... }:
let
  listModules =
    dir:
    lib.pipe (builtins.readDir dir) [
      (lib.mapAttrsToList (
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
      ))
      lib.flatten
    ];
in
{
  default = {
    imports = (listModules ./modules) ++ (listModules ./profiles);
  };
}
