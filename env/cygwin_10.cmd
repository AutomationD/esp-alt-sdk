choco install cygwin cyg-get -y
cyg-get wget gnupg ca-certificates
wget --no-check-certificate https://raw.githubusercontent.com/kou1okada/apt-cyg/master/apt-cyg -O /bin/apt-cyg
chmod +rx /bin/apt-cyg
apt-cyg --no-check-certificate install zip gawk xz bzip2 tar make wget bsdtar gcc-core gcc-g++ gettext bison flex yacc mingw64-i686-gcc-core mingw64-i686-gcc-g++ mingw64-i686-binutils automake1.6 autoconf2.5-2.69 diffutils  texinfo libtool libncursres-devel libintl-devel patch