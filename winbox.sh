#!/bin/sh

if [ ! -n "$arch" ]; then
    arch=$(lscpu | awk '/Architecture/ {print $2}');
    if [ "$arch" = x86_64 ]; then
        arch=64;
    elif [ "$arch" = x86 ]; then
        arch="";
    fi
else
    if [ "$arch" = "64" ] || [ "$arch" = "32" ]; then
        printf ">> Explicitly using $arch-bit arch\n";
    else
	printf "!! Invalid arch: $arch-bit. Available options are: 32 or 64"; exit 1;
    fi
fi

winboxBinSrc="https://mt.lv/winbox$arch";
winboxTargetInstallDir="$HOME/.local/bin";
winboxTargetDesktopEntryDir="$HOME/.local/share/applications";

helpMe() {
printf "Usage: winbox.sh [option]
Options:
  -h, --help         Show this help message.
  -i, --install      Install winbox.
  -k, --check        Check wine and winbox installation.
  -n, --uninstall    Uninstall winbox.
  -u, --upgrade      Upgrade winbox.";
}

chkWine() {
printf ">> Checking wine installation.. ";
if command -v wine64 > /dev/null || command -v wine32 > /dev/null; then
    printf "found\n";
else
    printf "error\n!! Wine is not installed, aborting.."; exit 1;
fi
}

chkWinboxInstall() {
printf ">> Checking winbox$arch installation.. ";
if [ -f "$winboxTargetInstallDir/winbox$arch" ]; then
    printf "winbox: found";
    if [ -f "$winboxTargetDesktopEntryDir/winbox$arch.desktop" ]; then
        printf ", desktop entry: found\n";
    else
        printf "\n!! Desktop Entry for winbox$arch: not found"; return 2;
    fi
else
    printf "error\n!! Installaton for winbox$arch: not found";
    printf "\n!! Desktop Entry for winbox$arch: not found";
    return 2;
fi
}

chkSrc() {
if [ -f winbox"$arch" ]; then
    printf ">> Winbox$arch is already downloaded\n";
else
    printf ">> Downloading winbox$arch.. ";
    if command -v wget > /dev/null; then
	wget -cq "$winboxBinSrc" && printf "done\n";
    elif command -v curl > /dev/null; then
        curl -Os -C - "$winboxBinSrc" && printf "done\n";
    else
	printf "!! Neither wget or curl is not installed, can't download winbox"; exit 1;
    fi
fi
}

installDesktopEntry() {
entry="
Type=Application
Version=1.0
Comment=RouterOS Graphical Administration Tool
Terminal=false
Categories=Utility;Network
StartupWMClass=Winbox"
if [ "$arch" = 64 ]; then
    entry="[Desktop Entry]
Name=Winbox (64-bit)
Exec=wine64 $winboxTargetInstallDir/winbox64$entry";
else
    entry="[Desktop Entry]
Name=Winbox (32-bit)
Exec=wine32 $winboxTargetInstallDir/winbox$entry";
fi
printf "$entry" > "winbox$arch.desktop";
}

installWinbox() {
printf ">> Installing winbox$arch.. ";
install -Dm 740 "winbox$arch" "$winboxTargetInstallDir/winbox$arch" && printf "done\n";
printf ">> Installing desktop entry.. ";
install -Dm 640 "winbox$arch.desktop" "$winboxTargetDesktopEntryDir/winbox$arch.desktop" && printf "done\n";
printf ">> Installaton finished\n"
}

uninstallWinbox() {
printf ">> Uninstalling winbox$arch.. ";
rm -f "$winboxTargetInstallDir/winbox$arch";
rm -f "$winboxTargetDesktopEntryDir/winbox$arch.desktop";
printf "done\n";
}

case $1 in
    -h|--help|'') helpMe;;
    -i|--install) chkWine; chkSrc; installDesktopEntry; installWinbox;;
    -k|--check) chkWine; chkWinboxInstall;;
    -n|--uninstall) uninstallWinbox;;
    -u|--upgrade) rm winbox$arch; chkSrc; installWinbox;;
    *) printf "$0: invalid option -- '$1'\nTry '$0' --help for more information.";;
esac;
