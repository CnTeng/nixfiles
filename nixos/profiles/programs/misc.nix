{ pkgs, ... }:
{
  hm' = {
    programs.fastfetch.enable = true;
    programs.fd.enable = true;
    programs.ripgrep.enable = true;
    programs.screen.enable = true;

    home.packages = with pkgs; [
      tree
      unrar
      unzipNLS
      wget
    ];
  };
}
