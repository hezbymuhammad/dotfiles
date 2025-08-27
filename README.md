# dotfiles

My collection of dot files

## Install

### Dependencies

Download and install fira mono https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip
Download and install github https://cli.github.com

```zsh
# terminal
brew install kitty

# nvim
brew install nvim

# gnupg
brew install gpg

# git
brew install git

# starship
curl -sS https://starship.rs/install.sh | sh

# pygmentize
brew install pygments

# ag for vim
brew install ag

# ripgrep
brew install ripgrep

# zsh autosuggestion
brew install zsh-autosuggestions

# zsh syntax highlight
brew install zsh-syntax-highlighting

# fzf
brew install fzf
$(brew --prefix)/opt/fzf/install

# tree better ls
brew install tree

# bat better cat
brew install bat

# zsh completion
brew install zsh-completions
chmod go-w /usr/local/share
chmod go-w $HOMEBREW_PREFIX/share
chmod -R go-w $HOMEBREW_PREFIX/share/zsh
rm -f ~/.zcompdump

# asdf vm
brew install asdf
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
asdf install golang latest
asdf global golang latest
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby latest
asdf global ruby latest
asdf install python latest
asdf global python latest
asdf install rust nightly
asdf global rust nightly

# LSP & formatter
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/nametake/golangci-lint-langserver@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
asdf reshim golang
brew install gping
brew install gitui
brew install gh
brew install golangci-lint
brew install deno
brew install marksman
brew install hashicorp/tap/terraform-ls
brew install gnu-sed
brew install ripgrep
brew install fd
brew install marksman
brew install bitwarden-cli
brew install prettierd
brew install jq
brew install tree-sitter
brew install tree-sitter-cli
brew install stylua
brew install lua-language-server
brew install uv
brew install codex
gem install -g ruby-lsp
uv tool install mcp-server-fetch
uv tool install basic-memory
uv tool install "vectorcode[legacy,mcp]" # for intel mbp
uv tool install "vectorcode[mcp]"

# need to install all of these in each node version and reshim
npm i -g yaml-language-server
npm i -g eslint_d
npm i -g typescript-language-server
npm i -g bash-language-server
npm i -g typescript
npm i -g vscode-langservers-extracted
npm i -g @upstash/context7-mcp
npm i -g @modelcontextprotocol/server-sequential-thinking
npm i -g mcp-hub@latest
```

### Setup

Create access token https://github.com/settings/tokens, then update `env.sh`

Before create symlink, ensure no existing dir

```zsh
git clone git@github.com:hezbymuhammad/dotfiles.git
cd dotfiles
cp env.sh.example env.sh

ln -nfs $(pwd)/better-git-branch.sh ~/bin/better-git-branch.sh
ln -nfs $(pwd)/.gitmessage ~/.gitmessage
ln -nfs $(pwd)/env.sh ~/env.sh
ln -nfs $(pwd)/.zshrc ~/.zshrc
ln -nfs $(pwd)/.zsh_aliases ~/.zsh_aliases
ln -nfs $(pwd)/.config/starship.toml ~/.config/starship.toml
ln -nfs $(pwd)/.gitconfig ~/.gitconfig
ln -nfs $(pwd)/.gitignore ~/.gitignore
ln -nfs $(pwd)/.tmux.conf ~/.tmux.conf
ln -nfs $(pwd)/.config/nvim ~/.config/nvim
ln -nfs $(pwd)/.config/kitty ~/.config/kitty
ln -nfs $(pwd)/.config/gitui ~/.config/gitui
ln -nfs $(pwd)/.config/mcphub ~/.config/mcphub
ln -nfs $(pwd)/.config/vectorcode ~/.config/vectorcode
ln -nfs $(pwd)/.codex/config.toml ~/.codex/config.toml
ln -nfs $(pwd)/.codex/AGENTS.md ~/.codex/AGENTS.md
ln -nfs $(pwd)/.basic-memory/config.json ~/.basic-memory/config.json
```

\*use vectorcode reranker Qwen/Qwen3-Embedding-0.6B for vector code for apple arm
