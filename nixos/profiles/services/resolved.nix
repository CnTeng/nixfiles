{ lib, ... }:
{
  services.resolved.enable = lib.mkDefault true;
}
