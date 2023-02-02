{ pkgs, user, ... }:

{
  programs = {
    # nix-ld.enable = true;

    # Use nix-index instead of cnf
    command-not-found.enable = false;
    nix-index.enable = true;
  };
}
