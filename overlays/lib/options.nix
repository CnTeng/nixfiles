{ lib, ... }:
{
  mkEnableOption' =
    {
      default ? false,
    }:
    lib.mkOption {
      inherit default;
      type = lib.types.bool;
      visible = false;
    };
}
