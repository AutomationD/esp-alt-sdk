# Author: Dmitry Kireev (@kireevco)
# 
# Credits to Paul Sokolovsky (@pfalcon) for esp-open-sdk
# Credits to Fabien Poussin (@fpoussin) for xtensa-lx106-elf build script
#


VENDOR_SDK_VERSION = 1.4.0
GMP_VERSION = 6.0.0a
MPFR_VERSION = 3.1.2
MPC_VERSION = 1.0.2


TOP = $(PWD)
TARGET = xtensa-lx106-elf
TOOLCHAIN = $(TOP)/$(TARGET)

XTTC = $(TOOLCHAIN)
XTBP = $(TOP)/build
XTDLP = $(TOP)/src

GMP_TAR = gmp-$(GMP_VERSION).tar.bz2
MPFR_TAR = mpfr-$(MPFR_VERSION).tar.bz2
MPC_TAR = mpc-$(MPC_VERSION).tar.gz

GMP_DIR = gmp-$(GMP_VERSION)
MPFR_DIR = mpfr-$(MPFR_VERSION)
MPC_DIR = mpc-$(MPC_VERSION)

GCC_DIR = gcc-xtensa
NEWLIB_DIR = newlib-xtensa
BINUTILS_DIR = esp-binutils
LIBHAL_DIR = lx106-hal

UNZIP = unzip -q -o
UNTAR = tar -xf

PATH := $(XTTC)/bin:$(PATH)


VENDOR_SDK_ZIP = $(VENDOR_SDK_ZIP_$(VENDOR_SDK_VERSION))
VENDOR_SDK_DIR = $(VENDOR_SDK_DIR_$(VENDOR_SDK_VERSION))

VENDOR_SDK_ZIP_1.4.0 = esp_iot_sdk_v1.4.0_15_09_18.zip
VENDOR_SDK_DIR_1.4.0 = esp_iot_sdk_v1.4.0
VENDOR_SDK_ZIP_1.3.0 = esp_iot_sdk_v1.3.0_15_08_08.zip
VENDOR_SDK_DIR_1.3.0 = esp_iot_sdk_v1.3.0
VENDOR_SDK_ZIP_1.2.0 = esp_iot_sdk_v1.2.0_15_07_03.zip
VENDOR_SDK_DIR_1.2.0 = esp_iot_sdk_v1.2.0
VENDOR_SDK_ZIP_1.1.2 = esp_iot_sdk_v1.1.2_15_06_12.zip
VENDOR_SDK_DIR_1.1.2 = esp_iot_sdk_v1.1.2
VENDOR_SDK_ZIP_1.1.1 = esp_iot_sdk_v1.1.1_15_06_05.zip
VENDOR_SDK_DIR_1.1.1 = esp_iot_sdk_v1.1.1
VENDOR_SDK_ZIP_1.1.0 = esp_iot_sdk_v1.1.0_15_05_26.zip
VENDOR_SDK_DIR_1.1.0 = esp_iot_sdk_v1.1.0
# MIT-licensed version was released without changing version number
#VENDOR_SDK_ZIP_1.1.0 = esp_iot_sdk_v1.1.0_15_05_22.zip
#VENDOR_SDK_DIR_1.1.0 = esp_iot_sdk_v1.1.0
VENDOR_SDK_ZIP_1.0.1 = esp_iot_sdk_v1.0.1_15_04_24.zip
VENDOR_SDK_DIR_1.0.1 = esp_iot_sdk_v1.0.1
VENDOR_SDK_ZIP_1.0.1b2 = esp_iot_sdk_v1.0.1_b2_15_04_10.zip
VENDOR_SDK_DIR_1.0.1b2 = esp_iot_sdk_v1.0.1_b2
VENDOR_SDK_ZIP_1.0.1b1 = esp_iot_sdk_v1.0.1_b1_15_04_02.zip
VENDOR_SDK_DIR_1.0.1b1 = esp_iot_sdk_v1.0.1_b1
VENDOR_SDK_ZIP_1.0.0 = esp_iot_sdk_v1.0.0_15_03_20.zip
VENDOR_SDK_DIR_1.0.0 = esp_iot_sdk_v1.0.0
VENDOR_SDK_ZIP_0.9.6b1 = esp_iot_sdk_v0.9.6_b1_15_02_15.zip
VENDOR_SDK_DIR_0.9.6b1 = esp_iot_sdk_v0.9.6_b1
VENDOR_SDK_ZIP_0.9.5 = esp_iot_sdk_v0.9.5_15_01_23.zip
VENDOR_SDK_DIR_0.9.5 = esp_iot_sdk_v0.9.5
VENDOR_SDK_ZIP_0.9.4 = esp_iot_sdk_v0.9.4_14_12_19.zip
VENDOR_SDK_DIR_0.9.4 = esp_iot_sdk_v0.9.4
VENDOR_SDK_ZIP_0.9.3 = esp_iot_sdk_v0.9.3_14_11_21.zip
VENDOR_SDK_DIR_0.9.3 = esp_iot_sdk_v0.9.3
VENDOR_SDK_ZIP_0.9.2 = esp_iot_sdk_v0.9.2_14_10_24.zip
VENDOR_SDK_DIR_0.9.2 = esp_iot_sdk_v0.9.2
STANDALONE = y

.PHONY: toolchain libhal libcirom sdk

# all: esptool libcirom standalone sdk sdk_patch $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/libhal.a $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
all: standalone sdk sdk_patch $(TOOLCHAIN)/xtensa-lx106-elf/lib/libhal.a $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
	@echo ok
# 	@echo
# 	@echo "Xtensa toolchain is built, to use it:"
# 	@echo
# 	@echo 'export PATH=$(TOOLCHAIN)/bin:$$PATH'
# 	@echo
# ifneq ($(STANDALONE),y)
# 	@echo "Espressif ESP8266 SDK is installed. Toolchain contains only Open Source components"
# 	@echo "To link external proprietary libraries add:"
# 	@echo
# 	@echo "xtensa-lx106-elf-gcc -I$(TOP)/sdk/include -L$(TOP)/sdk/lib"
# 	@echo
# else
# 	@echo "Espressif ESP8266 SDK is installed, its libraries and headers are merged with the toolchain"
# 	@echo
# endif

esptool: toolchain
	@echo "esptool copied"

$(TOOLCHAIN)/xtensa-lx106-elf/sysroot/lib/libcirom.a: $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/lib/libc.a $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
	@echo "Creating irom version of libc..."
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-objcopy --rename-section .text=.irom0.text \
		--rename-section .literal=.irom0.literal $(<) $(@);

libcirom: $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/lib/libcirom.a

sdk_patch: .sdk_patch_$(VENDOR_SDK_VERSION)

.sdk_patch_1.4.0:
	patch -N -d $(VENDOR_SDK_DIR_1.4.0) -p1 < $(XTDLP)/c_types-c99.patch
	@touch $@

.sdk_patch_1.3.0:
	patch -N -d $(VENDOR_SDK_DIR_1.3.0) -p1 < $(XTDLP)/c_types-c99.patch
	@touch $@

.sdk_patch_1.2.0: lib_mem_optimize_150714.zip libssl_patch_1.2.0-2.zip empty_user_rf_pre_init.o
	#$(UNZIP) libssl_patch_1.2.0-2.zip
	#$(UNZIP) libsmartconfig_2.4.2.zip
	$(UNZIP) lib_mem_optimize_150714.zip
	#mv libsmartconfig_2.4.2.a $(VENDOR_SDK_DIR_1.2.0)/lib/libsmartconfig.a
	mv libssl.a libnet80211.a libpp.a libsmartconfig.a $(VENDOR_SDK_DIR_1.2.0)/lib/
	patch -N -f -d $(VENDOR_SDK_DIR_1.2.0) -p1 < $(XTDLP)/c_types-c99.patch
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-ar r $(VENDOR_SDK_DIR_1.2.0)/lib/libmain.a empty_user_rf_pre_init.o
	@touch $@

.sdk_patch_1.1.2: scan_issue_test.zip 1.1.2_patch_02.zip empty_user_rf_pre_init.o
	$(UNZIP) scan_issue_test.zip
	$(UNZIP) 1.1.2_patch_02.zip
	mv libmain.a libnet80211.a libpp.a $(VENDOR_SDK_DIR_1.1.2)/lib/
	patch -N -f -d $(VENDOR_SDK_DIR_1.1.2) -p1 < $(XTDLP)/c_types-c99.patch
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-ar r $(VENDOR_SDK_DIR_1.1.2)/lib/libmain.a empty_user_rf_pre_init.o
	@touch $@

.sdk_patch_1.1.1: empty_user_rf_pre_init.o
	patch -N -f -d $(VENDOR_SDK_DIR_1.1.1) -p1 < $(XTDLP)/c_types-c99.patch
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-ar r $(VENDOR_SDK_DIR_1.1.1)/lib/libmain.a empty_user_rf_pre_init.o
	@touch $@

.sdk_patch_1.1.0: lib_patch_on_sdk_v1.1.0.zip empty_user_rf_pre_init.o
	$(UNZIP) $<
	mv libsmartconfig_patch_01.a $(VENDOR_SDK_DIR_1.1.0)/lib/libsmartconfig.a
	mv libmain_patch_01.a $(VENDOR_SDK_DIR_1.1.0)/lib/libmain.a
	mv libssl_patch_01.a $(VENDOR_SDK_DIR_1.1.0)/lib/libssl.a
	patch -N -f -d $(VENDOR_SDK_DIR_1.1.0) -p1 < $(XTDLP)/c_types-c99.patch
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-ar r $(VENDOR_SDK_DIR_1.1.0)/lib/libmain.a empty_user_rf_pre_init.o
	@touch $@

empty_user_rf_pre_init.o: empty_user_rf_pre_init.c $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc -O2 -c $<

.sdk_patch_1.0.1: libnet80211.zip esp_iot_sdk_v1.0.1/.dir
	$(UNZIP) $<
	mv libnet80211.a $(VENDOR_SDK_DIR_1.0.1)/lib/
	patch -N -f -d $(VENDOR_SDK_DIR_1.0.1) -p1 < $(XTDLP)/c_types-c99.patch
	@touch $@

.sdk_patch_1.0.1b2: libssl.zip esp_iot_sdk_v1.0.1_b2/.dir
	$(UNZIP) $<
	mv libssl/libssl.a $(VENDOR_SDK_DIR_1.0.1b2)/lib/
	patch -N -d $(VENDOR_SDK_DIR_1.0.1b2) -p1 < $(XTDLP)/c_types-c99.patch
	@touch $@

.sdk_patch_1.0.1b1:
	patch -N -d $(VENDOR_SDK_DIR_1.0.1b1) -p1 < $(XTDLP)/c_types-c99.patch
	@touch $@

.sdk_patch_1.0.0:
	patch -N -d $(VENDOR_SDK_DIR_1.0.0) -p1 < $(XTDLP)/c_types-c99.patch
	@touch $@

.sdk_patch_0.9.6b1:
	patch -N -d $(VENDOR_SDK_DIR_0.9.6b1) -p1 < $(XTDLP)/c_types-c99.patch
	@touch $@

.sdk_patch_0.9.5: sdk095_patch1.zip esp_iot_sdk_v0.9.5/.dir
	$(UNZIP) $<
	mv libmain_fix_0.9.5.a $(VENDOR_SDK_DIR)/lib/libmain.a
	mv user_interface.h $(VENDOR_SDK_DIR)/include/
	patch -N -d $(VENDOR_SDK_DIR_0.9.5) -p1 < $(XTDLP)/c_types-c99.patch
	@touch $@

.sdk_patch_0.9.4:
	patch -N -d $(VENDOR_SDK_DIR_0.9.4) -p1 < $(XTDLP)/c_types-c99.patch
	@touch $@

.sdk_patch_0.9.3: esp_iot_sdk_v0.9.3_14_11_21_patch1.zip esp_iot_sdk_v0.9.3/.dir
	$(UNZIP) $<
	@touch $@

.sdk_patch_0.9.2: FRM_ERR_PATCH.rar esp_iot_sdk_v0.9.2/.dir 
	unrar x -o+ $<
	cp FRM_ERR_PATCH/*.a $(VENDOR_SDK_DIR)/lib/
	@touch $@

standalone: sdk sdk_patch toolchain
ifeq ($(STANDALONE),y)
	@echo "Installing vendor SDK headers into toolchain sysroot"
	@cp -R -f sdk/include/* $(TOOLCHAIN)/xtensa-lx106-elf/include/
	@echo "Installing vendor SDK libs into toolchain sysroot"
	@cp -R -f sdk/lib/* $(TOOLCHAIN)/xtensa-lx106-elf/lib/
	@echo "Installing vendor SDK linker scripts into toolchain sysroot"
	@sed -e 's/\r//' sdk/ld/eagle.app.v6.ld | sed -e s@../ld/@@ >$(TOOLCHAIN)/xtensa-lx106-elf/lib/eagle.app.v6.ld
	@sed -e 's/\r//' sdk/ld/eagle.rom.addr.v6.ld >$(TOOLCHAIN)/xtensa-lx106-elf/lib/eagle.rom.addr.v6.ld
endif

FRM_ERR_PATCH.rar:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=10" --output-document $@
esp_iot_sdk_v0.9.3_14_11_21_patch1.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=73" --output-document $@
sdk095_patch1.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=190" --output-document $@
libssl.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=316" --output-document $@
libnet80211.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=361" --output-document $@
lib_patch_on_sdk_v1.1.0.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=432" --output-document $@
scan_issue_test.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=525" --output-document $@
1.1.2_patch_02.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=546" --output-document $@
libssl_patch_1.2.0-1.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=583" --output-document $@
libssl_patch_1.2.0-2.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=586" --output-document $@
libsmartconfig_2.4.2.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=585" --output-document $@
lib_mem_optimize_150714.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=594" --output-document $@

sdk: $(VENDOR_SDK_DIR)/.dir
	ln -snf $(VENDOR_SDK_DIR) sdk

$(VENDOR_SDK_DIR)/.dir: $(VENDOR_SDK_ZIP)
	$(UNZIP) $^
	-mv License $(VENDOR_SDK_DIR)
	touch $@

esp_iot_sdk_v1.4.0_15_09_18.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=838" --output-document $@

esp_iot_sdk_v1.3.0_15_08_08.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=664" --output-document $@

esp_iot_sdk_v1.2.0_15_07_03.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=564" --output-document $@

esp_iot_sdk_v1.1.2_15_06_12.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=521" --output-document $@

esp_iot_sdk_v1.1.1_15_06_05.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=484" --output-document $@

esp_iot_sdk_v1.1.0_15_05_26.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=425" --output-document $@

esp_iot_sdk_v1.1.0_15_05_22.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=423" --output-document $@

esp_iot_sdk_v1.0.1_15_04_24.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=325" --output-document $@

esp_iot_sdk_v1.0.1_b2_15_04_10.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=293" --output-document $@

esp_iot_sdk_v1.0.1_b1_15_04_02.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=276" --output-document $@

esp_iot_sdk_v1.0.0_15_03_20.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=250" --output-document $@

esp_iot_sdk_v0.9.6_b1_15_02_15.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=220" --output-document $@

esp_iot_sdk_v0.9.5_15_01_23.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=189" --output-document $@

esp_iot_sdk_v0.9.4_14_12_19.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=111" --output-document $@

esp_iot_sdk_v0.9.3_14_11_21.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=72" --output-document $@

esp_iot_sdk_v0.9.2_14_10_24.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=9" --output-document $@

$(XTDLP)/$(GMP_TAR):
	wget -c http://ftp.gnu.org/gnu/gmp/$(GMP_TAR) --output-document $(XTDLP)/$(GMP_TAR)	

$(XTDLP)/$(MPC_TAR):
	wget -c http://ftp.gnu.org/gnu/mpc/$(MPC_TAR) --output-document $(XTDLP)/$(MPC_TAR)

$(XTDLP)/$(MPFR_TAR):
	wget -c http://ftp.gnu.org/gnu/mpfr/$(MPFR_TAR) --output-document $(XTDLP)/$(MPFR_TAR)

$(XTDLP)/$(BINUTILS_DIR)/configure.ac:
#	git clone https://github.com/fpoussin/esp-binutils.git $(XTDLP)/$(BINUTILS_DIR)
	@echo "You cloned without --recursive, fetching fpoussin/esp-binutils for you."
	git submodule update --init --recursive



$(XTDLP)/$(NEWLIB_DIR)/configure.ac:
#	git clone -b xtensa https://github.com/jcmvbkbc/newlib-xtensa.git $(XTDLP)/$(NEWLIB_DIR)
	@echo "You cloned without --recursive, fetching jcmvbkbc/newlib-xtensa for you."
	git submodule update --init --recursive

$(XTDLP)/$(GCC_DIR)/configure.ac:
#	git clone https://github.com/jcmvbkbc/gcc-xtensa.git $(XTDLP)/$(GCC_DIR)
	@echo "You cloned without --recursive, fetching jcmvbkbc/gcc-xtensa for you."
	git submodule update --init --recursive

$(XTDLP)/$(LIBHAL_DIR)/configure.ac:
	@echo "You cloned without --recursive, fetching submodules for you."
	git submodule update --init --recursive


libhal: $(TOOLCHAIN)/xtensa-lx106-elf/lib/libhal.a

$(TOOLCHAIN)/xtensa-lx106-elf/lib/libhal.a: $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc $(XTDLP)/$(LIBHAL_DIR)
	make -C $(XTDLP)/$(LIBHAL_DIR) -f ../../Makefile _libhal

_libhal: $(XTDLP)/$(LIBHAL_DIR)
	autoreconf -i
	PATH=$(TOOLCHAIN)/bin:$(PATH) ./configure --host=$(TARGET) --prefix=$(TOOLCHAIN)/xtensa-lx106-elf/
	PATH=$(TOOLCHAIN)/bin:$(PATH) make
	PATH=$(TOOLCHAIN)/bin:$(PATH) make install


toolchain: $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc

$(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc: $(XTDLP) $(XTBP) get-src build-gmp build-mpfr build-mpc build-binutils build-first-stage-gcc build-second-stage-gcc build-newlib
# $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc: $(XTDLP) $(XTBP) build-gmp build-mpfr build-mpc build-binutils build-first-stage-gcc 

$(XTDLP):
	mkdir -p $(XTDLP)

$(XTBP):
	mkdir -p $(XTBP)

# GMP
$(XTDLP)/$(GMP_DIR): $(XTDLP)/$(GMP_TAR)
	mkdir -p $(XTDLP)/$(GMP_DIR)
	$(UNTAR) $(XTDLP)/$(GMP_TAR) -C $(XTDLP)/$(GMP_DIR)
	mv $(XTDLP)/$(GMP_DIR)/gmp-*/* $(XTDLP)/$(GMP_DIR)

$(XTDLP)/$(GMP_DIR)/build: $(XTDLP)/$(GMP_DIR)
	mkdir -p $(XTDLP)/$(GMP_DIR)/build/
	cd $(XTDLP)/$(GMP_DIR)/build/; ../configure --prefix=$(XTBP)/gmp --disable-shared --enable-static
	make -C $(XTDLP)/$(GMP_DIR)/build/	

$(XTBP)/gmp: $(XTDLP)/$(GMP_DIR)/build
	make install -C $(XTDLP)/$(GMP_DIR)/build/

# MPFR	
$(XTDLP)/$(MPFR_DIR): $(XTDLP)/$(MPFR_TAR)
	mkdir -p $(XTDLP)/$(MPFR_DIR)
	$(UNTAR) $(XTDLP)/$(MPFR_TAR) -C $(XTDLP)/$(MPFR_DIR)
	mv $(XTDLP)/$(MPFR_DIR)/mpfr-*/* $(XTDLP)/$(MPFR_DIR)

$(XTDLP)/$(MPFR_DIR)/build: $(XTDLP)/$(MPFR_DIR)
	mkdir -p $(XTDLP)/$(MPFR_DIR)/build
	cd $(XTDLP)/$(MPFR_DIR)/build/; ../configure --prefix=$(XTBP)/mpfr --with-gmp=$(XTBP)/gmp --disable-shared --enable-static
	make -C $(XTDLP)/$(MPFR_DIR)/build/	

$(XTBP)/mpfr: $(XTDLP)/$(MPFR_DIR)/build
	make install -C $(XTDLP)/$(MPFR_DIR)/build/

# MPC	
$(XTDLP)/$(MPC_DIR): $(XTDLP)/$(MPC_TAR)
	mkdir -p $(XTDLP)/$(MPC_DIR)
	$(UNTAR) $(XTDLP)/$(MPC_TAR) -C $(XTDLP)/$(MPC_DIR)
	mv $(XTDLP)/$(MPC_DIR)/mpc-*/* $(XTDLP)/$(MPC_DIR)


$(XTDLP)/$(MPC_DIR)/build: $(XTDLP)/$(MPC_DIR)
	mkdir -p $(XTDLP)/$(MPC_DIR)/build	
	cd $(XTDLP)/$(MPC_DIR)/build/; ../configure --prefix=$(XTBP)/mpc --with-mpfr=$(XTBP)/mpfr --with-gmp=$(XTBP)/gmp --disable-shared --enable-static
	make -C $(XTDLP)/$(MPC_DIR)/build/
	make install -C $(XTDLP)/$(MPC_DIR)/build/

$(XTBP)/mpc: $(XTDLP)/$(MPC_DIR)/build
	make install -C $(XTDLP)/$(MPC_DIR)/build/


# Binutils
$(XTDLP)/$(BINUTILS_DIR)/build: $(XTDLP)/$(BINUTILS_DIR)/configure.ac
	mkdir $(XTDLP)/$(BINUTILS_DIR)/build
	cd $(XTDLP)/$(BINUTILS_DIR)/build/; chmod +rx ../configure; ../configure --prefix=$(XTTC) --target=$(TARGET) --enable-werror=no  --enable-multilib --disable-nls --disable-shared --disable-threads --with-gcc --with-gnu-as --with-gnu-ld
	make -C $(XTDLP)/$(BINUTILS_DIR)/build/

$(XTBP)/$(BINUTILS_DIR): $(XTDLP)/$(BINUTILS_DIR)/build
	make install -C $(XTDLP)/$(BINUTILS_DIR)/build/

# GCC Step 1
$(XTDLP)/$(GCC_DIR)/build-1: $(XTDLP)/$(GCC_DIR)/configure.ac
	mkdir $(XTDLP)/$(GCC_DIR)/build-1
	cd $(XTDLP)/$(GCC_DIR)/build-1/; ../configure --prefix=$(XTTC) --target=$(TARGET) --enable-multilib --enable-languages=c --with-newlib --disable-nls --disable-shared --disable-threads --with-gnu-as --with-gnu-ld --with-gmp=$(XTBP)/gmp --with-mpfr=$(XTBP)/mpfr --with-mpc=$(XTBP)/mpc  --disable-libssp --without-headers --disable-__cxa_atexit
	make all-gcc -C $(XTDLP)/$(GCC_DIR)/build-1/
	
# GCC Step 2
$(XTDLP)/$(GCC_DIR)/build-2: $(XTDLP)/$(GCC_DIR)/configure.ac
	mkdir $(XTDLP)/$(GCC_DIR)/build-2
	cd $(XTDLP)/$(GCC_DIR)/build-2/; ../configure --prefix=$(XTTC) --target=$(TARGET) --enable-multilib --disable-nls --disable-shared --disable-threads --with-gnu-as --with-gnu-ld --with-gmp=$(XTBP)/gmp --with-mpfr=$(XTBP)/mpfr --with-mpc=$(XTBP)/mpc --enable-languages=c,c++ --with-newlib --disable-libssp --disable-__cxa_atexit
	make all-gcc -C $(XTDLP)/$(GCC_DIR)/build-2/

$(XTBP)/$(GCC_DIR): $(XTDLP)/$(GCC_DIR)/build-1 $(XTDLP)/$(GCC_DIR)/build-2
	make install-gcc -C $(XTDLP)/$(GCC_DIR)/build-1/
	make install -C $(XTDLP)/$(GCC_DIR)/build-2/
	cd $(XTTC)/bin/; ln -sf xtensa-lx106-elf-gcc xtensa-lx106-elf-cc

# Newlib
$(XTDLP)/$(NEWLIB_DIR)/build: $(XTDLP)/$(NEWLIB_DIR)/configure.ac
	mkdir $(XTDLP)/$(NEWLIB_DIR)/build
	cd $(XTDLP)/$(NEWLIB_DIR)/build/; ../configure  --prefix=$(XTTC) --target=$(TARGET) --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls
	make -C $(XTDLP)/$(NEWLIB_DIR)/build/
	
$(XTBP)/$(NEWLIB_DIR):
	make install -C $(XTDLP)/$(NEWLIB_DIR)/build/

get-src: $(XTDLP)/$(GMP_DIR) $(XTDLP)/$(MPFR_DIR) $(XTDLP)/$(MPC_DIR) $(XTDLP)/$(BINUTILS_DIR)/configure.ac $(XTDLP)/$(GCC_DIR)/configure.ac $(XTDLP)/$(NEWLIB_DIR)/configure.ac
build-gmp: $(XTDLP)/$(GMP_DIR)/build $(XTBP)/gmp
build-mpfr: build-gmp $(XTDLP)/$(MPFR_DIR)/build $(XTBP)/mpfr
build-mpc: build-gmp build-mpfr $(XTDLP)/$(MPC_DIR)/build $(XTBP)/mpc
build-binutils: build-gmp build-mpfr build-mpc $(XTDLP)/$(BINUTILS_DIR)/build $(XTBP)/$(BINUTILS_DIR)
build-first-stage-gcc: build-gmp build-mpfr build-mpc build-binutils $(XTDLP)/$(GCC_DIR)/build-1 $(XTBP)/$(GCC_DIR)
build-second-stage-gcc: build-gmp build-mpfr build-mpc build-binutils build-first-stage-gcc $(XTDLP)/$(GCC_DIR)/build-2 $(XTBP)/$(GCC_DIR)
build-newlib: build-gmp build-mpfr build-mpc build-binutils $(XTDLP)/$(NEWLIB_DIR)/build $(XTBP)/$(NEWLIB_DIR) 


clean: clean-sdk
	-rm -rf $(TOOLCHAIN)
	rm -rf $(XTDLP)/$(GMP_DIR)/build
	rm -rf $(XTDLP)/$(MPFR_DIR)/build
	rm -rf $(XTDLP)/$(MPC_DIR)/build
	rm -rf $(XTDLP)/$(BINUTILS_DIR)/build
	rm -rf $(XTDLP)/$(GCC_DIR)/build-1
	rm -rf $(XTDLP)/$(GCC_DIR)/build-2
	rm -rf $(XTDLP)/$(NEWLIB_DIR)/build

clean-sdk:
	rm -rf $(VENDOR_SDK_DIR)
	rm -rf $(VENDOR_SDK_ZIP)
	rm -rf release_note.txt
	rm -f sdk
	rm -f .sdk_patch_$(VENDOR_SDK_VERSION)
	rm -rf lx106-hal
	rm -rf build
	rm -rf bin


purge: clean
	rm -rf src

clean-sysroot:
	rm -rf $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/*
	rm -rf $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/include/*