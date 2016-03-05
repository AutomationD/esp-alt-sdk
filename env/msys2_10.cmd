echo Upgrading Chocolatey
choco update chocolatey

echo Add repository
choco sources add -name kireevco -source 'https://www.myget.org/F/kireevco-chocolatey/'

echo Install msys2
choco install msys2 -y

set PATH=c:\tools\msys64\usr\bin\;%PATH%
bash update-core
pacman -sU

echo Install Packages
pacman -S git autoconf automake bsdtar zip mingw-w64-i686-toolchain mingw-w64-i686-isl make gettext texinfo bison flex patch --noconfirm
