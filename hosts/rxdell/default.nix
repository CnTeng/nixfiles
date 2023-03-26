_: {
  imports = [
    ./hardware.nix

    ../../modules/basics
    ../../modules/desktop
    ../../modules/programs
    ../../modules/services
    ../../modules/shell
  ];

  custom = {
    desktop.hyprland.enable = true;
    programs = {
      wezterm.enable = true;
      alacritty.enable = true;
      android.enable = true;
      chrome.enable = true;
      feh.enable = true;
      firefox.enable = true;
      foliate.enable = true;
      idea.enable = true;
      kdeconnect.enable = true;
      kitty.enable = true;
      obs.enable = true;
      others.enable = true;
      pycharm.enable = true;
      steam.enable = true;
      vscode.enable = true;
      yubikey.enable = true;
    };
    services.onedrive.enable = true;
    shell.neovim.withNixTreesitter = false;
  };
}
