{ lib, config, user, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/common

    ../../modules/basics

    ../../modules/desktop/hyprland

    # Programs
    ../../modules/programs/kitty.nix
    ../../modules/programs/alacritty.nix
    ../../modules/programs/onedrive.nix
    ../../modules/programs/firefox.nix
    ../../modules/programs/kvm.nix
    # ../../modules/programs/looking-glass.nix
    ../../modules/programs/vscode.nix
    ../../modules/programs/idea.nix
    ../../modules/programs/kdeconnect.nix
    ../../modules/programs/steam.nix
    ../../modules/programs/obs-studio.nix
    ../../modules/programs/others.nix
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
          # ReadFile is not recommended for agenix just hide ssh ip
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
