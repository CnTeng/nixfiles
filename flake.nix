{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    agenix.url = "github:ryantm/agenix";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprpicker.url = "github:hyprwm/hyprpicker";

    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      user = "yufei";
      overlays = import ./overlays;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = with overlays; [ additions modifications ];
      };

      hmOptions = [{
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit outputs inputs user; };
        };
      }];
      commonModules = [ home-manager.nixosModules.home-manager ] ++ hmOptions;
    in {
      nixosConfigurations = {
        rxdell = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit outputs inputs system user; };
          modules = [ ./hosts/laptop ] ++ commonModules;
        };

        rxaws = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit outputs inputs system user; };
          modules = [ ./hosts/server ] ++ commonModules;
        };

        rxtx = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit outputs inputs system user; };
          modules = [ ./hosts/server ] ++ commonModules;
        };
      };
    };
}
