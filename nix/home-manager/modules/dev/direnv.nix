{ config, pkgs, ... }:

{
  home.sessionVariables = {
    DIRENV_LOG_FORMAT="";
  };

  # === ENVIRONMENT MANAGEMENT ===
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    stdlib = ''
      # === PYTHON LAYOUTS ===
      layout_poetry() {
        PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
        if [[ ! -f "$PYPROJECT_TOML" ]]; then
            log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
            poetry init
        fi

        if [[ -d ".venv" ]]; then
            VIRTUAL_ENV="$(pwd)/.venv"
        else
            VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)
        fi

        if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
            log_status "No virtual environment exists. Executing \`poetry install\` to create one."
            poetry install
            VIRTUAL_ENV=$(poetry env info --path)
        fi

        PATH_add "$VIRTUAL_ENV/bin"
        export POETRY_ACTIVE=1
        export VIRTUAL_ENV
      }

      # === RUST LAYOUTS ===
      layout_rust() {
        if [[ -f "Cargo.toml" ]]; then
            log_status "Rust project detected. Setting up cargo environment."
            export CARGO_HOME="$PWD/.cargo"
            PATH_add "$CARGO_HOME/bin"

            # Auto-install common tools if not present
            if ! command -v cargo-watch >/dev/null 2>&1; then
                log_status "Installing cargo-watch..."
                cargo install cargo-watch
            fi
        else
            log_error "No Cargo.toml found. This doesn't appear to be a Rust project."
        fi
      }

      # === GO LAYOUTS ===
      layout_go() {
        if [[ -f "go.mod" ]]; then
            log_status "Go project detected. Setting up Go environment."
            export GOPATH="$PWD/.go"
            export GOCACHE="$PWD/.go/cache"
            PATH_add "$GOPATH/bin"

            # Auto-install common tools
            if ! command -v air >/dev/null 2>&1; then
                log_status "Installing air (live reload tool)..."
                go install github.com/cosmtrek/air@latest
            fi
        else
            log_error "No go.mod found. This doesn't appear to be a Go project."
        fi
      }

      # === NODE.JS LAYOUTS ===
      layout_node() {
        if [[ -f "package.json" ]]; then
            log_status "Node.js project detected. Setting up npm/yarn environment."

            # Check for yarn.lock or package-lock.json to determine package manager
            if [[ -f "yarn.lock" ]]; then
                log_status "Using Yarn as package manager."
                export YARN_CACHE_FOLDER="$PWD/.yarn-cache"
                if [[ ! -d "node_modules" ]]; then
                    log_status "Installing dependencies with yarn..."
                    yarn install
                fi
            else
                log_status "Using npm as package manager."
                if [[ ! -d "node_modules" ]]; then
                    log_status "Installing dependencies with npm..."
                    npm install
                fi
            fi

            PATH_add "$PWD/node_modules/.bin"
        else
            log_error "No package.json found. This doesn't appear to be a Node.js project."
        fi
      }

      # === MULTI-LANGUAGE LAYOUTS ===
      layout_fullstack() {
        log_status "Setting up fullstack development environment..."

        # Python backend
        if [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]]; then
            layout_poetry
        fi

        # Node.js frontend
        if [[ -f "package.json" ]]; then
            layout_node
        fi

        # Database
        if [[ -f "docker-compose.yml" ]]; then
            log_status "Docker Compose detected. Starting services..."
            docker-compose up -d
        fi
      }

      layout_microservices() {
        log_status "Setting up microservices development environment..."

        # Check for multiple service directories
        for service in services/*/; do
            if [[ -d "$service" ]]; then
                log_status "Found service: $service"
                pushd "$service" >/dev/null

                if [[ -f "pyproject.toml" ]]; then
                    layout_poetry
                elif [[ -f "package.json" ]]; then
                    layout_node
                elif [[ -f "Cargo.toml" ]]; then
                    layout_rust
                fi

                popd >/dev/null
            fi
        done

        # Start shared services
        if [[ -f "docker-compose.yml" ]]; then
            log_status "Starting shared services..."
            docker-compose up -d
        fi
      }

      # === UTILITY FUNCTIONS ===
      layout_cleanup() {
        log_status "Cleaning up development environment..."

        # Stop Docker services
        if [[ -f "docker-compose.yml" ]]; then
            docker-compose down
        fi

        # Clear caches
        if [[ -d ".go" ]]; then
            rm -rf .go/cache
        fi

        if [[ -d ".yarn-cache" ]]; then
            rm -rf .yarn-cache
        fi
      }
    '';
  };
}
