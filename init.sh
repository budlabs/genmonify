#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
genmonify - version: 2020.11
updated: 2020-11-16 by budRich
EOB
}


# environment variables
: "${XDG_CONFIG_HOME:=$HOME/.config}"


___printhelp(){
  
cat << 'EOB' >&2
genmonify - SHORT DESCRIPTION


SYNOPSIS
--------
genmonify --help|-h
genmonify --version|-v

OPTIONS
-------

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
    --options "hv" \
    --longoptions "help,version," \
    -- "$@" || exit 98
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 





