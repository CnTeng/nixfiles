{ config, lib, user, ... }:

with lib;

let cfg = config.shell.module;
in {
  options.shell.module = {
    zoxide = mkEnableOption "zoxide" // { default = cfg.enable; };
  };

  config = mkIf cfg.zoxide {
    home-manager.users.${user} = { programs.zoxide = { enable = true; }; };
  };
}
