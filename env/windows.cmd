@echo off
setlocal enableextensions enabledelayedexpansion
choco install -y babun vcredist2013

:: Install Windows python2 in order to build a correct exes out of python scripts
choco install -y python2

:: Add python scripts directory to the PATH so we can run things like pip
setx /M PATH "%PATH%;c:\tools\python2\Scripts"

:: Install Mono - we need this because of memanalyzer. (we should rewrite it in python instead)
choco install -y mono -version 3.2.3

set SCRIPT_PATH=%CD%
set HOME=%SCRIPT_PATH:\=/%

:: Install pip and install pyinstaller
call %USERPROFILE%\.babun\cygwin\bin\bash -i -c "curl -k https://bootstrap.pypa.io/get-pip.py | python && pip install pyinstaller"


call %USERPROFILE%\.babun\cygwin\bin\bash -i -c "pact install zip gawk xz bzip2 tar make wget bsdtar gcc-g++ gettext bison flex byacc automake1.15 autoconf2.5 diffutils texinfo libtool libncursres-devel libintl-devel patch ncurses-devel help2man"

:: Some banner here, so we don't forget
echo ########################################################################
echo #                                                                      #
echo #                                                                      #
echo #                                                                      #
echo #                                                                      #
echo # Please run `make STANDALONE=y` or `make STANDALONE=n`                #
echo #              in the shell that has just opened                       #
echo #                                                                      #
echo #                                                                      #
echo #                                                                      #
echo ########################################################################
call %USERPROFILE%\.babun\cygwin\bin\mintty.exe --hold always --exec /bin/bash -i -l

pause


