@echo off

set ESPRESSIF_HOME=c:/Espressif
echo Upgrading Chocolatey
choco update chocolatey
::@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

echo Add repository
choco sources add -name kireevco -source 'https://www.myget.org/F/kireevco-chocolatey/'

echo Installing wget & curl
choco install wget curl -y

echo Install python
choco install python pip -y

echo Installing MingGW-get (pulls down mingw too)
choco install mingw-get -y

echo Adding ENV variables

setx /M HOME "c:\Users\User"
setx /M PATH "c:\tools\mingw64\msys\1.0\bin\;%PATH%" && set PATH=c:\tools\mingw64\msys\1.0\bin\;%PATH%
setx /M PATH "c:\tools\mingw64\bin\;%PATH%" && set PATH=c:\tools\mingw64\bin\;%PATH%

echo Installing required mingw components

mingw-get install mingw32-base mingw32-mgwport mingw32-pdcurses mingw32-make mingw-developer-toolkit mingw32-gdb libz bzip2 wget 

:: mingw-get install gcc gcc-c++
mingw-get install msys-zip
mingw-get remove autoconf
:: mingw-get mingw32-autoconf mingw32-automake 


:: hack for xgettext.exe bug
echo renaming xgettext.exe to xgettext_.exe
move /Y "c:\tools\mingw64\bin\xgettext.exe" "c:\tools\mingw64\bin\xgettext_.exe"

::msys-base msys-coreutils msys-coreutils-ext msys-gcc-bin msys-m4 msys-bison-bin msys-bison msys-flex msys-flex-bin msys-gawk msys-make msys-regex msys-libregex msys-sed msys-autoconf msys-automake msys-mktemp msys-patch msys-libtool
::msys-gperf 
::alias find="/usr/bin/find"