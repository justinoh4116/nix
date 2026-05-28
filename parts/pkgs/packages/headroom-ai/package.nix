{
  pkgs,
  lib,
  fetchFromGitHub,
  onnxruntime,
  rustPlatform,
  ...
}: let
  # python = pkgs.pure-unstable;
  python = pkgs;
in
  python.python3Packages.buildPythonPackage rec {
    pname = "headroom-ai";
    version = "0.22.3";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "chopratejas";
      repo = "headroom";
      rev = "v${version}";
      hash = "sha256-xTN4tO2wafk9zkQnSdXiWeKrCnefyFtNr2WM8s6/jTg=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-WQBvil0bsS6/Z6b+uRauwOQq4VZ57VwAoghcyFdVgLE=";
    };

    pythonRelaxDeps = [
      "litellm"
    ];

    pythonRemoveDeps = [
      "ast-grep-cli"
    ];

    nativeBuildInputs = with rustPlatform; [
      cargoSetupHook
      maturinBuildHook
    ];

    buildInputs = [
      onnxruntime
    ];

    env = {
      ORT_STRATEGY = "system";
      ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";
      ORT_PREFER_DYNAMIC_LINK = "true";
    };

    propagatedBuildInputs = with python.python3Packages; [
      tiktoken
      pydantic
      litellm
      click
      rich
      opentelemetry-api

      # proxy
      fastapi
      uvicorn
      httpx
      h2 # for http2 by httpx
      openai
      mcp
      magika
      zstandard
      websockets
      onnxruntime
      transformers

      # code
      tree-sitter-language-pack
    ];

    doCheck = false;

    meta = with python.lib; {
      description = "Context optimization layer for LLM applications";
      homepage = "https://github.com/chopratejas/headroom";
      license = licenses.asl20;
      mainProgram = "headroom";
      maintainers = [];
      platforms = platforms.linux;
    };
  }
