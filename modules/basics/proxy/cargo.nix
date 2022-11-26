{ user, ... }:

{
  # Proxy for cargo
  home-manager.users.${user} = {
    home.file.".cargo/config.toml".text = ''
      [http]
      proxy = "http://127.0.0.1:10809"
    '';
  };
}
