{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.accounts'.gmail;
in
{
  options.accounts'.gmail.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' = {
      accounts.email.accounts.gmail = {
        primary = true;
        flavor = "gmail.com";
        address = "rxsnakepi@gmail.com";
        realName = "Teng Yufei";
        passwordCommand = "cat ${config.sops.secrets."password/gmail".path}";
        folders = {
          sent = "[Gmail]/Sent Mail";
          drafts = "[Gmail]/Drafts";
          trash = "[Gmail]/Trash";
        };
      };

      accounts.email.accounts.gmail.aerc = {
        enable = true;
        extraAccounts = {
          check-mail-cmd = "mbsync gmail";
          check-mail-timeout = "30s";
          folders-sort = "Inbox,Sent,Drafts,Spam,Trash";
          folder-map = "${pkgs.writeText "folder-map" ''
            Sent = [Gmail]/Sent Mail
            * = [Gmail]/*
          ''}";
        };
      };

      accounts.email.accounts.gmail.mbsync = {
        enable = true;
        create = "maildir";
        remove = "maildir";
        expunge = "both";
      };

      accounts.email.accounts.gmail.imapnotify = {
        enable = true;
        extraConfig = {
          OnNewMail = "mbsync gmail";
          onDeletedMail = "mbsync gmail";
        };
      };
    };

    sops.secrets."password/gmail" = {
      owner = config.core'.userName;
      sopsFile = ./secrets.yaml;
    };
  };
}
