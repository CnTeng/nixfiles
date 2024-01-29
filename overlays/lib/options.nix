{ lib, ... }:
with lib;
{
  mkEnableOption' =
    {
      default ? false,
    }:
    mkOption {
      inherit default;
      type = types.bool;
      visible = false;
    };
}
