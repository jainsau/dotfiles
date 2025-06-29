# === HOME MANAGER MODULES AGGREGATOR ===
{ config, pkgs, lib, ... }@args:

{
  imports = [
    # CLI tools
    ./cli/eza.nix
    ./cli/fd.nix
    ./cli/ripgrep.nix
    ./cli/jq.nix
    ./cli/yq.nix
    ./cli/htop.nix
    ./cli/tree.nix
    ./cli/pstree.nix
    ./cli/dust.nix
    ./cli/duf.nix
    ./cli/procs.nix
    ./cli/bottom.nix
    ./cli/tealdeer.nix
    ./cli/hyperfine.nix
    ./cli/tokei.nix
    ./cli/fzf.nix
    ./cli/zoxide.nix
    ./cli/bat.nix
    # ./cli/opencode.nix  # TODO: Uncomment when package definition is working

    # Development tools
    ./dev/git.nix
    ./dev/direnv.nix
    ./dev/lazygit.nix
    ./dev/delta.nix
    ./dev/gh.nix
    ./dev/glab.nix
    ./dev/just.nix
    ./dev/watchexec.nix
    ./dev/entr.nix
    ./dev/stow.nix
    ./dev/nil.nix
    ./dev/glow.nix
    ./dev/slides.nix
    ./dev/sd.nix
    ./dev/choose.nix
    ./dev/miller.nix
    ./dev/htmlq.nix
    ./dev/gron.nix
    ./dev/nodejs.nix
    ./dev/markdownlint.nix
    ./dev/go.nix
    ./dev/rustc.nix
    ./dev/cargo.nix
    ./dev/aliases.nix
    ./dev/bun.nix
    # ./dev/gemini.nix  # TODO: Enable when moving from Homebrew to home-manager

    # Fonts
    ./fonts.nix

    # Fun utilities
    ./fun/fortune.nix
    ./fun/cowsay.nix
    ./fun/lolcat.nix
    ./fun/figlet.nix
    ./fun/wisdom-alias.nix

    # System/network tools
    ./system/nmap.nix
    ./system/bandwhich.nix
    ./system/iftop.nix
    ./system/lsof.nix
    ./system/ncdu.nix
    ./system/neofetch.nix
    ./system/macchina.nix
    ./system/podman.nix

    # Shell/zsh
    ./shell/zsh.nix
    ./shell/tmux.nix
  ];
}

