{ user, ... }:

{
  programs.nix-ld.enable = true;

  home-manager.users.${user} = {
    programs.nix-index.enable = true;
  };
}
