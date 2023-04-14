{ sources, lib, autoPatchelfHook, dpkg, qt5, }:
qt5.mkDerivation {
  inherit (sources.wemeet) pname version src;

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = with qt5; [ qtwebengine qtx11extras ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    mkdir -p $out/wemeet
    mv opt/wemeet/bin $out/wemeet/bin

    makeQtWrapper $out/wemeet/bin/wemeetapp $out/bin/wemeetapp \
      --set-default IBUS_USE_PORTAL 1 \
      --set-default QT_STYLE_OVERRIDE fusion

    mkdir -p $out/wemeet/lib
    mv -t $out/wemeet/lib \
      opt/wemeet/lib/libwemeet* \
      opt/wemeet/lib/libxnn* \
      opt/wemeet/lib/libxcast* \
      opt/wemeet/lib/libImSDK.so \
      opt/wemeet/lib/libui_framework.so \
      opt/wemeet/lib/libnxui* \
      opt/wemeet/lib/libdesktop_common.so \
      opt/wemeet/lib/libqt_* \
      opt/wemeet/lib/libservice_manager.so \

    mkdir -p $out/share
    mv usr/share/applications $out/share

    substituteInPlace $out/share/applications/wemeetapp.desktop \
      --replace "/opt/wemeet/wemeetapp.sh" "$out/bin/wemeetapp" \
      --replace "/opt/wemeet/wemeet.svg" "wemeetapp"
  '';

  postFixup = ''
    wrapProgram $out/bin/wemeetapp \
      --set XDG_SESSION_TYPE x11 \
      --set QT_QPA_PLATFORM xcb \
      --unset WAYLAND_DISPLAY
  '';

  meta = with lib; {
    homepage = "https://meeting.tencent.com";
    description = "Tencent Video Conferencing, tencent meeting";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ yinfeng ];
  };
}
