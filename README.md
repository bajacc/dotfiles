# bajac's dotfiles

### deploy the dotfiles

```console
cd dotfiles
stow . -t $HOME
```

### find broken links

```console
find $HOME -xtype l -exec ls -l {} \;
```

### delete broken links

```console
find $HOME -xtype l -delete
```