{ pkgs, user, ... }:

{
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  home-manager.users.${user} = {
    programs.gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true;
      };
      settings = {
        no-comments = false;
      };
    };
  };
}
