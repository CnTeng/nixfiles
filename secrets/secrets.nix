let
  yufei = "age1yubikey1q27kxdp7zrdlu40vjcma83xxv7ustj735hnnvs4sqwu8wgwjs96t2m89wfq";

  rxdell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdVbfaaH+mNRUmRD2tU1okUkqjXMaxZKnZE/H8hHEc9 root@rxdell";
  rxaws = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFpv02wmbI70fdtKfthKvpYTtvqxKkX8RQrkp+YqePDp root@rxaws";
  rxhz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/xy3Gu4tXN8ecMnTjaw9w3a3cBVLDUt4iYkE/ZvZEY root@rxhz";
in {
  "services/cache.age".publicKeys = [yufei rxhz];
  "services/caddy.age".publicKeys = [yufei rxaws rxhz];
  "services/miniflux.age".publicKeys = [yufei rxhz];
  "services/naive.age".publicKeys = [yufei rxaws rxhz];
  "services/vaultwarden.age".publicKeys = [yufei rxhz];

  "shell/naive.age".publicKeys = [yufei rxdell];
}
