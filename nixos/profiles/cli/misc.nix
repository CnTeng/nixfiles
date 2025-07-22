{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (config.core') user;
in
{
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  documentation.dev.enable = true;
  environment.systemPackages = [
    pkgs.man-pages
    pkgs.man-pages-posix
    pkgs.kitty.terminfo
  ];

  programs.direnv.enable = true;
  programs.screen.enable = true;
  programs.nix-index-database.comma.enable = true;

  preservation.preserveAt."/persist" = {
    users.${user}.directories = [ ".local/share/direnv" ];
  };

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
