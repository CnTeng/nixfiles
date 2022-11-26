{ ... }:

{
  imports = [
    ./boot.nix
    ./devices.nix
    ./wireless.nix
    ./fonts.nix
    ./fcitx.nix
    ./ssh.nix
    ./proxy
  ];
}
