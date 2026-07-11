{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "762afacbf227ecd173e899d10a28a478b4c84a3f";
          sha256 = "1357hygrjwj5vd4cjdvxzrx967f1d2dbqm2rskbz5z1q6jri1hm3";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "z" ];
      extraConfig = ''
        # Required for autocomplete with box: https://unix.stackexchange.com/a/778868
        zstyle ':completion:*' completer _expand _complete _ignored _approximate _expand_alias
        zstyle ':autocomplete:*' default-context curcontext
        zstyle ':autocomplete:*' min-input 0

        setopt HIST_FIND_NO_DUPS
        setopt autocd
        setopt globdots
      '';
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;

    initContent = ''
      fastfetch -l small
      eval "$(starship init zsh)"
      bindkey -M menuselect '^M' .accept-line
    '';
  };
}