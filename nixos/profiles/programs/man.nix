{ pkgs, ... }:
{
  documentation.dev.enable = true;

  environment.systemPackages = [
    pkgs.man-pages
    pkgs.man-pages-posix
  ];
}
