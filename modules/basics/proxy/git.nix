{ user, ... }:

{
  home-manager.users.${user} = {
    programs.git.extraConfig = {
      http.proxy = "http://127.0.0.1:10809";
      https.proxy = "http://127.0.0.1:10809";
    };

    programs.ssh.matchBlocks."github.com" = {
      proxyCommand = "nc -v -x 127.0.0.1:10808 %h %p";
    };
  };
}
