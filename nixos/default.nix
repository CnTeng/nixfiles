{ self, inputs, ... }:
let user = "yufei";
in {
  flake = { pkgs, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [ self.overlays.default ]
        ++ map (n: inputs.${n}.overlays.default) [
          "colmena"
          "agenix"
          "hyprpicker"
          # "emacs-overlay"
        ];
    };

    nixosConfigurations = self.colmenaHive.nodes;

    colmenaHive = inputs.colmena.lib.makeHive {
      meta = {
        nixpkgs = pkgs;
        specialArgs = { inherit inputs user; };
      };

      defaults = { lib, name, ... }: {
        deployment = {
          targetHost = lib.mkDefault "${name}";
          tags = [ "${name}" ];
        };
        networking.hostName = "${name}";
        imports = [ self.nixosModules.default ./${name} ];
      };

      rxdell.deployment = {
        allowLocalDeployment = true;
        targetHost = null;
      };

      rxaws.deployment = { };

      rxhz.deployment.buildOnTarget = true;
    };
  };
}
