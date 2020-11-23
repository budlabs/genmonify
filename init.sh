#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
genmonify - version: 2020.11.23.0
updated: 2020-11-23 by budRich
EOB
}


# environment variables
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${GENMONIFY_DIR:=$XDG_CONFIG_HOME/genmonify}"
: "${GENMONIFY_TMP_DIR:=/tmp/genmonify}"


___printhelp(){
  
cat << 'EOB' >&2
genmonify - precision control for xfce4-panels genmon plugin


SYNOPSIS
--------
genmonify [--module|-o MODULE_ALIAS] [OPTIONS] [MESSAGE]
genmonify [--module|-o MODULE_ALIAS] [--icon|-i ICON_NAME] [--img|-I IMAGE] [--tooltip|-l PANGO] [--progress|-p PERCENTAGE] [--click|-C COMMAND] [--iconclick|-c COMMAND] [--expire-time|-t SECONDS] [--foreground|-f COLOR] [--background|-b COLOR] [--msg|-s MESSAGE] [MESSAGE]
genmonify [--module|-o MODULE_ALIAS] --clear|-x
genmonify [--module|-o MODULE_ALIAS] --get|-g
genmonify --help|-h
genmonify --version|-v

OPTIONS
-------

--module|-o MODULE_ALIAS  
Name of target module


--icon|-i ICON_NAME  
Sets the <icon> to use. use the icon name, not
the full path. And it will use the global
icon-theme.


--img|-I IMAGE  
Sets the <img> to use. Full path to an image to
prefix the label with.


--tooltip|-l PANGO  
Text to display in the tooltip, pango markup can
be used for style and color.


--progress|-p PERCENTAGE  
Percentage to display in the progressbar.


--click|-C COMMAND  
COMMAND will be executed when the IMAGE is
clicked.


--iconclick|-c COMMAND  
COMMAND will be executed when the ICON is
clicked.


--expire-time|-t SECONDS  
If set module will get cleared after SECONDS


--foreground|-f COLOR  
color value for MESSAGE foreground color.


--background|-b COLOR  
color value for MESSAGE background color.


--msg|-s MESSAGE  
This string will not be visible in the module.
But stored in the modules file inside <msg> tags.
The string can be retrieved with the --get option.


--clear|-x  
Clears the module.


--get|-g  
Prints the content of target modules <msg> if
there is any.


--help|-h  
Show help and exit.


--version|-v  
Show version and exit.

EOB
}


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

declare -A __o
options="$(
  getopt --name "[ERROR]:genmonify" \
    --options "o:i:I:l:p:C:c:t:f:b:s:xghv" \
    --longoptions "module:,icon:,img:,tooltip:,progress:,click:,iconclick:,expire-time:,foreground:,background:,msg:,clear,get,help,version," \
    -- "$@" || exit 98
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --module     | -o ) __o[module]="${2:-}" ; shift ;;
    --icon       | -i ) __o[icon]="${2:-}" ; shift ;;
    --img        | -I ) __o[img]="${2:-}" ; shift ;;
    --tooltip    | -l ) __o[tooltip]="${2:-}" ; shift ;;
    --progress   | -p ) __o[progress]="${2:-}" ; shift ;;
    --click      | -C ) __o[click]="${2:-}" ; shift ;;
    --iconclick  | -c ) __o[iconclick]="${2:-}" ; shift ;;
    --expire-time | -t ) __o[expire-time]="${2:-}" ; shift ;;
    --foreground | -f ) __o[foreground]="${2:-}" ; shift ;;
    --background | -b ) __o[background]="${2:-}" ; shift ;;
    --msg        | -s ) __o[msg]="${2:-}" ; shift ;;
    --clear      | -x ) __o[clear]=1 ;; 
    --get        | -g ) __o[get]=1 ;; 
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 





