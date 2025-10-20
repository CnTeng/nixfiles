{
  programs.git.enable = true;

  hm' = {
    programs.git = {
      enable = true;
      signing = {
        key = "~/.ssh/id_ed25519_sk_rk_ybk5@sign";
        format = "ssh";
        signByDefault = true;
      };
      settings = {
        user = {
          name = "CnTeng";
          email = "rxsnakepi@gmail.com";
        };
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };

      lfs.enable = true;
    };

    programs.delta = {
      enable = true;
      options = {
        dark = true;
        line-numbers = true;
      };
      enableGitIntegration = true;
    };
  };
}
