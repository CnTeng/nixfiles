{ config, lib, ... }:

with lib; {
  imports = [
    ./zsh.nix
    ./fish.nix
    ./starship.nix
    ./neovim
    ./tmux.nix
    ./git.nix
    ./fzf.nix
    ./lf.nix
    ./zoxide.nix
    ./btop.nix
    ./proxy
    ./others.nix
    ./env.nix
  ];

  options.shell.module = {
    enable = mkEnableOption "shell modules" // { default = true; };
  };
}
