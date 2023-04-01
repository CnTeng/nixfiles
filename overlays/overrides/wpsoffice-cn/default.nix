pkgs: oldAttrs: {
  # Fix WPS scaling
  postFixup = ''
    for f in "$out"/bin/*; do
      echo "Wrapping $f"
      wrapProgram "$f" \
        "''${gappsWrapperArgs[@]}" \
        "''${qtWrapperArgs[@]}" \
        --set QT_SCALE_FACTOR 1
    done
  '';
}
