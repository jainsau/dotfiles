# === GIT MODULE ===
{ config, pkgs, ... }@args:

let
  gitUser = args.gitUser;
  gitEmail = args.gitEmail;
in {
  # === GIT CONFIGURATION ===
  programs.git = {
    enable = true;
    userName = gitUser;
    userEmail = gitEmail;
  };

  # === GIT SHORTCUTS ===
  home.shellAliases = {
    g = "git";
    ga = "git add";
    gc = "git commit -m";
    gs = "git status";
    gl = "git log --oneline --graph --decorate";
    gd = "git diff";
    gco = "git checkout";
    gb = "git branch";
    gp = "git push";
    gpl = "git pull";
  };
}
