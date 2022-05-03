NAME         := genmonify
CREATED      := 2020-11-16
DESCRIPTION  := precision control for xfce4-panels genmon plugin
VERSION      := 2020.11.24.2
AUTHOR       := budRich
ORGANISATION := budlabs
CONTACT      := https://github.com/budlabs/genmonify
USAGE        := $(NAME) [OPTIONS]

MANPAGE     := $(NAME).1
README      := README.md
LICENSE     := LICENSE

MANPAGE_LAYOUT =                 \
	$(DOCS_DIR)/manpage_banner.md  \
	$(CACHE_DIR)/synopsis.txt      \
	$(DOCS_DIR)/manpage_options.md \
	$(CACHE_DIR)/help_table.txt    \
	$(CACHE_DIR)/long_help.md      \
	$(DOCS_DIR)/description.md     \
	$(DOCS_DIR)/manpage_footer.md  \
	LICENSE

README_LAYOUT  =                \
	$(DOCS_DIR)/readme_banner.md  \
	$(DOCS_DIR)/readme_install.md \
	$(CACHE_DIR)/help_table.txt   \
	$(DOCS_DIR)/description.md    \
	$(DOCS_DIR)/readme_footer.md  \
	$(DOCS_DIR)/releasenotes/0_next.md


installed_manpage    = $(DESTDIR)$(PREFIX)/share/man/man$(manpage_section)/$(MANPAGE)
installed_script    := $(DESTDIR)$(PREFIX)/bin/$(NAME)
installed_license   := $(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/$(LICENSE)

install: all
	install -Dm644 $(MANPAGE_OUT) $(installed_manpage)
	install -Dm644 $(LICENSE) $(installed_license)
	install -Dm755 $(MONOLITH) $(installed_script)

uninstall:
	@for f in $(installed_script) $(installed_manpage) $(installed_license); do
		[[ -f $$f ]] || continue
		echo "rm $$f"
		rm "$$f"
	done
