{
  description = "A highly customized NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
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

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    rx-nvim = {
      url = "github:CnTeng/rx-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks-nix.follows = "git-hooks-nix";
      inputs.treefmt.follows = "treefmt";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    todoist-cli = {
      url = "github:CnTeng/todoist-cli";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks-nix.follows = "git-hooks-nix";
      inputs.treefmt.follows = "treefmt";
    };

    ph = {
      url = "github:CnTeng/ph";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks-nix.follows = "git-hooks-nix";
      inputs.treefmt.follows = "treefmt";
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
        inputs.treefmt.flakeModule
        ./hosts
        ./lib
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
              nixos-anywhere
              (opentofu.withPlugins (p: [
                p.aws
                p.cloudflare
                p.github
                p.hcloud
                p.local
                p.null
                p.sops
                p.tailscale
                p.tls
              ]))
              config.treefmt.build.wrapper
            ];

            shellHook = config.pre-commit.installationScript;
          };

          pre-commit.settings.hooks = {
            commitizen.enable = true;
            treefmt.enable = true;
          };

          treefmt.programs = {
            nixfmt.enable = true;
            prettier.enable = true;
            shfmt.enable = true;
            taplo.enable = true;
            terraform.enable = true;
          };
        };
    };
}
