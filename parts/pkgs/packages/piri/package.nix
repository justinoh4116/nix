{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  cairo,
  wayland,
  wayland-protocols,
}:
rustPlatform.buildRustPackage rec {
  pname = "piri";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "Asthestarsfalll";
    repo = "piri";
    rev = "v${version}";
    hash = "sha256-6upezc11AGF/aoj+cBtscpIUEdWho58jybKxuz9BjDs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  cargoPatches = [
    ./Cargo.lock.patch
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    cairo
    wayland
    wayland-protocols
  ];

  postInstall = ''
    install -Dm644 config.example.toml $out/share/piri/config.example.toml

    installShellCompletion --cmd piri \
      --bash <($out/bin/piri completion bash) \
      --fish <($out/bin/piri completion fish) \
      --zsh <($out/bin/piri completion zsh)
  '';

  meta = with lib; {
    description = "High-performance Niri extension tool with a state-driven plugin system";
    homepage = "https://github.com/Asthestarsfalll/piri";
    changelog = "https://github.com/Asthestarsfalll/piri/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "piri";
    platforms = platforms.linux;
    maintainers = [];
  };
}
