{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  zstd,
  gtk4,
  fontconfig,
  freetype,
  oniguruma,
  libGL,
  libglvnd,
  harfbuzz,
  glib,
  cairo,
  pango,
  libepoxy,
  libxkbcommon,
  graphene,
  gdk-pixbuf,
  wayland,
  vulkan-loader,
  libx11,
  libxi,
  libxrandr,
  libxcursor,
  libnotify,
}: let
  runtimeLibs = [
    gtk4
    fontconfig
    freetype
    oniguruma
    libGL
    libglvnd
    harfbuzz
    glib
    cairo
    pango
    libepoxy
    libxkbcommon
    graphene
    gdk-pixbuf
    wayland
    vulkan-loader
    libx11
    libxi
    libxrandr
    libxcursor
  ];
in
  stdenv.mkDerivation rec {
    pname = "cmux-linux";
    version = "0.1.0";

    src = fetchurl {
      url = "https://github.com/bradwilson331/cmux-linux/releases/download/${version}/cmux_${version}_amd64.deb";
      hash = "sha256-oh0VzluAV31g0EKGy9H6A87s8WSvbXSnoyWJuiPzJy4=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      zstd
    ];

    buildInputs = runtimeLibs;

    unpackPhase = ''
      runHook preUnpack
      ar x "$src"
      tar --zstd -xf data.tar.zst
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -a usr/* "$out"/

      # The Debian launcher execs /usr/bin/cmux-app.bin. Replace it with a Nix
      # wrapper that preserves upstream's display-backend workaround.
      rm "$out/bin/cmux-app"
      makeWrapper "$out/bin/cmux-app.bin" "$out/bin/cmux-app" \
        --prefix PATH : ${lib.makeBinPath [libnotify]}:$out/bin \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
        --run 'if [ -z "''${GDK_BACKEND:-}" ]; then case "''${XDG_SESSION_TYPE:-}" in x11) export GDK_BACKEND=x11 ;; wayland) if command -v nvidia-smi >/dev/null 2>&1; then export GDK_BACKEND=x11; fi ;; esac; fi'

      # cmux-app can discover agent-browser next to itself or in PATH; expose the
      # helper binaries shipped by the upstream package.
      ln -s ../lib/cmux/agent-browser "$out/bin/agent-browser"
      ln -s ../lib/cmux/cmuxd-remote "$out/bin/cmuxd-remote"

      runHook postInstall
    '';

    meta = with lib; {
      description = "GPU-accelerated terminal multiplexer with tabs, splits, workspaces, browser automation, and socket CLI control";
      homepage = "https://github.com/bradwilson331/cmux-linux";
      license = licenses.agpl3Plus;
      mainProgram = "cmux";
      platforms = ["x86_64-linux"];
      sourceProvenance = with sourceTypes; [binaryNativeCode];
    };
  }
