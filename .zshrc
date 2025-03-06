eval "$(starship init zsh)"
export WORDCHARS="*?[]~&!#$%^(){}<>"
. "$HOME/env.sh"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY
export EDITOR=/usr/local/bin/nvim
export TERM="tmux-256color"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/libpq/bin:$HOME/.docker/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
export ZSH_COLORIZE_STYLE="monokai"
source $HOME/.zsh_aliases
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
autoload -Uz compinit
compinit
