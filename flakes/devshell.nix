{ inputs, ... }: {
  imports = [ inputs.devshell.flakeModule ];

  perSystem = { config, pkgs, lib, ... }: {
    devshells.default = {
      commands = let
        terraform = pkgs.terraform.withPlugins
          (p: with p; [ aws cloudflare sops hcloud ]);
      in [{
        name = "terraform";
        category = "deploy";
        command = ''
          is_fmt=false
          is_version=false

          for arg in "$@"; do
            if [ "$arg" = "fmt" ]; then
              is_fmt=true
            fi

            if [ "$arg" = "version" ]; then
              is_version=true
            fi
          done

          if [ "$is_fmt" = "true" -o "$is_version" = "true" ]; then
            ${lib.getExe terraform} "$@"
            exit 0
          fi

          sops --output-type json \
               --output terraform.tfstate \
               --decrypt tfstate.yaml

          if [ $? -eq 0 ]; then
            echo -e "\033[32msops: decryption successful\033[0m\n"
          else
            echo -e "\033[31msops: decryption failed\033[0m\n"
          fi

          ${lib.getExe terraform} "$@"

          if [ $? -eq 0 ]; then
            sops --input-type json \
                 --output-type yaml \
                 --output tfstate.yaml \
                 --encrypt terraform.tfstate
          fi

          if [ $? -eq 0 ]; then
            echo -e "\n\033[32msops: encryption successful\033[0m"
          else
            echo -e "\n\033[31msops: encryption failed\033[0m"
          fi
        '';
      }];

      packages = with pkgs; [ colmena nvfetcher sops terraform-ls ];
    };
  };
}
