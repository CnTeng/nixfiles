{ inputs, user, ... }:
{
  imports = [ inputs.rx-nvim.nixosModules.default ];

  programs.rx-nvim.enable = true;

  environment.persistence."/persist" = {
    users.${user}.directories = [
      ".local/share/nvim"
      ".local/state/nvim"
      ".cache/nvim"
      ".config/github-copilot"
    ];
  };
}
