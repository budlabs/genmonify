#!/bin/bash

listall() {

  local file
  file=$XDG_CONFIG_HOME/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

  [[ -f $file ]] || ERX "$file not found"

  awk '
    # <property name="plugin-23" type="string" value="genmon"/>
    # use these properties to identify all genmon modules
    # store ID in genmons array
    #
    match($0,/.+name="plugin-([0-9]+)".+genmon"\/>/,ma) \
      { genmons[ma[1]]=1 }


    # <property name="plugin-ids" type="array">
    #   <value type="int" value="20"/>
    #   ...
    # </property>
    # plugin-ids array, contain the order of plugins
    # print value (padded with space) if it stored in genmons array
    #
    match($0,/<value type="int" value="([0-9]+)"\/>/,ma) \
      && (genmons[ma[1]]) { printf("%-6s",ma[1]) }

    END {print ""}

  # since the plugin-ids array appear before we know
  # the type the IDs refer to. We parse the file twice.
  #
  ' "$file" "$file"
  
}


