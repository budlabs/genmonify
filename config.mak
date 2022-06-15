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
		echo '## options'
		cat $(CACHE_DIR)/help_table.txt
		echo '## usage'
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

MANPAGE = $(NAME).1
.PHONY: manpage
manpage: $(MANPAGE)

$(MANPAGE): config.mak $(MANPAGE_DEPS) 
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
