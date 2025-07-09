shell mkdir -p $XDG_DATA_HOME/gdb
set history filename ~/.local/share/gdb/gdb/history
set history save on
set history size 3000

shell if [ ! -f "$XDG_DATA_HOME/gdb/gdbinit-gef.py" ]; then \
    echo "Downloading GEF for GDB..."; \
    wget -O $XDG_DATA_HOME/gdb/gdbinit-gef.py -q https://gef.blah.cat/py; \
    echo "Download complete."; \
fi

source ~/.local/share/gdb/gdbinit-gef.py