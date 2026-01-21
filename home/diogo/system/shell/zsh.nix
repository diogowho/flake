{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      source <(fzf --zsh)
      echo -e "\e[35m"
      cat <<'EOF'
        ╱|、
       (˚ˎ。7
       |、˜〵
       じしˍ,)ノ
      EOF
      echo -e "\e[0m"
    '';

    envExtra = ''
      ${
        if pkgs.stdenv.hostPlatform.isDarwin then
          "export SSH_AUTH_SOCK=~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
        else
          ""
      }
    '';
  };
}
