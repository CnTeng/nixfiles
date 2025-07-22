{
  hm'.programs.bash = {
    enable = true;
    historyFile = "$XDG_DATA_HOME/bash/bash_history";
  };

  preservation'.user.directories = [ ".local/share/bash" ];
}
