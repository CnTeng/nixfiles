{ user, ... }:

{
  services.calibre-web = {
    enable = true;
    user = "${user}";
    group = "users";
    listen = {
      ip = "127.0.0.1";
      port = 7222;
    };
    openFirewall = true;
    options = {
      enableBookUploading = true;
      enableBookConversion = true;
      calibreLibrary = /home/${user}/OneDrive/Calibre;
    };
  };
}
