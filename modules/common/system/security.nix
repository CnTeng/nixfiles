{ pkgs, agenix, user, ... }:

{
  security = {
    tpm2.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  environment.systemPackages = [
    agenix.defaultPackage.x86_64-linux
  ];
  age.identityPaths = [
    "/home/${user}/OneDrive/Backups/agenix/agenix_ed25519"
  ];
}
