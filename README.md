# ESP8266 Cross platform SDK
### Work in progress
_Please don't report bugs (yet)_

## Windows
Install git:
```cmd
choco install git.install --params="/NoAutoCrlf" -y
```

Install ConEmu (Optional)
```cmd
choco install conemu -y
```

Install imdisk(Optional)
```
wget http://files1.majorgeeks.com/de670c6775d17d4f699e427ab9260fa3/drives/ImDiskTk.exe
ImDiskTk.exe /fullsilent
r:
```

Clone repo, configure environment
```cmd
git clone https://github.com/kireevco/esp-alt-sdk.git
cd esp-alt-sdk
env/mingw_10.cmd
```

Start build
```cmd
bash.exe -c "make -C env/ && make"
```

## MacOS
Clone repo, configure environment
```shell
git clone https://github.com/kireevco/esp-alt-sdk.git
cd esp-alt-sdk
./env/macos_10.sh
```

Start build
```shell
make -C env/ && make
```


## Ubuntu
Clone repo, configure environment
```shell
git clone https://github.com/kireevco/esp-alt-sdk.git
cd esp-alt-sdk
./env/ubuntu_10.sh
```

Start build
```shell
make -C env/ && make
```