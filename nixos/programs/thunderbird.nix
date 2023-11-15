{
  config,
  lib,
  user,
  pkgs,
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
    systemd.user.services.protonmail-bridge = {
      description = "Protonmail Bridge";
      after = ["network.target"];
      wantedBy = ["default.target"];
      serviceConfig = {
        Environment = "PATH=${pkgs.gnome.gnome-keyring}/bin";
        Restart = "always";
        ExecStart = (getExe' pkgs.protonmail-bridge "protonmail-bridge") + " --noninteractive";
      };
    };

    home-manager.users.${user} = {
      home.packages = with pkgs; [protonmail-bridge];

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
          flavor = "outlook.office365.com";
          address = "istengyf@outlook.com";
          aliases = ["teng.yufei@outlook.com"];
          inherit realName;
          thunderbird = {
            enable = true;
            settings = OAuth2Settings;
          };
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
          realName = realName;
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
