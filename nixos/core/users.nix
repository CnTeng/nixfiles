{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.core'.users;
  hashedPassword = "$y$j9T$riMCfL.4mC/J482G5yj..1$d1hE7FKgRGPGtO.d4sIWVT6NB0x6RIIH46ZsZB.YUe.";
in
{
  options.core'.users.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = true;

      users = {
        root = {
          inherit hashedPassword;
        };
        ${user} = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          inherit hashedPassword;
        };
      };
    };
  };
}
