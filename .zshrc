eval "$(starship init zsh)"
export WORDCHARS="*?[]~&!#$%^(){}<>"
. "$HOME/env.sh"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
bindkey '^[^?' backward-kill-word
bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
export PATH="$HOME/bin:/usr/local/opt/libpq/bin:$HOME/.docker/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$HOME/.local/bin:$PATH"

setopt SHARE_HISTORY
export EDITOR=/usr/local/bin/nvim
export TERM="tmux-256color"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
export ZSH_COLORIZE_STYLE="monokai"
source $HOME/.zsh_aliases
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
autoload -Uz compinit
export TERM=screen-256color
compinit
