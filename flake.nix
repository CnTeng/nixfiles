{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    agenix.url = "github:ryantm/agenix";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprpicker.url = "github:hyprwm/hyprpicker";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    colmena.url = "github:zhaofengli/colmena";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      overlays = import ./overlays;
      system = "x86_64-linux";
      user = "yufei";
    in {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = with overlays;
              [ additions modifications ] ++ [ inputs.colmena.overlay ];
          };
          specialArgs = { inherit inputs system user; };
        };
        rxdell = { name, ... }: {
          deployment = {
            allowLocalDeployment = true;
            targetHost = null;
            tags = [ "${name}" ];
          };
          networking.hostName = "${name}";
          imports = [ ./hosts/${name} ];
        };

        rxaws = { name, ... }: {
          deployment = {
            targetHost = "rxaws";
            tags = [ "${name}" "servers" ];
            buildOnTarget = true;
          };
          networking.hostName = "${name}";
          imports = [ ./hosts/${name} ];
        };

        rxhz = { name, ... }: {
          deployment = {
            targetHost = "rxhz";
            tags = [ "${name}" "servers" ];
            buildOnTarget = true;
          };
          networking.hostName = "${name}";
          imports = [ ./hosts/${name} ];
        };
      };
    };
}
