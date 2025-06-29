{ ... }:
{
  home.shellAliases = {
    serve = "python3 -m http.server";
    myip = "curl -s https://httpbin.org/ip | jq -r .origin";
    vim = "nvim";
    ll = "eza -l --git";
    l = "eza -l";
    la = "eza -la";
    dfh = "df -h";
    duhs = "du -hs";
  };
} 
