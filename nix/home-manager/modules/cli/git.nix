# === GIT ECOSYSTEM ===
{ config, pkgs, lib, ... }@args:

let
  gitUser = args.gitUser;
  gitEmail = args.gitEmail;
  gpgKey = args.gpgKey;
in
with lib;
{
  config = mkIf config.tools.enableGit {
    home.packages = with pkgs; [
      lazygit
    ];

    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      maxCacheTtl = 7200;
      pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
    };

    programs.git = {
      enable = true;
      settings.user = {
        name = gitUser;
        email = gitEmail;
      };
      extraConfig = {
        diff.tool = "nvimdiff";
        merge.tool = "nvimdiff";
        difftool.prompt = false;
      };
      signing = {
        format = "openpgp";
        signByDefault = true;
        key = gpgKey;
      };
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

    programs.delta = {
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
  };
}
