eval "$(starship init zsh)"

export TERM="tmux-256color"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$HOME/.docker/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
export ZSH_COLORIZE_STYLE="monokai"
source $HOME/.zsh_aliases
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
