{ config, ... }:

{
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    stdlib = ''
      # Lean project layouts: set environment and PATH only.
      # These helpers intentionally do not install packages or start services.

      layout_poetry() {
        local pyproject="''${PYPROJECT_TOML:-pyproject.toml}"
        if [[ ! -f "$pyproject" ]]; then
          log_error "No $pyproject found."
          return 1
        fi

        local venv
        if [[ -d ".venv" ]]; then
          venv="$PWD/.venv"
        else
          venv=$(poetry env info --path 2>/dev/null || true)
        fi

        if [[ -z "$venv" || ! -d "$venv" ]]; then
          log_error "No Poetry environment found. Run: poetry install"
          return 1
        fi

        PATH_add "$venv/bin"
        export POETRY_ACTIVE=1
        export VIRTUAL_ENV="$venv"
      }

      layout_rust() {
        if [[ ! -f "Cargo.toml" ]]; then
          log_error "No Cargo.toml found."
          return 1
        fi

        export CARGO_HOME="$PWD/.cargo"
        PATH_add "$CARGO_HOME/bin"
      }

      layout_go() {
        if [[ ! -f "go.mod" ]]; then
          log_error "No go.mod found."
          return 1
        fi

        export GOPATH="$PWD/.go"
        export GOCACHE="$PWD/.go/cache"
        PATH_add "$GOPATH/bin"
      }

      layout_node() {
        if [[ ! -f "package.json" ]]; then
          log_error "No package.json found."
          return 1
        fi

        PATH_add "$PWD/node_modules/.bin"
      }

    '';
  };
}
