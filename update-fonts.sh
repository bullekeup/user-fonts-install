#!/bin/sh

SCRIPT_PATH="$(dirname $0)"
CALL_PATH="$(pwd)"

FORCE_INSTALL=0;
while [ $# -gt 0 ]; do
  case $1 in 
    --update | -u | --force ) FORCE_INSTALL=1; shift;;
    * ) shift;;
  esac
done

# Powerline fonts
cd ${SCRIPT_PATH} || exit 1;

if [ ${FORCE_INSTALL} -eq 1 ] || [ ! -e "${HOME}/.local/share/fonts/Powerline" ]; then
  echo "Installing powerline fonts to ~/.local/share/fonts/"
  [ -e "./powerline-fonts" ] || git submodule init --recursive
  install -d "${HOME}/.local/share/fonts/Powerline"
  find "$(pwd)/powerline-fonts" \( -name "*.[ot]tf" -or -name "*.pcf.gz" \) -type f -print0 | xargs -0 -n1 -I % install -m644 "%" "$HOME/.local/share/fonts/Powerline/"
fi

# Nerd Fonts
if [ ${FORCE_INSTALL} -eq 1 ] || [ ! -e "${HOME}/.local/share/fonts/NF" ]; then
  FONTS_LIST="FiraCode FiraMono CodeNewRoman DejaVuSansMono DroidSansMono Go-Mono Gohu Hack Inconsolata InconsolataGo InconsolataLGC Iosevka JetBrainsMono LiberationMono Meslo Monoid RobotoMono SourceCodePro SpaceMono Terminus Ubuntu UbuntuMono"

  echo "Installing Nerd Fonts..."
  [ -e "./NF" ] && rm -Rf ./NF;
  mkdir NF;

  for FONT in ${FONTS_LIST}; do
    curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/${FONT}.zip
    unzip ${FONT}.zip -d NF/
  done

  install -d ~/.local/share/fonts/NF
  find "$(pwd)/NF" \( -name "*.[ot]tf" -or -name "*.pcf.gz" \) -type f -print0 | xargs -0 -n1 -I % install -m644 "%" "$HOME/.local/share/fonts/NF/"
  fc-cache -f
  rm *.zip
  rm -R ./NF
fi

# Feather font
if [ ${FORCE_INSTALL} -eq 1 ] || [ ! -e "${HOME}/.local/share/fonts/feather.ttf" ]; then
  echo "Installing Feather font to ~/.local/share/fonts"
  curl -LO https://github.com/AT-UI/feather-font/raw/master/src/fonts/feather.ttf
  cp feather.ttf ~/.local/share/fonts/
  rm feather.ttf
  fc-cache -f
fi

# Weather Icons
if [ ${FORCE_INSTALL} -eq 1 ] || [ ! -e "${HOME}/.local/share/fonts/weathericons-regular-webfont.ttf" ]; then
  echo "Installing Weather Icons font to ~/.local/share/fonts"
  curl -LO https://github.com/erikflowers/weather-icons/raw/master/font/weathericons-regular-webfont.ttf
  cp weathericons-regular-webfont.ttf ~/.local/share/fonts/
  rm weathericons-regular-webfont.ttf
  fc-cache -f
fi

echo "Fonts Powerline, selection of Nerd Fonts, Feather and Weather Icons installed !"

