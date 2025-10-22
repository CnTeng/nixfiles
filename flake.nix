{
  description = "A highly customized NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rx-nvim = {
      url = "github:CnTeng/rx-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ph = {
      url = "github:CnTeng/ph";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ self.overlays.default ];
        };

      forEachSystem =
        f:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: f (mkPkgs system));

      inherit (nixpkgs) lib;
    in
    {
      overlays.default = import ./pkgs;

      nixosModules = import ./nixos { inherit lib; };

      nixosConfigurations = import ./hosts { inherit inputs lib self; };

      legacyPackages = forEachSystem (pkgs: pkgs);

      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            jq
            sops
            age
            nix-update
            nixos-anywhere
            (pkgs.opentofu.withPlugins (p: [
              p.carlpett_sops
              p.cloudflare_cloudflare
              p.hashicorp_aws
              p.hashicorp_local
              p.hashicorp_null
              p.hashicorp_tls
              p.hetznercloud_hcloud
              p.integrations_github
              p.tailscale_tailscale
            ]))
          ];
        };
      });

      formatter = forEachSystem (
        pkgs:
        pkgs.nixfmt-tree.override {
          settings.formatter.terraform = {
            command = "tofu";
            options = [ "fmt" ];
            includes = [
              "*.tf"
              "*.tfvars"
            ];
          };
          runtimeInputs = [ pkgs.opentofu ];
        }
      );
    };
}
