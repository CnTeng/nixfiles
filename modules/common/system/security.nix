{ lib, config, pkgs, agenix, user, ... }:

{
  security = {
    tpm2.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  environment.systemPackages = [
    agenix.defaultPackage.x86_64-linux
  ] ++ (with pkgs; [
    rage
    age-plugin-yubikey
  ]);

  age.identityPaths = [
    # To do list
    # ../../../secrets/identities/yubikey-yufei.txt
    /home/yufei/.ssh/id_ed25519
  ];
}
