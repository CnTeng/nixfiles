{
  inputs,
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.desktop'.cosmic;
in
{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
    ./fonts.nix
    ./input.nix
    ./theme.nix
    ./xdg.nix
  ];

  options.desktop'.cosmic.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    cosmic.profiles = {
      fonts.enable = true;
      input.enable = true;
      theme.enable = true;
      xdg.enable = true;
    };

    environment.systemPackages = with pkgs; [ wl-clipboard ];

    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";

    home-manager.users.${user} = {
      xdg.mimeApps.enable = true;

      systemd.user.targets.tray = {
        Unit = {
          Description = "Home Manager System Tray";
          Requires = [ "graphical-session-pre.target" ];
        };
      };
    };

    environment.persistence."/persist" = {
      directories = [ "/etc/NetworkManager/system-connections" ];
      users.${user}.directories = [
        ".config/dconf"
        ".config/cosmic"
        ".local/share/keyrings"
        ".local/state/wireplumber"
        ".local/state/cosmic"
        ".local/state/cosmic-comp"
        ".local/state/pop-launcher"
      ];
    };

    programs.file-roller.enable = true;
  };
}
