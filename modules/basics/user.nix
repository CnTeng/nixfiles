{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.basics'.user;
in {
  options.basics'.user = {
    enable = mkEnableOption "user config" // {default = true;};
  };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = true;
      users.${user} = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPassword = "$y$j9T$riMCfL.4mC/J482G5yj..1$d1hE7FKgRGPGtO.d4sIWVT6NB0x6RIIH46ZsZB.YUe.";
      };
    };
  };
}
