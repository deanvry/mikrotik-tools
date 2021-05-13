#!/bin/sh

btestBinSrc="https://mt.lv/btest";
btestTargetInstallDir="$HOME/.local/bin";
btestTargetDesktopEntryDir="$HOME/.local/share/applications";

helpMe() {
printf "Usage: btest.sh [option]
Options:
  -h, --help         Show this help message.
  -i, --install      Install btest.
  -k, --check        Check wine and btest installation.
  -n, --uninstall    Uninstall btest.
  -u, --upgrade      Upgrade btest.";
}

chkWine() {
printf ">> Checking wine installation.. ";
if command -v wine64 > /dev/null || command -v wine32; then
    printf "found\n";
else
    printf "error\n!! Wine is not installed, aborting.."; exit 1;
fi
}

chkBtestInstall() {
printf ">> Checking btest installation.. ";
if [ -f "$btestTargetInstallDir/btest" ]; then
    printf "btest: found";
    if [ -f "$btestTargetDesktopEntryDir/btest.desktop" ]; then
        printf ", desktop entry: found\n";
    else
        printf "\n!! Desktop Entry for btest: not found"; return 2;
    fi
else
    printf "error\n!! Installaton for btest: not found";
    printf "\n!! Desktop Entry for btest: not found";
    exit 2;
fi
}

chkSrc() {
if [ -f btest ]; then
    printf ">> Btest is already downloaded\n";
else
    printf ">> Downloading btest from $btestBinSrc.. ";
    if command -v wget > /dev/null; then
        wget -cq "$btestBinSrc" && printf "done\n";
    elif command -v curl > /dev/null; then
        curl -Os -C - "$btestBinSrc" && printf "done\n";
    else
        printf "!! Neither wget or curl is not installed, can't download btest"; exit 1;
    fi
fi
}

installDesktopEntry() {
entry="
[Desktop Entry]
Name=Bandwidth Test
Exec=wine32 $btestTargetInstallDir
Type=Application
Version=1.0
Comment=Mikrotik's Bandwidth Test Utility
Terminal=false
Categories=Utility;Network
StartupWMClass=Winbox"
printf "$entry" > "btest.desktop";
}

installBtest() {
printf ">> Installing btest.. ";
install -Dm 740 "btest" "$btestTargetInstallDir/btest" && printf "done\n";
printf ">> Installing desktop entry.. ";
install -Dm 640 "btest" "$btestTargetDesktopEntryDir/btest.desktop" && printf "done\n";
printf ">> Installaton finished\n";
}

uninstallBtest() {
printf ">> Uninstalling btest.. ";
rm -f "$btestTargetInstallDir/btest";
rm -f "$btestTargetDesktopEntryDir/btest.desktop";
printf "done\n";
}

case $1 in
    -h|--help|'') helpMe;;
    -i|--install) chkWine; chkSrc; installDesktopEntry; installBtest;;
    -k|--check) chkWine; chkBtestInstall;;
    -n|--uninstall) uninstallBtest;;
    -u|--upgrade) rm btest; chkSrc; installBtest;;
    *) printf "$0: invalid option -- '$1'\nTry '$0' --help for more information.";;
esac;
