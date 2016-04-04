@echo off
echo ###############################################
echo ###### Configuring environment for msys2 ######
echo ###############################################
echo ***** Upgrading Chocolatey *****
choco update chocolatey -y

echo ***** Add Chocolatey repository *****
choco sources add -name kireevco -source 'https://www.myget.org/F/kireevco-chocolatey/'

echo ***** Installing msys2 *****
choco install msys2 -y

echo ***** Installing msys2 Packages *****
set PATH=c:\tools\msys64\usr\bin\;%PATH%
bash update-core
pacman -sU

pacman -S git autoconf automake wget bsdtar zip mingw-w64-i686-toolchain mingw-w64-i686-isl make gettext texinfo bison flex patch upx --noconfirm

echo ***** Installing Extra Packages for building exe from python ***** 
::pacman -S python2 mingw-w64-i686-python2-pip
choco install python2-x86_32 -y
easy_install --always-unzip pyserial

echo Install pyinstaller
pip install pyinstaller


echo [build] > c:\tools\python2-x86_32\Lib\distutils\distutils.cfg
echo compiler = mingw32 >> c:\tools\python2-x86_32\Lib\distutils\distutils.cfg

echo ***** Installing Mono ***** 
choco install mono -version 3.2.3 -y

echo ***** Adding ENV variables *****
setx /M PATH "C:\Program Files (x86)\Mono-3.2.3\bin;%PATH%" && set PATH=C:\Program Files(x86)\Mono-3.2.3\bin;%PATH%

echo ###############################################
echo ############ Done. Now run `make` #############
echo ###############################################