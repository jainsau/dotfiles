# === CUSTOM SHELL FUNCTIONS ===
{ ... }:
{
  programs.zsh.initContent = ''
    # pay-respects: press f to fix last command
    eval "$(pay-respects zsh --alias f)"

    # Cheat sheet lookup
    cs() {
      curl "https://cheat.sh/$1"
    }
  '';
}
