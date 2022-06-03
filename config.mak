NAME         := genmonify
CREATED      := 2020-11-16
UPDATED      := 2022-06-03
DESCRIPTION  := precision control for xfce4-panels genmon plugin
VERSION      := 2022.06.03.1
AUTHOR       := budRich
ORGANISATION := budlabs
CONTACT      := https://github.com/budlabs/genmonify
USAGE        := $(NAME) [OPTIONS]

LICENSE      := BSD-2-Clause

# CUSTOM_TARGETS += README.md

README_DEPS  =                  \
	$(DOCS_DIR)/readme_banner.md  \
	$(DOCS_DIR)/readme_install.md \
	$(CACHE_DIR)/help_table.txt   \
	$(DOCS_DIR)/description.md    \
	$(DOCS_DIR)/readme_footer.md

README.md: config.mak $(README_DEPS)
	@$(info making $@)
	{
		echo "# $(NAME) - $(DESCRIPTION)"
		cat $(DOCS_DIR)/readme_banner.md
		cat $(DOCS_DIR)/readme_install.md
		cat $(DOCS_DIR)/description.md
		cat $(DOCS_DIR)/readme_footer.md
		cat $(DOCS_DIR)/releasenotes/0_next.md

	} > $@

MANPAGE_DEPS =                       \
	$(CACHE_DIR)/synopsis.txt          \
	$(CACHE_DIR)/help_table.txt        \
	$(CACHE_DIR)/long_help.md          \
	$(DOCS_DIR)/description.md  \
	$(DOCS_DIR)/manpage_environ.md     \
	$(CACHE_DIR)/copyright.txt

# CUSTOM_TARGETS += $(MANPAGE_OUT)
MANPAGE_OUT = $(MANPAGE)
.PHONY: manpage
manpage: $(MANPAGE_OUT)

$(MANPAGE_OUT): config.mak $(MANPAGE_DEPS) 
	@$(info making $@)
	uppercase_name=$(NAME)
	uppercase_name=$${uppercase_name^^}
	{
		# this first "<h1>" adds "corner" info to the manpage
		echo "# $$uppercase_name "           \
				 "$(manpage_section) $(UPDATED)" \
				 "$(ORGANISATION) \"User Manuals\""

		# main sections (NAME|OPTIONS..) should be "<h2>" (##), sub (###) ...
	  printf '%s\n' '## NAME' \
								  '$(NAME) - $(DESCRIPTION)'

		echo "## SYNOPSIS"
		sed 's/^/    /g' $(CACHE_DIR)/synopsis.txt
		echo "## USAGE"
		cat $(DOCS_DIR)/description.md
		echo "## OPTIONS"
		sed 's/^/    /g' $(CACHE_DIR)/help_table.txt
		cat $(CACHE_DIR)/long_help.md
		cat $(DOCS_DIR)/manpage_environ.md

		printf '%s\n' '## CONTACT' \
			"Send bugs and feature requests to:  " "$(CONTACT)/issues"

		printf '%s\n' '## COPYRIGHT'
		cat $(CACHE_DIR)/copyright.txt

	} | go-md2man > $@




installed_manpage    = $(DESTDIR)$(PREFIX)/share/man/man$(manpage_section)/$(MANPAGE)
installed_script    := $(DESTDIR)$(PREFIX)/bin/$(NAME)
installed_license   := $(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/$(LICENSE)

install: all
	install -Dm644 $(MANPAGE_OUT) $(installed_manpage)
	install -Dm644 LICENSE $(installed_license)
	install -Dm755 $(MONOLITH) $(installed_script)

uninstall:
	@for f in $(installed_script) $(installed_manpage) $(installed_license); do
		[[ -f $$f ]] || continue
		echo "rm $$f"
		rm "$$f"
	done
