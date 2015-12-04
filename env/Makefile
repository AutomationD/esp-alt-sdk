ENV_DIR := $(PWD)

AUTOCONF_VERSION = 2.69
AUTOMAKE_VERSION = 1.11.6

PLATFORM := $(shell uname -s)

SAFEPATH := $(TOOLCHAIN)/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/mingw/bin/:/c/tools/mingw64/bin

all: platform-specific
	

platform-specific: mingw

mingw: /mingw /mingw/bin/autoconf /mingw/bin/automake

cygwin:
	@echo "CYGWIN ENV preps"

macos:
	@echo "Macos ENV preps"
ubuntu:
	@echo "Ubuntu ENV preps"

rhel:
	@echo "RHEL ENV preps"

$(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz:
	wget ftp://ftp.gnu.org/pub/gnu/autoconf/autoconf-$(AUTOCONF_VERSION).tar.xz --output-document $@

$(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz:
	wget ftp://ftp.gnu.org/pub/gnu/automake/automake-$(AUTOMAKE_VERSION).tar.xz --output-document $@

/mingw/bin/autoconf: $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	echo Installing autoconf-$(AUTOCONF_VERSION)
	tar -xf $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); ./configure --prefix=/mingw
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); make
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); make install
	PATH=$(SAFEPATH) cd /mingw/share/; ln -s aclocal-1.11 aclocal



/mingw/bin/automake: /mingw/bin/autoconf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz	
	tar -xf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); ./configure --prefix=/mingw
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make install
	PATH=$(SAFEPATH) cd /mingw/share/; ln -s automake-1.11 automake

/mingw:
	@echo "/mingw directory not found, mounting"
	mount $(MINGW_DIR) /mingw	
