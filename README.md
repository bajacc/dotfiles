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

### find broken links

```console
find $HOME -xtype l -exec ls -l {} \;
```

### delete broken links

```console
find $HOME -xtype l -delete
```