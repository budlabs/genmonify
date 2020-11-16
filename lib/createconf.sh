#!/usr/bin/env bash

### createconf() function is automatically generated
### by bashbud based on the content of the conf/ directory

createconf() {
local trgdir="$1"
declare -a aconfdirs

aconfdirs=(
)

mkdir -p "$1" "${aconfdirs[@]}"

cat << 'EOCONF' > "$trgdir/module-list"
# this file will be sourced by genmonify
# specify the aliases for the modules here
# you need to know the panel-id of the modules
#
# try this sed, it should print the ID's of all genmon
# modules, starting from the left:
#
# sed -rn 's/.+name="plugin-([0-9]+)".+genmon"\/>/\1/pg' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
# 
# or try to manually find the id in the file:
# ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
#
# below is an example line, and the ID is 2 (plugin-2)
# <property name="plugin-2" type="string" value="genmon"/>
#
# below is an example alias:
# modules[mycustomAlias]=2
#
# remember to uncomment (remove the # from the beginning of the line)
# when everything is working you should be able to 
# update the plugin with a command like this:
#
# genmonify --module mycustomAlias "whatever™"
#
# you can add as many aliases as you want, 
# one module can even have multiple aliases
#
# EXAMPLE:
# -----------
# modules[moviecool]=2
# modules[news]=3
# modules[webhooked]=2

EOCONF

}
