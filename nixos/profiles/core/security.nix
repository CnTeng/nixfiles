{ config, ... }:
{
  sops.secrets.yubikey = {
    sopsFile = ./secrets.yaml;
    mode = "0444";
  };

  security.pam.u2f = {
    enable = true;
    settings = {
      authfile = config.sops.secrets.yubikey.path;
      appid = "pam://nixos";
      origin = "pam://nixos";
      cue = true;
    };
  };
}
