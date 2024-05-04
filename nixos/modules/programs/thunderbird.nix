{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.programs'.thunderbird;

  OAuth2Settings = id: {
    "mail.smtpserver.smtp_${id}.authMethod" = 10;
    "mail.server.server_${id}.authMethod" = 10;
  };
  realName = "Teng Yufei";
in
{
  options.programs'.thunderbird.enable = lib.mkEnableOption "thunderbird";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      accounts.email.accounts = {
        Outlook = {
          address = "istengyf@outlook.com";
          aliases = [ "teng.yufei@outlook.com" ];
          inherit realName;
          userName = "istengyf@outlook.com";
          imap = {
            host = "127.0.0.1";
            port = 1143;
            tls.enable = false;
          };
          smtp = {
            host = "127.0.0.1";
            port = 1025;
            tls.enable = false;
          };
          thunderbird = {
            enable = true;
            perIdentitySettings = id: {
              "mail.identity.id_${id}.smtpServer" = "smtp_${builtins.hashString "sha256" "Outlook"}";
            };
          };
        };

        GmailJP = {
          primary = true;
          flavor = "gmail.com";
          address = "istengyf@gmail.com";
          aliases = [ "me@snakepi.xyz" ];
          inherit realName;
          smtp.tls.useStartTls = true;
          thunderbird = {
            enable = true;
            settings = OAuth2Settings;
            perIdentitySettings = id: {
              "mail.identity.id_${id}.smtpServer" = "smtp_${builtins.hashString "sha256" "GmailJP"}";
            };
          };
        };

        GmailHK = {
          flavor = "gmail.com";
          address = "jstengyufei@gmail.com";
          inherit realName;
          smtp.tls.useStartTls = true;
          thunderbird = {
            enable = true;
            settings = OAuth2Settings;
          };
        };
      };

      programs.thunderbird = {
        enable = true;
        profiles.default = {
          isDefault = true;
          settings = { };
        };
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".thunderbird"
        ".cache/thunderbird"
      ];
    };
  };
}
