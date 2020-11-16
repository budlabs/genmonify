PROGNM  ?= genmonify
PREFIX  ?= /usr
BINDIR  ?= $(PREFIX)/bin
SHRDIR  ?= $(PREFIX)/share
MANDIR  ?= $(SHRDIR)/man/man1

MANPAGE  = $(PROGNM).1

install:
		install -Dm755 $(PROGNM)  -t $(DESTDIR)$(BINDIR)
		install -Dm644 $(MANPAGE) -t $(DESTDIR)$(MANDIR)
		install -Dm644 LICENSE    -t $(DESTDIR)$(SHRDIR)/licenses/$(PROGNM)
.PHONY: install

uninstall:
	rm $(DESTDIR)$(BINDIR)/$(PROGNM)
	rm $(DESTDIR)$(MANDIR)/$(MANPAGE)
	rm -rf $(DESTDIR)$(SHRDIR)/licenses/$(PROGNM)
.PHONY: uninstall
