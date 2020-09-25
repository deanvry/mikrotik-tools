#!/bin/dash
# A simple script to download and install winbox

chkWine () {
echo -n ">> Checking for wine$arch installation.. "
if wine64 --version; then
    return 0
elif wine32 --version; then
    return 0
else
    echo "\n!! Wine is not installed, aborting.. "
    exit 1
fi
}

chkSrc () {
if [ ! -f src/winbox"$arch" ]; then
    echo -n ">> Downloading Winbox$arch.. "
    if wget -c --progress=bar:force:noscroll https://mt.lv/winbox"$arch" -P src | tail -3; then
        echo "done"
    else
        echo failed..
        exit 1; fi
else
    echo "   > Winbox$arch is already downloaded"; fi

if [ -x "$winbox" ]; then
    echo "   > Winbox$arch is already installed"; fi
}

desktop_entry () {
sed -i "s,/home/.*/.local,/home/$USER/.local," src/winbox.desktop
if [ ! "$arch" = 64 ]; then
    sed 's/64-bit/32-bit/; s/wine64/wine/; s/winbox64/winbox32/' src/winbox.desktop > winbox32.desktop
else
    cp src/winbox.desktop src/winbox64.desktop
fi
}

install () {
while true; do
read -rp "?? Proceed to install? [y/n]: " ans
    case $ans in
        [Yy]*) break ;;
        [Nn]*) echo ">> Aborting.. "; exit 0 ;;
        *) echo ">> Please answer [y/n] only" ;; esac
done

echo -n ">> Installing Winbox$arch.. "
if [ ! -d "$HOME"/.local/bin ]; then
    mkdir -p "$HOME"/.local/bin; fi
cp src/winbox"$arch" "$winbox" && chmod u+x "$winbox" && echo "done"

echo -n ">> Installing desktop entry.. "
if [ ! -d "$HOME"/.local/share/applications ]; then
    mkdir -p "$HOME"/.local/share/applications; fi
desktop_entry && cp src/winbox"$arch".desktop "$desktop_entry" && echo "done"
}

if [ ! "$arch" ]; then
    echo -n ">> Checking system arch.. "
    if [ "$(lscpu | awk '/Architecture/ {print $2}')" = x86_64 ]; then
        arch=64
        echo x86_64
    else
        
        arch=32
        echo x86; fi
else
    echo ">> Explicitly using $arch bit arch"; fi

winbox="$HOME/.local/bin/winbox$arch"
desktop_entry="$HOME/.local/share/applications/winbox$arch.desktop"
#icon="$HOME/.local/share/icons/winbox.png" # unused :P

chkWine && chkSrc && install
