{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.utils'.fzf;

  inherit (config.core'.colors) palette;
  command = filetype: "${getExe pkgs.fd} -t ${filetype} -H -E .git";
in
{
  options.utils'.fzf.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.fzf = {
        enable = true;
        defaultCommand = command "f";
        defaultOptions = [
          "--height 40%"
          "--layout reverse"
          "--info inline"
        ];
        fileWidgetCommand = command "f";
        fileWidgetOptions = [
          "--preview 'bat --color=always {}'"
          "--preview-window '~3'"
        ];
        changeDirWidgetCommand = command "d";
        changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
        colors = with palette; {
          "bg+" = surface0.hex;
          bg = base.hex;
          spinner = rosewater.hex;
          hl = red.hex;
          fg = text.hex;
          header = red.hex;
          info = mauve.hex;
          pointer = rosewater.hex;
          marker = rosewater.hex;
          "fg+" = text.hex;
          prompt = mauve.hex;
          "hl+" = red.hex;
        };
      };
    };
  };
}
