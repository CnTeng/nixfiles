{ pkgs, user, ... }:
{
  programs.direnv.enable = true;

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".local/share/zoxide" ];
  };

  home-manager.users.${user} = {
    programs.zoxide.enable = true;

    home.packages = with pkgs; [
      wget
      tree
      fastfetch
      scc
      gzip
      unrar
      unzipNLS
    ];
  };
}
