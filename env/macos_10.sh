#!/bin/bash

## Disable root check, as brew doesn't need root. Xcode will ask for a sudo password though.
# if [ "$(id -u)" != "0" ]; then
#         echo "Sorry, you are not root."
#         exit 1
# fi


cd ~/
if [ -d $(eval 'xcode-select -p') ]; then
  echo "Xcode is installed"
else
  echo "Installing Xcode"
  curl -L -o xcode-6.2-cmd-tools.pkg "https://www.dropbox.com/s/1t7ux39sccxqfwx/xcode-6.2-cmd-tools.pkg\?dl\=0"
  sudo installer -pkg ~/xcode-6.2-cmd-tools.pkg -target / && rm -rf xcode-6.2-cmd-tools.pkg
fi

echo "Install Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing additional tools"
brew install homebrew/dupes
brew install binutils coreutils automake wget gawk libtool gperf grep python python3 wget tmux
brew install gnu-sed --with-default-names
brew install findutils --with-default-names

echo "Installing mono"
brew install mono

# brew install binutils
# brew install diffutils
# brew install ed --default-names
# brew install gawk
# brew install gnu-indent --with-default-names
# brew install gnu-sed --with-default-names
# brew install gnu-tar --with-default-names
# brew install gnu-which --with-default-names
# brew install gnutls
# brew install grep --with-default-names
# brew install gzip
# brew install screen
# brew install watch
# brew install wdiff --with-gettext
# brew install wget