@echo off

set ESPRESSIF_HOME=c:/Espressif
echo Upgrading Chocolatey
choco update chocolatey
::@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

echo Add repository
choco sources add -name kireevco -source 'https://www.myget.org/F/kireevco-chocolatey/'

echo Installing wget & curl
choco install wget curl -y

choco install upx -version 3.08

echo Install python
choco install python2-x86_32 -y
pip install pyinstaller
easy_install --always-unzip pyserial


echo Install pyinstaller
pip install pyinstaller


echo [build] > c:\tools\python2-x86_32\Lib\distutils\distutils.cfg
echo compiler = mingw32 >> c:\tools\python2-x86_32\Lib\distutils\distutils.cfg

echo Installing MingGW-get (pulls down mingw too)
choco install mingw -y
choco install mingw --x86 -y
choco install mingw-get -y


echo Installing Mono (for MemAnalyzer and others)
choco install mono  -version 3.2.3 -y

echo Adding ENV variables
setx /M PATH "C:\Program Files (x86)\Mono-3.2.3\bin;%PATH%" && set PATH=C:\Program Files(x86)\Mono-3.2.3\bin;%PATH%

setx /M HOME "c:\Users\User"
setx /M PATH "c:\tools\mingw64\msys\1.0\bin\;%PATH%" && set PATH=c:\tools\mingw64\msys\1.0\bin\;%PATH%
setx /M PATH "C:\tools\python2-x86_32\script;C:\tools\mingw32\bin;c:\tools\mingw64\bin\;%PATH%" && set PATH=C:\tools\python2-x86_32\script;C:\tools\mingw32\bin;c:\tools\mingw64\bin\;%PATH%


echo Installing required mingw components

mingw-get install mingw32-base mingw32-mgwport mingw32-pdcurses mingw32-make mingw-developer-toolkit mingw32-gdb libz bzip2
:: mingw-get install gcc gcc-c++
mingw-get install msys-zip
mingw-get remove autoconf
:: mingw-get mingw32-autoconf mingw32-automake 


::echo Running pip in a different cmd shell
::cmd /c pip install http://sourceforge.net/projects/py2exe/files/latest/download?source=files

:: hack for xgettext.exe bug
echo renaming xgettext.exe to xgettext_.exe
move /Y "c:\tools\mingw64\bin\xgettext.exe" "c:\tools\mingw64\bin\xgettext_.exe"

::msys-base msys-coreutils msys-coreutils-ext msys-gcc-bin msys-m4 msys-bison-bin msys-bison msys-flex msys-flex-bin msys-gawk msys-make msys-regex msys-libregex msys-sed msys-autoconf msys-automake msys-mktemp msys-patch msys-libtool
::msys-gperf 
::alias find="/usr/bin/find"