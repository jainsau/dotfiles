{ config, pkgs, ... }:

# default Python setup
{
  home.packages = with pkgs; [
    python312
    python312Packages.virtualenv
    pyright
    black
    isort
    ruff
  ];

  home.sessionVariables = {
    POETRY_CONFIG_DIR = "${config.xdg.configHome}/pypoetry";
    PYTHONBREAKPOINT = "ipdb.set_trace";
  };

  # Poetry
  programs.poetry = {
    enable = true;
  };

  home.file.".config/pypoetry/config.toml".text = ''
    [virtualenvs]
    in-project = true
    prefer-active = true
  '';
}
