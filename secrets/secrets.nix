let
  yufei = "age1yubikey1q27kxdp7zrdlu40vjcma83xxv7ustj735hnnvs4sqwu8wgwjs96t2m89wfq";

  rxdell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdVbfaaH+mNRUmRD2tU1okUkqjXMaxZKnZE/H8hHEc9 root@rxdell";
  rxaws = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFpv02wmbI70fdtKfthKvpYTtvqxKkX8RQrkp+YqePDp root@rxaws";
  rxhz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIES63us7aetYxZ/PBmH+SVXGRkm/RvPL0BzapOxXK1aI root@rxhz";

  rxwsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOjhbscZlVg9carFm5OYQhhdMEuhfYNmZoOopK6ymik+ root@rxwsl";
in {
  "services/cache.age".publicKeys = [yufei rxhz];
  "services/caddy.age".publicKeys = [yufei rxaws rxhz];
  "services/dae.age".publicKeys = [yufei rxdell];
  "services/miniflux.age".publicKeys = [yufei rxhz];
  "services/naive.age".publicKeys = [yufei rxaws rxhz];
  "services/vaultwarden.age".publicKeys = [yufei rxhz];

  "shell/chatgpt.age".publicKeys = [yufei rxdell rxaws rxhz rxwsl];
}
