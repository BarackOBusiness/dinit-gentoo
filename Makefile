PREFIX     ?= /usr
SYSCONFDIR ?= /etc
BINDIR     ?= $(PREFIX)/bin
LIBDIR     ?= $(PREFIX)/lib
LIBEXECDIR ?= $(PREFIX)/libexec
DATADIR    ?= $(PREFIX)/share
MANDIR     ?= $(DATADIR)/man/man8
SDINITDIR  ?= $(LIBDIR)/dinit.d
DINITDIR   ?= $(SYSCONFDIR)/dinit.d

BIN_PROGRAMS = modules-load

MANPAGES = modules-load.8

CONF_FILES = rc.conf

TARGETS = \
	init \
	network \
	login \
	boot

SYSTEM_SERVICES = \
	boot \
	early-aux-filesystems \
	early-aux-fsck \
	early-console \
	early-filesystems \
	early-hwclock \
	early-modules \
	early \
	early-root-fsck \
	early-root-rw \
	early-static-devnodes \
	early-udev-settle \
	early-udev-trigger \
	early-udevd	\
	init \
	login \
	network \
	recovery \
	single

SERVICES = \
	agetty-console \
	agetty-hvc0 \
	agetty-hvsi0 \
	agetty-tty1 \
	agetty-tty2 \
	agetty-tty3 \
	agetty-tty4 \
	agetty-tty5 \
	agetty-tty6 \
	agetty-ttyAMA0 \
	agetty-ttyS0 \
	agetty-ttyUSB0 \
	late-filesystems

EARLY_SCRIPTS = \
	aux-filesystems \
	common \
	console \
	filesystems \
	hwclock \
	modules \
	rcboot-stop \
	rcboot \
	root-fsck \
	static-devnodes

LATE_SCRIPTS = \
	late-filesystems

all:
	@echo "Nothing to be done here."

install:
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(DATADIR)
	install -d $(DESTDIR)$(SYSCONFDIR)
	install -d $(DESTDIR)$(MANDIR)
	install -d $(DESTDIR)$(LIBEXECDIR)/dinit/early
	install -d $(DESTDIR)$(SDINITDIR)
	install -d $(DESTDIR)$(DINITDIR)
	install -d $(DESTDIR)$(DINITDIR)/scripts
	# service targets
	for target in $(TARGETS); do \
		install -d $(DESTDIR)$(DINITDIR)/$$target.d; \
		touch $(DESTDIR)$(DINITDIR)/$$target.d/.empty; \
	done
	# config files
	for conf in $(CONF_FILES); do \
		install -m 644 etc/$$conf $(DESTDIR)$(SYSCONFDIR); \
	done
	# early scripts
	for script in $(EARLY_SCRIPTS); do \
		install -m 755 early-scripts/$$script.sh \
			$(DESTDIR)$(LIBEXECDIR)/dinit/early; \
	done
	# regular scripts
	for script in $(LATE_SCRIPTS); do \
		install -m 755 scripts/$$script.sh $(DESTDIR)$(DINITDIR)/scripts; \
	done
	# programs
	for prog in $(BIN_PROGRAMS); do \
		install -m 755 bin/$$prog $(DESTDIR)$(BINDIR); \
	done
	# manpages
	for man in $(MANPAGES); do \
		install -m 644 man/$$man $(DESTDIR)$(MANDIR); \
	done
	# system services
	for srv in $(SYSTEM_SERVICES); do \
		install -m 644 services/$$srv $(DESTDIR)$(SDINITDIR); \
	done
	# services
	for srv in $(SERVICES); do \
		install -m 644 services/$$srv $(DESTDIR)$(DINITDIR); \
	done
