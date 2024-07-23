{
  flake.nixosModules.default =
    { lib, ... }:
    {
      imports = lib.importModule ./.;
    };
}
