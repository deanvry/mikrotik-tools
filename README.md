# Mikrotik-Tools
A Winbox installer for linux. Written in dash/sh.

### Basic Usage
To install, run:

    ./winbox.sh

You can override the arch by defining the `arch` variable

    arch=32 ./winbox.sh

To open winbox, you can use `rofi/dmenu` and `gtk-launch winbox[32|64]` or just manually run:

    wine ~/.local/bin/winbox64 # or winbox32

### Dependencies:
- `wine`: running winbox
- `wget`: downloading winbox binary

### TODO
- NetInstall
- The Dude
