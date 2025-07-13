{ config, pkgs, ... }@args:

let
  gitUser = args.gitUser;
  gitEmail = args.gitEmail;
in {
  home.packages = with pkgs; [
    delta
    lazygit
  ];

  programs.git = {
    enable = true;
    userName = gitUser;
    userEmail = gitEmail;
  };

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
    lg = "lazygit";
  };

  programs.git.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "TwoDark";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.showIcons = true;
      confirmOnQuit = true;
      keybinding = {
        universal.quit = "q";
        universal.return = "<esc>";
        commits.viewResetOptions = "R";
        stash.open = "s";
      };
    };
  };
}
