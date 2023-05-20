{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.wofi;
in {
  options.desktop'.components.wofi.enable = mkEnableOption "wofi";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.wofi = {
        enable = true;
        settings = {
          mode = "drun";
          # width = 500;
          # height = 450;
          allow_images = true;
          insensitive = true;
          hide_scroll = true;
          location = "top";
        };
        style = ''
          * {
            font-family: Inter Medium;
          }

          window {
            margin: 1px;
            border: 15px solid #7aa2f7;
            border-radius: 15px 15px 15px 15px;
          }

          #input {
            margin: 5px;
            border-radius: 0px;
            border: none;
            border-bottom: 0px solid black;
            background-color: #24283b;
            color: white;
          }

          #inner-box {
            margin: 5px;
            background-color: #24283b;
          }

          #outer-box {
            margin: 5px;
            padding: 20px;
            background-color: #24283b;
            border-radius: 15px 15px 15px 15px;
          }

          #text {
            margin: 5px;
            color: white;
          }

          #entry:selected {
            background-color: #151718;
          }

          #text:selected {
            text-decoration-color: white;
          }
        '';
      };
    };
  };
}
