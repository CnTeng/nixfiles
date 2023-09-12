{inputs, ...}: {
  imports = [inputs.devshell.flakeModule];

  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: {
    devshells.default = {
      commands = let
        terraform = pkgs.terraform.withPlugins (p: with p; [cloudflare sops hcloud]);
      in [
        {
          name = "rebuild";
          category = "deploy";
          help = "nixos rebuild switch";
          command = "sudo nixos-rebuild switch --flake .#$@";
        }
        {
          name = "terraform";
          category = "deploy";
          command = ''
            sops --output-type json \
                 --output terraform.tfstate \
                 --decrypt tfstate.yaml

            if [ $? -eq 0 ]; then
                echo -e "sops: decryption successful\n"
            else
                echo -e "sops: decryption failed\n"
            fi

            ${lib.getExe terraform} $@

            sops --input-type json \
                 --output-type yaml \
                 --output tfstate.yaml \
                 --encrypt terraform.tfstate

            if [ $? -eq 0 ]; then
                echo -e "\nsops: encryption successful"
            else
                echo -e "\nsops: encryption failed"
            fi
          '';
        }
      ];

      packages = with pkgs; [
        colmena
        nvfetcher
        sops
        terraform-ls
      ];
    };
  };
}
