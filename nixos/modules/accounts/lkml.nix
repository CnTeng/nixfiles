{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.accounts'.lkml;
in
{
  options.accounts'.lkml.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' =
      { config, ... }:
      {
        accounts.email.accounts.lkml = {
          address = "rxsnakepi@gmail.com";
          realName = "Teng Yufei";
        };

        accounts.email.accounts.lkml.aerc = {
          enable = true;
          extraAccounts = {
            check-mail-cmd = "lei up --all";
            check-mail-timeout = "5m";
            source = "maildir://${config.accounts.email.maildirBasePath}/lkml";
          };
        };

        home.packages = [ pkgs.public-inbox ];
      };

    preservation'.user.directories = [
      ".cache/lei"
      ".local/share/lei"
    ];
  };
}
