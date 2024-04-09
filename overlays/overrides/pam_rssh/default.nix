{ prev, ... }:
prev.pam_rssh.override { openssh = prev.openssh.override { dsaKeysSupport = true; }; }
