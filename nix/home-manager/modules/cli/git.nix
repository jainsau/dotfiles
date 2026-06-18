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
      settings = {
        diff.tool = "nvimdiff";
        merge.tool = "nvimdiff";
        difftool.prompt = false;
        init.defaultBranch = "main";
        user = {
          name = gitUser;
          email = gitEmail;
        };
      };
      signing = {
        format = "openpgp";
        signByDefault = true;
        key = gpgKey;
      };
    };

    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
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

    programs.zsh.initContent = ''
      typeset -gA shell_command_descriptions
      shell_command_descriptions[g]="Git"
      shell_command_descriptions[ga]="Stage files"
      shell_command_descriptions[gc]="Commit with message"
      shell_command_descriptions[gs]="Show worktree status"
      shell_command_descriptions[gl]="Compact decorated log graph"
      shell_command_descriptions[gd]="Show unstaged diff"
      shell_command_descriptions[gco]="Checkout branch or path"
      shell_command_descriptions[gb]="List or manage branches"
      shell_command_descriptions[gp]="Push current branch"
      shell_command_descriptions[gpl]="Pull current branch"
      shell_command_descriptions[lg]="Open lazygit"
    '';

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
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --side-by-side --line-numbers --paging=never";
        };
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
