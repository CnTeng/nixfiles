{
  inputs,
  config,
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user} = {
    imports = [ inputs.rx-nvim.homeModules.default ];

    programs.rx-nvim = {
      enable = true;
      extraPackages = with pkgs; [
        nil
        nixfmt-rfc-style
        prettierd
      ];
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
}
