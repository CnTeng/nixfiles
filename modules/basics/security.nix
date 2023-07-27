{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.basics'.security;
in {
  imports = [inputs.agenix.nixosModules.default];

  options = {
    basics'.security.enable =
      mkEnableOption "security config" // {default = true;};

    age.file = mkOption {
      type = types.path;
      description = ''
        Age file the secret is loaded from.
      '';
    };
  };

  config = mkIf cfg.enable {
    security = {
      sudo.wheelNeedsPassword = false;
      rtkit.enable = true;
      tpm2.enable = true;
    };

    environment.systemPackages = with pkgs; [rage age-plugin-yubikey];

    age = {
      file = ../../secrets;

      identityPaths =
        ["/etc/ssh/ssh_host_ed25519_key"]
        ++ optionals config.hardware'.stateless.enable ["/persist/etc/ssh/ssh_host_ed25519_key"];
    };
  };
}
