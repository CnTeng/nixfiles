{ pkgs, user, ... }:
{
  documentation.dev.enable = true;
  environment.systemPackages = [
    pkgs.man-pages
    pkgs.man-pages-posix
    pkgs.kitty.terminfo
  ];

  programs.direnv.enable = true;
  programs.screen.enable = true;

  home-manager.users.${user} = {
    programs.fastfetch.enable = true;
    programs.ripgrep.enable = true;
    programs.fd.enable = true;

    home.packages = with pkgs; [
      gdu
      lrzsz
      scc
      tree
      unrar
      unzipNLS
      wget
    ];
  };
}
