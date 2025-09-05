{
  programs.direnv.enable = true;

  preservation'.user.directories = [ ".local/share/direnv" ];
}
