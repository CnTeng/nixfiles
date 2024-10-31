{ config, ... }:
{
  sops.secrets.yubikey = {
    sopsFile = ./secrets.yaml;
    mode = "0444";
  };

  security.pam.rssh.enable = true;
  security.pam.u2f = {
    enable = true;
    settings = {
      authfile = config.sops.secrets.yubikey.path;
      appid = "pam://nixos";
      origin = "pam://nixos";
      cue = true;
    };
  };

  security.pam.services.sudo.rssh = true;
}
