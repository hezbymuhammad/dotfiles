# dotfiles

My collection of dot files

## Install

### Dependencies

Download and install fira mono https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip
Download and install github https://cli.github.com

```zsh
# terminal
brew install kitty

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

# zsh completion
brew install zsh-completions
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
asdf install ruby latest
asdf global ruby latest
asdf install python latest
asdf global python latest

# LSP & formatter
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/nametake/golangci-lint-langserver@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
asdf reshim golang
brew install gh
brew install golangci-lint
brew install deno
brew install fsouza/prettierd/prettierd
brew install marksman
brew install hashicorp/tap/terraform-ls
brew install gnu-sed
brew install ripgrep
brew install fd
brew install marksman
pip install setuptools

# need to install all of these in each node version and reshim
npm i -g vscode-langservers-extracted
npm i -g yaml-language-server
npm i -g eslint_d
npm i -g typescript-language-server
npm i -g bash-language-server
```

### Setup

Create access token https://github.com/settings/tokens, then update `env.sh`

```zsh
git clone git@github.com:hezbymuhammad/dotfiles.git
cd dotfiles
cp env.sh.example env.sh

ln -nfs $(pwd)/env.sh ~/env.sh
ln -nfs $(pwd)/.zshrc ~/.zshrc
ln -nfs $(pwd)/.zsh_aliases ~/.zsh_aliases
ln -nfs $(pwd)/.config/starship.toml ~/.config/starship.toml
ln -nfs $(pwd)/.gitconfig ~/.gitconfig
ln -nfs $(pwd)/.gitignore ~/.gitignore
ln -nfs $(pwd)/.tmux.conf ~/.tmux.conf
ln -nfs $(pwd)/.config/starship.toml ~/.config/starship.toml
ln -nfs $(pwd)/.config/nvim ~/.config/nvim
```
