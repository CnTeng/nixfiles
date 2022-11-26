{ user, ... }:

{
  # Network
  programs.nm-applet.enable = true;

  # Blueman
  services.blueman.enable = true;

  home-manager.users.${user} = {
    services.blueman-applet.enable = true;
  };
}
