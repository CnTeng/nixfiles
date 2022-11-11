{ pkgs, agenix, user, ... }:

{
  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  environment.systemPackages = [
    agenix.defaultPackage.x86_64-linux
  ];
  age.identityPaths = [
    "/home/${user}/OneDrive/Backups/Agenix/agenix_ed25519"
  ];
}
