{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}:
with lib; let
  cfg = config.basics'.security;
  inherit (config.users.users.${user}) home;
in {
  imports = [inputs.agenix.nixosModules.default];

  options.basics'.security = {
    enable = mkEnableOption "security config" // {default = true;};
  };

  config = mkIf cfg.enable {
    security = {
      tpm2.enable = true;
      rtkit.enable = true;
      sudo.wheelNeedsPassword = false;
    };

    environment.systemPackages = with pkgs; [rage age-plugin-yubikey];

    age.identityPaths = [
      "${home}/.ssh/id_ed25519"
      "/persist/etc/ssh/id_ed25519"
    ];
  };
}
