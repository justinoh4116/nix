{
  lib,
  stdenvNoCC,
  unzip,
  p7zip,
  fontSource ? let
    repoFonts = ../../../../fonts;
  in
    if builtins.pathExists repoFonts
    then repoFonts
    else null,
}: let
  placeholder = fontSource == null;
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "local-fonts";
    version = "manual";

    src = fontSource;

    dontUnpack = placeholder;

    nativeBuildInputs = lib.optionals (!placeholder) [
      unzip
      p7zip
    ];

    unpackPhase = lib.optionalString (!placeholder) ''
      runHook preUnpack

      mkdir source

      case "$src" in
        *.zip)
          unzip -qq "$src" -d source
          ;;
        *.tar.gz|*.tgz)
          tar -xzf "$src" -C source
          ;;
        *.tar.xz)
          tar -xJf "$src" -C source
          ;;
        *.tar.bz2)
          tar -xjf "$src" -C source
          ;;
        *.7z)
          7z x "$src" -osource >/dev/null
          ;;
        *.otf|*.ttf|*.otc|*.ttc)
          cp "$src" source/
          ;;
        *)
          if [ -d "$src" ]; then
            cp -R "$src"/. source/
          else
            echo "Unsupported Minion font source: $src" >&2
            exit 1
          fi
          ;;
      esac

      runHook postUnpack
    '';

    installPhase =
      if placeholder
      then ''
        runHook preInstall

        mkdir -p $out/share/doc/${finalAttrs.pname}
        cat > $out/share/doc/${finalAttrs.pname}/README <<'EOF'
        Placeholder package for local fonts.

        No font files were found in the repo-local fonts directory:
          /home/justin/safe/nix/fonts

        Add .otf, .otc, .ttf, or .ttc files there, or override `fontSource`
        with a licensed local archive or extracted font directory.
        EOF

        runHook postInstall
      ''
      else ''
        runHook preInstall

        font_count=0
        while IFS= read -r -d "" font; do
          ext="''${font##*.}"
          case "''${ext,,}" in
            ttf|ttc)
              install_dir="$out/share/fonts/truetype"
              ;;
            *)
              install_dir="$out/share/fonts/opentype"
              ;;
          esac

          install -Dm444 "$font" "$install_dir/$(basename "$font")"
          font_count=$((font_count + 1))
        done < <(find source -type f \( -iname "*.otf" -o -iname "*.otc" -o -iname "*.ttf" -o -iname "*.ttc" \) -print0)

        if [ "$font_count" -eq 0 ]; then
          echo "No font files were found in $src" >&2
          exit 1
        fi

        mkdir -p $out/share/doc/${finalAttrs.pname}
        cat > $out/share/doc/${finalAttrs.pname}/README <<'EOF'
        Local fonts installed from the configured local font source.
        EOF

        runHook postInstall
      '';

    meta = with lib; {
      description = "Locally supplied font bundle";
      homepage = "https://github.com/justinoh4116/nix";
      license = licenses.unfree;
      platforms = platforms.all;
      sourceProvenance = with sourceTypes; [binaryNativeCode];
    };
  })
