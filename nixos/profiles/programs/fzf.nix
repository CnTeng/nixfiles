{ lib, pkgs, ... }:
let
  command = filetype: "${lib.getExe pkgs.fd} -t ${filetype} -H -E .git";
in
{
  hm'.programs.fzf = {
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
  };
}
