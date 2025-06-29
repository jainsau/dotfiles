# === LAZYGIT MODULE ===
{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui.showIcons = true;
      confirmOnQuit = true; # Prevent accidental quits
      keybinding = {
        universal.quit = "q"; # Quit with 'q'
        universal.return = "<esc>"; # Escape to go back
        commits.viewResetOptions = "R"; # Reset menu with 'R'
        stash.open = "s"; # Open stash menu with 's'
      };
    };
  };
  home.shellAliases.lg = "lazygit";
} 