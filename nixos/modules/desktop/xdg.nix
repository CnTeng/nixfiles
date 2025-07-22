{
  config,
  lib,
  ...
}:
let
  cfg = config.desktop'.xdg;
  inherit (config.core') user;

  mkDefaultApp = app: mimeTypes: lib.genAttrs mimeTypes (_: app);

  browserMimeTypes = [
    "text/html"
    "text/xml"
    "application/xml"
    "application/xhtml+xml"
    "application/xhtml_xml"
    "application/rdf+xml"
    "application/rss+xml"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/x-extension-xht"
    "application/x-extension-xhtml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/chrome"
  ];

  editorMimeTypes = [
    "text/plain"
    "text/markdown"
  ];

  imageMimeTypes = [
    "image/bmp"
    "image/gif"
    "image/jpeg"
    "image/jpg"
    "image/jxl"
    "image/pjpeg"
    "image/png"
    "image/tiff"
    "image/webp"
    "image/x-bmp"
    "image/x-gray"
    "image/x-icb"
    "image/x-ico"
    "image/x-png"
    "image/x-portable-anymap"
    "image/x-portable-bitmap"
    "image/x-portable-graymap"
    "image/x-portable-pixmap"
    "image/x-xbitmap"
    "image/x-xpixmap"
    "image/x-pcx"
    "image/svg+xml"
    "image/svg+xml-compressed"
    "image/vnd.wap.wbmp"
    "image/x-icns"
  ];

  pdfMimeTypes = [ "application/pdf" ];

  default = {
    terminal = "kitty.desktop";
    editor = "nvim.desktop";
    browser = "firefox.desktop";
    imageViewer = "org.gnome.eog.desktop";
    pdfViewer = "org.gnome.Evince.desktop";
  };
in
{
  options.desktop'.xdg.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    xdg.terminal-exec = {
      enable = true;
      settings.default = [ default.terminal ];
    };

    home-manager.users.${user} = {
      xdg.userDirs.enable = true;

      xdg.mimeApps = {
        enable = true;
        defaultApplications =
          mkDefaultApp default.browser browserMimeTypes
          // mkDefaultApp default.editor editorMimeTypes
          // mkDefaultApp default.imageViewer imageMimeTypes
          // mkDefaultApp default.pdfViewer pdfMimeTypes;
      };
    };

    preservation.preserveAt."/persist" = {
      users.${user}.directories = [
        "Documents"
        "Downloads"
        "Pictures"
        "Projects"
      ];
    };
  };

}
