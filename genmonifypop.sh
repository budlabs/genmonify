#!/bin/bash

ERX(){ >&2 echo "[ERROR]" "$*" && exit 1 ; }

[[ -z $1 ]] && ERX first argument should be the name of a genmonify module

msg=$(genmonify --module "$1" --get)
[[ ${msg%% *} = POLIPOP ]] || exit 1
eval "${msg#* }"
