{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      (android-studio.override {
        tiling_wm = true;
        nss = pkgs.nss_latest; # Fix can't open url
      })
      kotlin
    ];
  };
}
