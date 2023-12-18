{ inputs, config, lib, pkgs, user, ... }:
with lib;
let cfg = config.shell'.neovim;
in {
  options.shell'.neovim.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      imports = [ inputs.rx-nvim.homeModules.default ];

      programs.rx-nvim = {
        enable = true;
        extraPackages = with pkgs; [ nil nixfmt prettierd ];
        extraConfig = ''
          vim.g.gptsupport = true
          vim.g.gpthost = "${config.sops.secrets."chatgpt/host".path}"
          vim.g.gptkey= "${config.sops.secrets."chatgpt/key".path}"
        '';
      };
    };

    sops.secrets = {
      "chatgpt/host" = {
        owner = user;
        sopsFile = ./secrets.yaml;
      };

      "chatgpt/key" = {
        owner = user;
        sopsFile = ./secrets.yaml;
      };
    };
  };
}
