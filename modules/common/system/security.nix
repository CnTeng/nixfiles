{ pkgs, inputs, ... }:

{
  imports = [ inputs.agenix.nixosModules.default ];

  security = {
    tpm2.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  environment.systemPackages = [
    inputs.agenix.packages.x86_64-linux.default
  ] ++ (with pkgs; [
    rage
    age-plugin-yubikey
  ]);

  age.identityPaths = [
    # TODO:add yubikey-yufei
    # ../../../secrets/identities/yubikey-yufei.txt

    /home/yufei/.ssh/id_ed25519
  ];
}
