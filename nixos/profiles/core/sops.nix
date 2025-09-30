{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  sops = {
    defaultSopsFile = ../../../infra/outputs/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key";
  };

  preservation'.os.directories = [
    {
      directory = "/var/lib/sops-nix";
      mode = "0700";
      inInitrd = true;
    }
  ];
}
