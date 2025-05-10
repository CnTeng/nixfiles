{
  boot.kernelParams = [ "console=tty1" ];

  console.useXkbConfig = true;
  services.xserver.xkb.options = "ctrl:nocaps";
}
