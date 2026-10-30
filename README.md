# bajac's dotfiles

### deploy the dotfiles on arch

```console
cd dotfiles
stow --no-folding arch -t $HOME
```

### deploy the dotfiles on mac

```console
cd dotfiles
stow --no-folding mac -t $HOME
```

### deploy the dotfiles on debian

```console
cd dotfiles
stow --no-folding debian -t $HOME
```

### install and set up zsh

Install `zsh` and its dependencies (`git`, `curl`, `fzf`, `stow`, `neovim`, `bat`), then set it as your login shell.

**arch:**

```console
sudo pacman -S zsh git curl fzf stow neovim bat
chsh -s $(which zsh)
```

**debian:**

```console
sudo apt install zsh git curl fzf stow neovim bat
chsh -s $(which zsh)
```

**mac:**

zsh is already the default login shell, so only the dependencies are needed.

```console
brew install git curl fzf stow neovim bat
```

Log out and back in (or open a new terminal) to pick up the shell change, then deploy the dotfiles for your platform (see above). On the first launch, `.zshrc` will automatically clone [zinit](https://github.com/zdharma-continuum/zinit) and its plugins — this only happens once.

If you're using powerlevel10k (mac), install a [Nerd Font](https://www.nerdfonts.com/) and set it as your terminal's font so prompt icons render correctly, then run `p10k configure` to customize the prompt.

### find broken links

```console
find $HOME -xtype l -exec ls -l {} \;
```

### delete broken links

```console
find $HOME -xtype l -delete
```