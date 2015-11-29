ENV_DIR := $(PWD)

AUTOCONF_VERSION = 2.69
AUTOMAKE_VERSION = 1.11.6

PLATFORM := $(shell uname -s)

all: platform-specific
	

platform-specific: mingw

mingw: $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION)/bin/autoconf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION)/

$(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz:
	wget ftp://ftp.gnu.org/pub/gnu/autoconf/autoconf-$(AUTOCONF_VERSION).tar.xz --output-document $@

$(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz:
	wget ftp://ftp.gnu.org/pub/gnu/automake/automake-$(AUTOMAKE_VERSION).tar.xz --output-document $@

$(ENV_DIR)/autoconf-$(AUTOCONF_VERSION)/bin/autoconf: $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	echo Installing autoconf-$(AUTOCONF_VERSION)
	tar -xf $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); ./configure --prefix=/mingw
	cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); make
	cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION);  make install


$(ENV_DIR)/automake-$(AUTOMAKE_VERSION)/: $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz	
	tar -xf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz
	cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); ./configure --prefix=/mingw
	cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make
	cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make install


