# dotfiles
My collection of dot files

## Install

### Dependencies

Download and install fira mono https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip
Download and install github https://cli.github.com

```zsh
# gnupg
brew install gpg

# git
brew install git

# oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# pygmentize
brew install pygments

# plugins
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# ag for vim
brew install ag

# fzf
brew install fzf
$(brew --prefix)/opt/fzf/install

# asdf vm
brew install asdf
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
```

### Setup

Create access token https://github.com/settings/tokens

```zsh
git clone git@github.com:hezbymuhammad/dotfiles.git
cd dotfiles
mkdir ${ZSH_CUSTOM}/plugins/hezbysecret
echo -e "export HOMEBREW_GITHUB_API_TOKEN=(access token)" >> ${ZSH_CUSTOM}/plugins/hezbysecret/hezbysecret.plugin.zsh

ln -nfs $(pwd)/.zshrc ~/.zshrc
ln -nfs $(pwd)/.zsh_aliases ~/.zsh_aliases
ln -nfs $(pwd)/.gitconfig ~/.gitconfig
ln -nfs $(pwd)/.gitignore ~/.gitignore
```
