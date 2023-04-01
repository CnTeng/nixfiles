{ config, lib, user, ... }:
with lib;
let cfg = config.shell'.zoxide;
in {
  options.shell'.zoxide.enable = mkEnableOption "zoxide" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = { programs.zoxide = { enable = true; }; };
  };
}
