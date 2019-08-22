# dotfiles
My collection of dot files

## Tools
- ubuntu
- terminator
- zsh
- vim
- tmux ( >= 2.3)
- rvm + ruby

## Oh My ZSH
```bash
cd
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Powerline Font
```bash
cd
git clone https://github.com/powerline/fonts.git --depth=1
./fonts/install.sh
rm -rf fonts
```

after that change font in terminal to any of powerline font

##### Silver Searcher
Ag is faster than ack

```bash
sudo apt-get install silversearcher-ag # ubuntu
brew install the_silver_searcher # macos
```

#### Deoplete
vim has to support python3

```bash
:echo has("python3")
```

##### Fuzzy Finder
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

##### Docker Machine Completion
```
git clone https://github.com/leonhartX/docker-machine-zsh-completion.git ~/.oh-my-zsh/custom/plugins/docker-machine
```

#### ASDF Version Manager
```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.1
```
