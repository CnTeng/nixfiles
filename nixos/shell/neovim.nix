{
  inputs,
  config,
  lib,
  user,
  pkgs,
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
        extraPackages = with pkgs; [
          nil
          alejandra
          prettierd
        ];
        gptSupport = {
          enable = true;
          secrets = {
            hostPath = config.sops.secrets."chatgpt/host".path;
            keyPath = config.sops.secrets."chatgpt/key".path;
          };
        };
      };

      xdg.desktopEntries.nvim-kitty = {
        exec = "${getExe pkgs.kitty} -e nvim %F"; # launch with kitty
        icon = "nvim";
        comment = "Edit text files";
        terminal = false;
        name = "Neovim Kitty";
        genericName = "Text Editor";
        categories = ["Utility" "TextEditor"];
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
