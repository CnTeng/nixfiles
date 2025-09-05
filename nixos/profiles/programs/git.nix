{
  programs.git.enable = true;

  hm'.programs.git = {
    enable = true;
    userName = "CnTeng";
    userEmail = "rxsnakepi@gmail.com";
    signing = {
      key = "~/.ssh/id_ed25519_sk_rk_ybk5@sign";
      format = "ssh";
      signByDefault = true;
    };
    extraConfig = {
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };

    lfs.enable = true;

    delta = {
      enable = true;
      options = {
        dark = true;
        line-numbers = true;
      };
    };
  };
}
