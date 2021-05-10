# Winbox on Wine
A Winbox installer for Wine. Written in dash/POSIX-compliant shell.

### Installation

Dependencies:
- `coreutils`: basic tasks
- `wine`: run winbox
- `wget/curl`: downloading winbox executables

Default installation path:
- winbox: `$HOME\.local\bin`
- desktop entry: `$HOME\.local\share\applications`.

Simply install by running:

    ./winbox.sh --install

You can override installed winbox ABI by defining `arch` variable, available options are `32` (x86) or `64` (x86_64):

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
    wine$arch ~/.local/bin/winbox$arch

### Uninstalling
This is not uninstalling completely though, all winbox session is keep untouched.

    ./winbox.sh --uninstall

or, manually:

    rm -f ~/.local/bin/winbox{32,64}
    rm -f ~/.local/share/applications/winbox{32,64}.desktop
