{
  hm'.programs.atuin = {
    enable = true;
    settings = {
      sync_address = "https://atuin.snakepi.xyz";
      workspaces = true;
      inline_height = 30;
      sync.records = true;
    };
    daemon.enable = true;
  };

  preservation'.user.directories = [ ".local/share/atuin" ];
}
