{ inputs, user, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/nix/persistent" = {
    hideMounts = true;
    directories =
      [ "/var" "/etc/NetworkManager/system-connections" "/home" "/var" ];
    files = [ "/etc/machine-id" ];
    users.${user} = {
      directories = [
        "Documents"
        "Downloads"
        "Pictures"
        "Projects"
        ".cache"
        ".local"
        ".mozilla"
        ".ssh"
        ".thunderbird"
        ".config/fcitx5"
      ];
    };
  };
  systemd.services.nix-daemon = {
    environment = {
      # 指定临时文件的位置
      TMPDIR = "/var/cache/nix";
    };
    serviceConfig = {
      # 在 Nix Daemon 启动时自动创建 /var/cache/nix
      CacheDirectory = "nix";
    };
  };
  environment.variables.NIX_REMOTE = "daemon";

}
