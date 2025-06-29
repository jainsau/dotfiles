{ config, pkgs, lib, ... }:

let
  ollamaModels = [
    "llama3.2:3b"
    "mistral:7b"
    "gemma2:2b"
  ];

  pullScript = pkgs.writeShellScript "ollama-model-puller" ''
    set -euo pipefail
    export PATH="/opt/homebrew/bin:$PATH"

    # Wait for Ollama to be ready
    echo "Waiting for Ollama service..."
    for i in {1..30}; do
      if curl -s http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
        break
      fi
      sleep 2
    done

    # Pull models
    for model in ${lib.concatStringsSep " " (map lib.escapeShellArg ollamaModels)}; do
      echo "Pulling $model..."
      ollama pull "$model"
    done

    echo "Done! Models available:"
    ollama list
  '';
in

{
  # Install Ollama via Homebrew
  homebrew.brews = [ "ollama" ];

  # Ollama service
  launchd.user.agents.ollama-service = {
    serviceConfig = {
      ProgramArguments = [ "/opt/homebrew/bin/ollama" "serve" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/ollama.log";
      StandardErrorPath = "/tmp/ollama.log";
    };
  };

  # Pull models after service starts
  launchd.user.agents.ollama-pull-models = {
    serviceConfig = {
      ProgramArguments = [ "${pullScript}" ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/tmp/ollama-pull.log";
      StandardErrorPath = "/tmp/ollama-pull.log";
    };
  };
}
