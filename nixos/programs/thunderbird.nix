{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.thunderbird;

  inherit (config.users.users.${user}) home;
  OAuth2Settings = id: {
    "mail.smtpserver.smtp_${id}.authMethod" = 10;
    "mail.server.server_${id}.authMethod" = 10;
  };
  realName = "Teng Yufei";
in {
  options.programs'.thunderbird.enable = mkEnableOption "thunderbird";

  config = mkIf cfg.enable {
    services'.protonmail-bridge.enable = true;
    services'.davmail.enable = true;

    home-manager.users.${user} = {
      accounts.email.accounts = {
        Proton = {
          primary = true;
          address = "yufei.teng@pm.me";
          aliases = ["me@snakepi.xyz"];
          inherit realName;
          userName = "yufei.teng@pm.me";
          imap = {
            host = "127.0.0.1";
            port = 1143;
            tls = {
              enable = true;
              useStartTls = true;
              certificatesFile = home + "/.config/protonmail/bridge/cert.pem";
            };
          };
          smtp = {
            host = "127.0.0.1";
            port = 1025;
            tls = {
              enable = true;
              useStartTls = true;
              certificatesFile = home + "/.config/protonmail/bridge/cert.pem";
            };
          };
          thunderbird.enable = true;
        };

        Outlook = {
          address = "istengyf@outlook.com";
          inherit realName;
          userName = "istengyf@outlook.com";
          imap = {
            host = "127.0.0.1";
            port = 11143;
            tls.enable = false;
          };
          smtp = {
            host = "127.0.0.1";
            port = 11025;
            tls.enable = false;
          };
          thunderbird.enable = true;
        };

        GmailJP = {
          flavor = "gmail.com";
          address = "istengyf@gmail.com";
          inherit realName;
          smtp.tls.useStartTls = true;
          thunderbird = {
            enable = true;
            settings = OAuth2Settings;
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
          settings = {};
        };
      };
    };

    environment.persistence."/persist" = mkIf config.hardware'.persist.enable {
      users.${user}.directories = [".thunderbird"];
    };
  };
}
