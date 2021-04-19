# Winbox get Wine
A Winbox installer for Wine. Written in dash shell.

### Installation
To install, run:

    ./winbox.sh

You can override the arch by defining the `arch` variable, available options are `32` (x86) or `64` (x86_64):

    arch=32 ./winbox.sh
    
### Usage

To open winbox, you can search "Winbox" on Applications Browser, or just manually run:

    wine ~/.local/bin/winbox$arch # use your previously defined $arch

### Uninstalling
Manually remove the installed files:

    rm -f ~/.local/bin/winbox{32,64}
    rm -f ~/.local/share/applications/winbox{32,64}.desktop

### Dependencies:
- `wine`: to run winbox
- `wget/curl`: downloading winbox binary
