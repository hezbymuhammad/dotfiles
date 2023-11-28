export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(ag asdf colorize git gnu-utils zsh-history-substring-search zsh-syntax-highlighting zsh-autosuggestions)
autoload -U compinit && compinit
source $ZSH/oh-my-zsh.sh
export TERM="xterm-256color"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export HOMEBREW_GITHUB_API_TOKEN=
export PATH="$HOME/.docker/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
export ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
export ZSH_COLORIZE_STYLE="monokai"
source $HOME/.zsh_aliases
