{ user, ... }:
{
  programs.gnupg.agent.enable = true;

  services.pcscd.enable = true;

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".gnupg" ];
  };
}
