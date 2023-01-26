{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprpicker.url = "github:hyprwm/hyprpicker";

    nix-alien.url = "github:thiagokokada/nix-alien";
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
        overlays = with overlays; [
          additions
          modifications
        ] ++ [
          inputs.nix-alien.overlays.default
        ];
      };

      hmOptions = [{
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit outputs inputs user; };
        };
      }];
      commonModules = [
        home-manager.nixosModules.home-manager
      ] ++ hmOptions;
    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit outputs inputs user; };
          modules = [ ./hosts/laptop ] ++ commonModules;
        };

        server = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit outputs inputs user; };
          modules = [ ./hosts/server ] ++ commonModules;
        };
      };
    };
}
