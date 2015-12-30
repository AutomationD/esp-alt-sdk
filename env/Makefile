


AUTOCONF_VERSION = 2.69
AUTOMAKE_VERSION = 1.11.6
MINGW_DIR := c:\tools\mingw32

PLATFORM := $(shell uname -s)

PREFIX := ""

ifneq "$(wildcard $(PWD)/env )" ""  
  ENV_DIR = $(PWD)/env
else
  ENV_DIR = $(PWD)
endif

SAFEPATH := $(TOOLCHAIN)/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/mingw/bin/:/c/tools/mingw64/bin:

all: debug platform-specific
	

mingw: /mingw /mingw/bin/autoconf /mingw/bin/automake

cygwin:
	@echo "CYGWIN ENV preps"

macos:
	@echo "Macos ENV preps"

freebsd:
	@echo "FreBSD ENV preps"

ubuntu: $(PREFIX)/bin/autoconf $(PREFIX)/bin/automake

rhel:
	@echo "RHEL ENV preps"

$(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz:
	wget ftp://ftp.gnu.org/pub/gnu/autoconf/autoconf-$(AUTOCONF_VERSION).tar.xz --output-document $@

$(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz:
	wget ftp://ftp.gnu.org/pub/gnu/automake/automake-$(AUTOMAKE_VERSION).tar.xz --output-document $@


$(PREFIX)/bin/autoconf: $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	echo Installing autoconf-$(AUTOCONF_VERSION)
	tar -xf $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); ./configure --prefix=$(PREFIX)
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); make
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); make install

$(PREFIX)/bin/automake: $(PREFIX)/bin/autoconf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz	/mingw
	tar -xf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); ./configure --prefix=$(PREFIX)
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make install
	PATH=$(SAFEPATH) cd $(PREFIX)/share/; ln -sf aclocal-1.11 aclocal
	PATH=$(SAFEPATH) cd $(PREFIX)/share/; ln -sf automake-1.11 automake

/mingw/bin/autoconf: $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	echo Installing autoconf-$(AUTOCONF_VERSION)
	tar -xf $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); ./configure --prefix=/mingw
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); make
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); make install

/mingw/bin/automake: /mingw/bin/autoconf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz	/mingw/bin/autoconf /mingw
	tar -xf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); ./configure --prefix=/mingw
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make install
#	PATH=$(SAFEPATH) cd /mingw/share/; ln -sf aclocal-1.11 aclocal
#	PATH=$(SAFEPATH) cd /mingw/share/; ln -sf automake-1.11 automake

/usr/bin/autoconf: $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	echo Installing autoconf-$(AUTOCONF_VERSION)
	tar -xf $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION).tar.xz
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); ./configure --prefix=/usr
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); make
	PATH=$(SAFEPATH) cd $(ENV_DIR)/autoconf-$(AUTOCONF_VERSION); make install

/usr/bin/automake: /usr/bin/autoconf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz	/mingw
	tar -xf $(ENV_DIR)/automake-$(AUTOMAKE_VERSION).tar.xz
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); ./configure --prefix=/usr
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make
	PATH=$(SAFEPATH) cd $(ENV_DIR)/automake-$(AUTOMAKE_VERSION); make install
	# PATH=$(SAFEPATH) cd /usr/share/; ln -s aclocal-1.11 aclocal
	# PATH=$(SAFEPATH) cd /usr/share/; ln -s automake-1.11 automake

/mingw:
	@echo "/mingw directory not found, mounting"
	mount $(MINGW_DIR) /mingw

/mingw/bin/py2exe:
	wget http://sourceforge.net/projects/py2exe/files/py2exe/0.6.9/py2exe-0.6.9.win32-py2.7.exe/download --output-document $@

debug:
	@echo "----------------------------------------------------"
	@echo "Outputting debug info. Makefiles are so Makefiles..."	
	@echo "PATH: $(PATH)"
	@echo "ENV_DIR: $(ENV_DIR)"
	@echo "----------------------------------------------------"

platform-specific:
	@echo "Performing platform-specific actions"

clean:
	rm -rf $(ENV_DIR)/automake*
	rm -rf $(ENV_DIR)/autoconf*
	
ifeq ($(OS),Windows_NT)
  ifneq (,$(findstring MINGW32,$(PLATFORM)))    
		@echo "Detected: MinGW32."
		$(MAKE) mingw
  else
	    ifneq (,$(findstring CYGWIN,$(PLATFORM)))
				@echo "Detected: CYGWIN"
				$(MAKE) cygwin
	    endif
  endif
else  
  ifeq ($(PLATFORM),Darwin)    
			@echo "Detected: MacOS"
			$(MAKE) macos
  endif
  ifeq ($(PLATFORM),Linux)
			@echo "Detected: Linux"
      ifneq ($(strip $(TRAVIS_BUILD_DIR)),)
				@echo "Detected TravisCI"
				$(MAKE) ubuntu PREFIX=$(HOME)
      else
				$(MAKE) ubuntu
      endif
  endif
  ifeq ($(PLATFORM),FreeBSD)
      @echo "Detected: FreeBSD"
      $(MAKE) freebsd
  endif
endif

