# === STARSHIP PROMPT ===
{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = ''
        $os$username$hostname$directory$git_branch$git_status$status$character'';

      add_newline = false;

      directory = {
        style = "bold blue";
        truncation_length = 5;
      };

      os = {
        disabled = false;
        format = "[$symbol](dimmed white)";
        style = "dimmed white";
      };

      username = {
        disabled = false;
        format = "[$user](dimmed white)";
        style_user = "dimmed white";
        show_always = false;
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname](dimmed white) ";
        disabled = false;
        trim_at = ".";
        style = "dimmed white";
      };

      status = {
        disabled = false;
        format = " [✘ $status](red)";
      };
    };
  };
}
