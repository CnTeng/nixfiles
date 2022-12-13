{ lib, config, pkgs, agenix, user, ... }:

{
  security = {
    tpm2.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  environment.systemPackages = [
    agenix.defaultPackage.x86_64-linux
  ];

  age.identityPaths =
    map
      (e: e.path)
      (lib.filter (e: e.type == "rsa" || e.type == "ed25519") config.services.openssh.hostKeys)
    ++ [
      ../../../secrets/identities/yubikey-yufei.txt
    ];
}
