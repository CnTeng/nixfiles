{ lib, config, user, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/common

    ../../modules/basics

    ../../modules/desktop/hyprland

    # programs
    ../../modules/programs/alacritty.nix
    ../../modules/programs/kitty.nix
    ../../modules/programs/firefox.nix
    ../../modules/programs/onedrive.nix
    ../../modules/programs/kdeconnect.nix
    ../../modules/programs/steam.nix
    ../../modules/programs/others.nix

    # develop
    ../../modules/develop/java.nix
    ../../modules/develop/vscode.nix
    ../../modules/develop/kvm.nix

  ];

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "rxdell";
    networkmanager.enable = true;
  };

  age = {
    secrets = {
      rxtxHostname = {
        file = ../../secrets/ssh/rxtxHostname.age;
        owner = "${user}";
        group = "users";
        mode = "644";
      };
      rxtxKey = {
        file = ../../secrets/ssh/rxtxKey.age;
        owner = "${user}";
        group = "users";
        mode = "600";
      };
    };
  };

  home-manager.users.${user} = {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "rxtx" = {
          hostname = builtins.readFile config.age.secrets.rxtxHostname.path;
          user = "yufei";
          port = 23;
          identityFile = [
            config.age.secrets.rxtxKey.path
          ];
        };
      };
    };
  };
}
