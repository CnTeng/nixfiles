{
  self,
  inputs,
  ...
}: {
  flake = {pkgs, ...}: let
    lib = inputs.nixpkgs.lib.extend (import ../lib);
    sources = pkgs.callPackage ../overlays/_sources/generated.nix {};
    user = "yufei";
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays =
        [self.overlays.default]
        ++ map (n: inputs.${n}.overlays.default) [
          "hyprland"
          "hyprwm-contrib"
        ];
    };

    nixosConfigurations = self.colmenaHive.nodes;

    colmenaHive = inputs.colmena.lib.makeHive {
      meta = {
        nixpkgs = pkgs;
        specialArgs = {inherit inputs lib sources user;};
      };

      defaults = {
        lib,
        name,
        ...
      }: {
        deployment = {
          targetHost = lib.mkDefault "${name}";
          tags = ["${name}"];
        };
        networking.hostName = "${name}";
        imports = [self.nixosModules.default ./${name}];
      };

      rxdell.deployment = {
        allowLocalDeployment = true;
        targetHost = null;
      };

      rxwsl.deployment = {
        allowLocalDeployment = true;
        targetHost = null;
      };

      rxls0.deployment = {};

      rxhc0 = {
        deployment.buildOnTarget = true;
        nixpkgs.system = "aarch64-linux";
      };
    };
  };
}
