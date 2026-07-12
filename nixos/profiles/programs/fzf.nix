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
    fileWidget = {
      command = command "f";
      options = [
        "--preview 'bat --color=always {}'"
        "--preview-window '~3'"
      ];
    };
    changeDirWidget = {
      command = command "d";
      options = [ "--preview 'tree -C {} | head -200'" ];
    };
    historyWidget.command = "";
  };
}
