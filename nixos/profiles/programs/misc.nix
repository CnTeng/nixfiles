{ pkgs, ... }:
{
  programs.screen.enable = true;

  hm' = {
    programs.fastfetch.enable = true;
    programs.ripgrep.enable = true;
    programs.fd.enable = true;

    home.packages = with pkgs; [
      gdu
      tree
      unrar
      unzipNLS
      wget
    ];
  };
}
