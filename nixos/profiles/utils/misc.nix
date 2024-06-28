{ pkgs, user, ... }:
{
  programs.direnv.enable = true;
  programs.screen.enable = true;

  environment.enableAllTerminfo = true;

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".local/share/zoxide" ];
  };

  home-manager.users.${user} = {
    programs.zoxide.enable = true;
    programs.fastfetch.enable = true;
    programs.ripgrep.enable = true;
    programs.fd.enable = true;

    home.packages = with pkgs; [
      wget
      tree
      lrzsz
      scc
      gzip
      unrar
      unzipNLS
    ];
  };
}
