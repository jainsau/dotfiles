{ config, pkgs, lib, ... }@args:

with lib;
{
  options.tools = {
    enableKubernetes = mkEnableOption "Kubernetes tools (kubectl, k9s)";
    enableNetworkTools = mkEnableOption "Network diagnostic tools (nmap, mtr, trippy, etc.)";
    enableMonitoring = mkEnableOption "System monitoring tools (lsof, ncdu, podman)";
    enableTmux = mkEnableOption "Tmux terminal multiplexer";
    enableGit = mkEnableOption "Git ecosystem (git, delta, lazygit, gpg)";
  };

  config.tools = {
    enableKubernetes = mkDefault true;
    enableNetworkTools = mkDefault true;
    enableMonitoring = mkDefault true;
    enableTmux = mkDefault true;
    enableGit = mkDefault true;
  };

  imports = [
    ./cli/tools.nix
    ./cli/fzf.nix
    ./cli/git.nix
    ./cli/kubernetes.nix
    ./dev/tools.nix
    ./dev/direnv.nix
    ./system/monitoring.nix
    ./system/network.nix
    ./system/podman.nix
    ./shell/zsh.nix
    ./shell/starship.nix
    ./shell/keybindings.nix
    ./shell/functions.nix
    ./shell/tmux.nix
  ];
}
