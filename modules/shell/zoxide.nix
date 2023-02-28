{ config, lib, user, ... }:

with lib;

let cfg = config.custom.shell.zoxide;
in {
  options.custom.shell.zoxide = {
    enable = mkEnableOption "zoxide" // { default = true; };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = { programs.zoxide = { enable = true; }; };
  };
}
