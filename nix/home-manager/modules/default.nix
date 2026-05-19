{ config, pkgs, lib, ... }@args:

with lib;
{
  options.tools = {
    enableKubernetes = mkEnableOption "Kubernetes tools (kubectl, k9s)";
    enableNetworkTools = mkEnableOption "Network diagnostic tools (nmap, mtr, trippy, etc.)";
    enableMonitoring = mkEnableOption "System monitoring tools (lsof, ncdu, podman)";
    enableCLIProxy = mkEnableOption "CLI Proxy API Plus (via Podman)";
    enableTmux = mkEnableOption "Tmux terminal multiplexer";
    enableGit = mkEnableOption "Git ecosystem (git, delta, lazygit, gpg)";
    enableAiTools = mkEnableOption "AI tools (kiro-cli, claude-code, gemini-cli, openspec, pi)";
  };

  config.tools = {
    enableKubernetes = mkDefault true;
    enableNetworkTools = mkDefault true;
    enableMonitoring = mkDefault true;
    enableCLIProxy = mkDefault true;
    enableTmux = mkDefault true;
    enableGit = mkDefault true;
    enableAiTools = mkDefault true;
  };

  imports = [
    ./cli/tools.nix
    ./cli/ai.nix
    ./cli/fzf.nix
    ./cli/git.nix
    ./cli/kubernetes.nix
    ./dev/tools.nix
    ./dev/direnv.nix
    ./system/monitoring.nix
    ./system/network.nix
    ./system/podman.nix
    ./system/cliproxy.nix
    ./shell/zsh.nix
    ./shell/starship.nix
    ./shell/keybindings.nix
    ./shell/functions.nix
    ./shell/tmux.nix
  ];
}
