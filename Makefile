# Author: Dmitry Kireev (@kireevco)
#
# Contrubutions: (@Juppit) - patches for gcc & Cygwin
#
# Credits to Paul Sokolovsky (@pfalcon) for esp-open-sdk
# Credits to Fabien Poussin (@fpoussin) for xtensa-lx106-elf build script
#

STANDALONE = y
PREBUILT_TOOLCHAIN = n
DEBUG = y
UTILS = y
CROSS_TARGET = n
TOOLCHAIN_ONLY = n
VENDOR_SDK = 1.5.4
TOP = $(PWD)

TARGET = xtensa-lx106-elf

MINGW_DIR := c:\tools\mingw64
SRC_DIR = $(TOP)/src
UTILS_DIR = $(TOP)/utils
PATCHES_DIR = $(SRC_DIR)/patches

ESP_OPEN_SDK_DIR = esp-open-sdk
ESPTOOL_DIR = esptool
ESPTOOL2_DIR = esptool2
ESPTOOL2_SRCREPO = rabutron-esp8266
MEMANALYZER_DIR = ESP8266_memory_analyzer
TOOLCHAIN = $(SRC_DIR)/$(ESP_OPEN_SDK_DIR)/$(TARGET)


ifeq ($(DEBUG),y)
	UNTAR := bsdtar xf
	MAKE_OPT := make -s
	CONF_OPT := configure
	INST_OPT := install
else
	UNTAR := bsdtar -xf
	MAKE_OPT := make -s -j2
	CONF_OPT := configure -q
	INST_OPT := install -s
endif

PLATFORM := $(shell uname -s)


SAFEPATH := $(TOOLCHAIN)/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin::/mingw/bin/:/c/tools/mingw32/bin:/c/tools/mingw64/bin:/mingw32:/mingw32/bin:/c/windows/system32:/c/tools/python2-x86_32/Scripts:/c/Program\ Files\ \(x86\)/Mono-3.2.3/bin
PATH := $(TOOLCHAIN)/bin:$(PATH)

############################################################################################################
# TODO:
# - git clone https://github.com/kireevco/esp-open-sdk.git to $(TOP)/esp-open-sdk
# - make -c esp-open-sdk
# .PHONY: esp-open-sdk utils


# all: esptool libcirom standalone sdk sdk_patch $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/libhal.a $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
all: debug config platform-specific

# Used to pass platform-specific parameters to the build
build: esp-open-sdk utils

# If we are not building a toolchain via esp-open-sdk we download it.
#build-prebuilt-toolchain: standalone $(TOP)/sdk utils

ifeq ($(UTILS),y)
  utils: esptool esptool2 memanalyzer
else
  utils:
endif

esp-open-sdk: $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
esptool: $(UTILS_DIR)/esptool
esptool2: $(UTILS_DIR)/esptool2
memanalyzer: $(UTILS_DIR)/memanalyzer

config:
	git config --global core.autocrlf false

# Esptool is a common tool to upload firmware to esp8266 devices
$(UTILS_DIR)/esptool: $(SRC_DIR)/$(ESPTOOL_DIR)/esptool.py
	mkdir -p $(UTILS_DIR)/
#	cd $(SRC_DIR)/$(ESPTOOL_DIR); python setup.py install
  ifeq ($(OS),Windows_NT)
		cd $(SRC_DIR)/$(ESPTOOL_DIR); pyinstaller --onefile esptool.py
		cd $(SRC_DIR)/$(ESPTOOL_DIR)/dist; cp esptool.exe $(UTILS_DIR)/
  else
		cp $(SRC_DIR)/$(ESPTOOL_DIR)/esptool.py $(UTILS_DIR)/
  endif

# Memanalyzer is a c# util that is reading objdump. TODO: We need to replace it with a simple python script
$(UTILS_DIR)/memanalyzer: $(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer.sln
	mkdir -p $(UTILS_DIR)/

	cd $(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer/; PATH=$(SAFEPATH) mcs Program.cs

  ifeq ($(OS),Windows_NT)
		cd $(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer/; cp Program.exe $(UTILS_DIR)/memanalyzer.exe
  endif

  ifeq ($(PLATFORM),Darwin)
	 	@echo "Detected: MacOS"
		cd $(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer/; CC="cc -framework CoreFoundation -lobjc -liconv" mkbundle Program.exe -o memanalyzer --deps --static
		cd $(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer/; cp memanalyzer $(UTILS_DIR)/
  endif
  ifeq ($(PLATFORM),Linux)
		cd $(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer/; mkbundle Program.exe -o memanalyzer --deps --static
		cd $(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer/; cp memanalyzer $(UTILS_DIR)/
  endif
  ifeq ($(PLATFORM),FreeBSD)
	 	cd $(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer/; mkbundle Program.exe -o memanalyzer --deps --static
	 	cd $(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer/; cp memanalyzer $(UTILS_DIR)/
  endif

# Esptool2 is a utility to upload rboot-based firmware
$(UTILS_DIR)/esptool2: $(SRC_DIR)/$(ESPTOOL2_DIR)/esptool2.c
	make clean -C $(SRC_DIR)/$(ESPTOOL2_DIR)/
	make -C $(SRC_DIR)/$(ESPTOOL2_DIR)/
	mkdir -p $(UTILS_DIR)
	cp $(SRC_DIR)/$(ESPTOOL2_DIR)/esptool2 $(UTILS_DIR)/



$(SRC_DIR)/$(ESP_OPEN_SDK_DIR)/Makefile:
	@echo "You cloned without --recursive, fetching esp-open-sdk for you."
	git submodule update --init $(SRC_DIR)/$(ESP_OPEN_SDK_DIR)

$(SRC_DIR)/$(ESPTOOL_DIR)/esptool.py:
	@echo "You cloned without --recursive, fetching esptool for you."
	git submodule update --init $(SRC_DIR)/$(ESPTOOL_DIR)

$(SRC_DIR)/$(ESPTOOL2_DIR)/esptool2.c:
	@echo "You cloned without --recursive, fetching esptool2 for you."
	git submodule update --init $(SRC_DIR)/$(ESPTOOL2_DIR)

$(SRC_DIR)/$(MEMANALYZER_DIR)/MemAnalyzer.sln:
	@echo "You cloned without --recursive, fetching MemAnalyzer for you."
	git submodule update --init $(SRC_DIR)/$(MEMANALYZER_DIR)

debug:
  ifeq ($(DEBUG),y)
	@echo "----------------------------------------------------"
	@echo "Outputting debug info. Makefiles are so Makefiles..."
	@echo "OS: $(OS)"
	@echo "PLATFORM: $(PLATFORM)"
	@echo "PATH: $(PATH)"
	@echo "TOOLCHAIN: $(TOOLCHAIN)"
	@echo "----------------------------------------------------"

  endif

$(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc: $(SRC_DIR)/$(ESP_OPEN_SDK_DIR)/Makefile
	cd $(SRC_DIR)/$(ESP_OPEN_SDK_DIR); $(MAKE) STANDALONE=$(STANDALONE)


compress-upx: $(TOOLCHAIN)/bin/.upx $(TOOLCHAIN)/xtensa-lx106-elf/bin/.upx $(TOOLCHAIN)/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/.upx
strip: $(TOOLCHAIN)/bin/.strip $(TOOLCHAIN)/xtensa-lx106-elf/bin/.strip $(TOOLCHAIN)/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/.strip

prebuilt-toolchain-windows: $(SRC_DIR)/$(XTENSA_TOOLCHAIN_WINDOWS_TAR)
	$(UNTAR) $(SRC_DIR)/$(XTENSA_TOOLCHAIN_WINDOWS_TAR) -C $(TOP)

prebuilt-toolchain-mac: $(SRC_DIR)/$(XTENSA_TOOLCHAIN_MAC_TAR)
	$(UNTAR) $(SRC_DIR)/$(XTENSA_TOOLCHAIN_MAC_TAR) -C $(TOP)

prebuilt-toolchain-linux: $(SRC_DIR)/$(XTENSA_TOOLCHAIN_LINUX_TAR)
	$(UNTAR) $(SRC_DIR)/$(XTENSA_TOOLCHAIN_LINUX_TAR) -C $(TOP)

prebuilt-toolchain-freebsd: $(SRC_DIR)/$(XTENSA_TOOLCHAIN_LINUX_TAR)
	$(UNTAR) $(SRC_DIR)/$(XTENSA_TOOLCHAIN_LINUX_TAR) -C $(TOP)


platform-specific:
	@echo "Performing platform-specific actions"
  ifeq ($(OS),Windows_NT)
    ifneq (,$(findstring MINGW32,$(PLATFORM)))
			@echo "Detected: MinGW32."
			$(MAKE) /mingw
      ifeq ($(PREBUILT_TOOLCHAIN),y)
				$(MAKE) prebuilt-toolchain-windows
				$(MAKE) build-prebuilt-toolchain
      else
				@echo "Can't build it under MinGW32. You will have to use a prebuilt toolchain"
      endif
    else
      ifneq (,$(findstring MSYS,$(PLATFORM)))
				@echo "Detected: MSYS."
        ifeq ($(PREBUILT_TOOLCHAIN),y)
					$(MAKE) prebuilt-toolchain-windows
					$(MAKE) build-prebuilt-toolchain
        else
					@echo "Can't build it under MSYS. You will have to use a prebuilt toolchain"
        endif
      endif
    endif
  endif

  ifneq (,$(findstring CYGWIN,$(PLATFORM)))
		@echo "Detected: CYGWIN"
    ifeq ($(PREBUILT_TOOLCHAIN),y)
			$(MAKE) prebuilt-toolchain-windows
			$(MAKE) build-prebuilt-toolchain
    else
			$(MAKE) build
			$(MAKE) copy-cygwin-deps
    endif
  endif

  ifeq ($(PLATFORM),Darwin)
			@echo "Detected: MacOS"
      ifeq ($(PREBUILT_TOOLCHAIN),y)
				$(MAKE) prebuilt-toolchain-mac
				$(MAKE) build-prebuilt-toolchain
      else
				$(MAKE) build
      endif
  else
    ifeq ($(PLATFORM),Linux)
				@echo "Detected: Linux"
        ifeq ($(PREBUILT_TOOLCHAIN),y)
					$(MAKE) prebuilt-toolchain-linux
					$(MAKE) build-prebuilt-toolchain
        else
					$(MAKE) build
        endif
    endif
    ifeq ($(PLATFORM),FreeBSD)
				@echo "Detected: FreeBSD"
        ifeq ($(PREBUILT_TOOLCHAIN),y)
					$(MAKE) prebuilt-toolchain-freebsd
        endif
				$(MAKE) build
    endif
  endif

copy-cygwin-deps: $(TOOLCHAIN)/bin/cygwin1.dll
	

# cygwin.dll that is required for Cygwin
$(TOOLCHAIN)/bin/cygwin1.dll:
	@echo "Copying cygwin1.dll (Cygwin Dependecny)"
	@cp /bin/cygwin1.dll $(TOOLCHAIN)/bin/

# Srip Debug
$(TOOLCHAIN)/bin/.strip:
	@echo "Stripping debug symbols from executables in ${TOOLCHAIN}/bin/"
	cd $(TOOLCHAIN)/bin/ && (find . -type f \( -iname "*" ! -iname "*lib*" ! -iname "*.so*" \) -perm /u=x -exec strip -S "{}" +) && touch $(TOOLCHAIN)/bin/.strip	
	
$(TOOLCHAIN)/xtensa-lx106-elf/bin/.strip:
	@echo "Stripping debug symbols from executables in ${TOOLCHAIN}/xtensa-lx106-elf/bin/"
	cd $(TOOLCHAIN)/xtensa-lx106-elf/bin && (find . -type f \( -iname "*" ! -iname "*lib*" ! -iname "*.so*" \) -perm /u=x -exec strip -S "{}" +) && touch $(TOOLCHAIN)/xtensa-lx106-elf/bin/.strip

$(TOOLCHAIN)/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/.strip:
	@echo "Stripping debug symbols from executables in ${TOOLCHAIN}/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/"
	cd $(TOOLCHAIN)/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/ && (find . -type f \( -iname "*" ! -iname "*lib*" ! -iname "*.so*" ! -path "./install-tools/*" \) -perm /u=x -exec strip -S "{}" +) && touch $(TOOLCHAIN)/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/.strip

# Compress via UPX
$(TOOLCHAIN)/bin/.upx:
	@echo "Compressing executables in ${TOOLCHAIN}/bin/"
	cd $(TOOLCHAIN)/bin/ && (find . -type f \( -iname "*" ! -iname "*lib*" ! -iname "*.so*" \) -perm /u=x -exec sh -c "grep UPX\! '{}' > /dev/null && echo 'Skipping {}, since it is already UPX-compressed.' || upx --best '{}'" \;) && touch $(TOOLCHAIN)/bin/.upx

$(TOOLCHAIN)/xtensa-lx106-elf/bin/.upx:
	@echo "Compressing executables in ${TOOLCHAIN}/xtensa-lx106-elf/bin/"
	cd $(TOOLCHAIN)/xtensa-lx106-elf/bin && (find . -type f \( -iname "*" ! -iname "*lib*" ! -iname "*.so*" \) -perm /u=x -exec sh -c "grep UPX\! '{}' > /dev/null && echo 'Skipping {}, since it is already UPX-compressed.' || upx --best '{}'" \;) && touch $(TOOLCHAIN)/xtensa-lx106-elf/bin/.upx

$(TOOLCHAIN)/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/.upx:
	@echo "Compressing executables in ${TOOLCHAIN}/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/"
	cd $(TOOLCHAIN)/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/ && (find . -type f \( -iname "*" ! -iname "*lib*" ! -iname "*.so*" \) -perm /u=x -exec sh -c "grep UPX\! '{}' > /dev/null && echo 'Skipping {}, since it is already UPX-compressed.' || upx --best '{}'" \;) && touch $(TOOLCHAIN)/libexec/gcc/xtensa-lx106-elf/$(GCC_VERSION)/.upx




clean: clean-sdk
	-rm -rf $(TOOLCHAIN)
	rm -rf $(SRC_DIR)/$(GMP_DIR)/build
	rm -rf $(SRC_DIR)/$(MPFR_DIR)/build
	rm -rf $(SRC_DIR)/$(MPC_DIR)/build
	rm -rf $(SRC_DIR)/$(BINUTILS_DIR)/build
	rm -rf $(SRC_DIR)/$(GCC_DIR)/build-1
	rm -rf $(SRC_DIR)/$(GCC_DIR)/build-2
	rm -rf $(SRC_DIR)/$(NEWLIB_DIR)/build
	rm -rf $(SRC_DIR)/$(LIBHAL_DIR)/build
	rm -rf $(SRC_DIR)/$(ESPTOOL2_DIR)/esptool2
	rm -rf $(UTILS_DIR)/*
	rm -rf $(PATCHES_DIR)/.*_patch*

clean-sdk:
	rm -rf $(VENDOR_SDK_DIR)
	rm -rf $(VENDOR_SDK_ZIP)
	rm -rf release_note.txt
	rm -rf sdk
	rm -rf ESP8266_SDK
	rm -f .sdk_patch_*
	rm -rf $(PATCHES_DIR)/.gcc_patch*
	rm -rf build
	rm -rf bin


purge: clean
	rm -rf $(SRC_DIR)/$(GMP_DIR)/
	rm -rf $(SRC_DIR)/$(MPFR_DIR)/
	rm -rf $(SRC_DIR)/$(MPC_DIR)/
	rm -rf $(SRC_DIR)/$(UTILS_DIR)/
	rm -rf $(SRC_DIR)/*.{zip,bz2,xz,gz}
	cd $(SRC_DIR)/$(BINUTILS_DIR)/; git reset --hard
	cd $(SRC_DIR)/$(GCC_DIR)/; git reset --hard
	cd $(SRC_DIR)/$(NEWLIB_DIR)/; git reset --hard
	cd $(SRC_DIR)/$(LIBHAL_DIR)/; git reset --hard
	cd $(SRC_DIR)/$(ESPTOOL2_DIR); git reset --hard

clean-sysroot:
	rm -rf $(TOOLCHAIN)/xtensa-lx106-elf/usr/lib/*
	rm -rf $(TOOLCHAIN)/xtensa-lx106-elf/usr/include/*
