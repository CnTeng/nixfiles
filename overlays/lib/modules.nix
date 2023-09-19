{lib, ...}:
with lib; {
  importModule = {
    dir,
    exclude ? [],
  }:
    map (n: dir + "/${n}") (
      subtractLists
      (["default.nix"] ++ exclude)
      (attrNames (builtins.readDir dir))
    );
}
