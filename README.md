# Winbox on Wine
A Winbox installer for Wine. Written in dash/POSIX-compliant shell.

### Installation

Dependencies:
- `coreutils`: basic tasks
- `wine`: run winbox
- `wget/curl`: downloading winbox executables

Default installation path:
- winbox: `$HOME\.local\bin`
- desktop entry: `$HOME\.local\share\applications`

First, it check for wine installation, then download necessary winbox executables from mikrotik official site at https://mt.lv. Next, it install winbox and proper desktop entry to default path. Simply install by running:

    ./winbox.sh --install

You can override installed winbox ABI by defining `arch` variable, available options are `32` for x86 and `64` for x86_64:

    arch=32 ./winbox.sh --install
    
### How-to
```
Usage: winbox.sh [option]
Options:
  -h, --help         Show this help message.
  -i, --install      Install winbox.
  -k, --check        Check wine and winbox installation.
  -n, --uninstall    Uninstall winbox.
  -u, --upgrade      Upgrade winbox.
```

To open winbox, you can search "Winbox" on Applications Browser, or just manually run:

    # replace $arch with your system one
    wine$arch ~/.local/bin/winbox{,64}

### Uninstalling
This is not a completely removal though, all winbox session is keep untouched.

    ./winbox.sh --uninstall

or, manually:

    rm -fv ~/.local/bin/winbox{,64}
    rm -fv ~/.local/share/applications/winbox{,64}.desktop
