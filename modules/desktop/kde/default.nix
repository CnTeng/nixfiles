{ pkgs, user, ... }:

{
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  programs.dconf.enable = true;

  # imports = [
  #   ../modules/theme.nix
  # ];

  home-manager.users.${user} = { };

  # Sound
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  environment.systemPackages = [
  ];
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}
