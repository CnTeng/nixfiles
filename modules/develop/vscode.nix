{ pkgs, user, ... }:

{
  # environment.sessionVariables = {
  #   NIXOS_OZONE_WL = "1";
  # };
  # For logining the Microsoft in vscode

  services.gnome.gnome-keyring.enable = true;
  home-manager.users.${user} = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode-fhs;
    };
  };
}
