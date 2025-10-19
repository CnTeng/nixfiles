{
  description = "A highly customized NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      inputs.flake-parts.follows = "flake-parts";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rx-nvim = {
      url = "github:CnTeng/rx-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks-nix.follows = "git-hooks-nix";
    };

    ph = {
      url = "github:CnTeng/ph";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks-nix.follows = "git-hooks-nix";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        inputs.git-hooks-nix.flakeModule
        ./hosts
        ./nixos
        ./pkgs
      ];

      perSystem =
        { config, pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              jq
              sops
              age
              nix-update
              nixos-anywhere
              (opentofu.withPlugins (p: [
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

            shellHook = config.pre-commit.installationScript;
          };

          formatter = pkgs.nixfmt-tree.override {
            settings.formatter.terraform = {
              command = "tofu";
              options = [ "fmt" ];
              includes = [
                "*.tf"
                "*.tfvars"
              ];
            };
          };

          pre-commit.settings.hooks = {
            treefmt = {
              enable = true;
              package = config.formatter;
            };
            commitizen.enable = true;
          };
        };
    };
}
