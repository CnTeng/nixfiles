{
  inputs,
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.neovim;
in {
  options.shell'.neovim = {
    enable = mkEnableOption "Neovim" // {default = true;};
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      imports = [inputs.rx-nvim.homeModules.default];
      programs.rx-nvim = {
        enable = true;
        gCalendar = {
          enable = true;
          CredPath = config.age.secrets.neovim.path;
        };
      };
    };

    age.secrets.neovim = {
      file = ../../secrets/shell/neovim.age;
      path = "/var/lib/credentials.lua";
      owner = "${user}";
      group = "users";
      mode = "644";
    };
  };
}
