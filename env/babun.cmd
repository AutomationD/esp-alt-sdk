@echo off
choco install babun -y
call %USERPROFILE%\.babun\cygwin\bin\bash -i -c "pact install zip gawk xz bzip2 tar make wget bsdtar gcc-g++ gettext bison flex byacc automake1.15 autoconf2.5 diffutils texinfo libtool libncursres-devel libintl-devel patch ncurses-devel help2man"

call %USERPROFILE%\.babun\babun.bat
pause Please run `make STANDALONE=y` in the shell that will open:



