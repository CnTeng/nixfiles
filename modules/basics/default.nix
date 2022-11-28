{ ... }:

{
  imports = [
    ./boot.nix
    ./devices.nix
    ./nvidia.nix
    ./wireless.nix
    ./fonts.nix
    ./fcitx.nix
    ./ssh.nix
    ./proxy
  ];
}
