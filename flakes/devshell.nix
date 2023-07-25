{inputs, ...}: {
  imports = [inputs.devshell.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devshells.default = {
      commands = [
        {
          name = "rebuild";
          category = "deploy";
          help = "nixos rebuild switch";
          command = "sudo nixos-rebuild switch --flake .#$@";
        }
      ];

      packages = with pkgs; [
        colmena
        nvfetcher
        agenix
      ];
    };
  };
}
