#!/usr/bin/env bash

main(){

  # all non option arguments will be treated as the
  # message to display in the target genmon module
  message="$*"

  declare -A modules=([gurl]=2 [mediainfo]=10)

  # the aliasfile will override the modules array
  aliasfile=$GENMONIFY_DIR/module-list
  [[ -f $aliasfile ]] || createconf "$GENMONIFY_DIR"
  source "$aliasfile"

  # module should here have the actual panel-id
  module="${__o[module]:+${modules[${__o[module]}]}}"

  # if no module is found in the modules array
  # it is still possible to trigger an update event
  # and the first found (?) genmon module will get
  # updated
  cmd_update=(
    xfce4-panel 
    "--plugin-event=genmon${module:+-$module}:refresh:bool:true"
  )

  trg_file="$GENMONIFY_TMP_DIR/${__o[module]:-default}"
  mkdir -p "${trg_file%/*}"

  # by always printing a zero_width_space
  # character we can clear the module and get no
  # funky output if f.i. the target file is empty
  # or removed
  zero_width_space=$(printf %b '\u200b')

  if ((__o[clear])); then
    echo -n "$zero_width_space" > "$trg_file"
    exec "${cmd_update[@]}"
  elif ((__o[get])); then
    # print everyting inside <msg> tag (set with -s)
    sed -rn 's/^<msg>([^<]+)<.+/\1/p' "$trg_file"
  elif [[ -z $message${__o[image]}${__o[icon]} ]]; then
    # this is the default action that the module itself
    # should get. activated when there are no message.
    # genmonify --module MODULE_NAME
    echo -n "$zero_width_space"
    [[ -f $trg_file ]] && cat "$trg_file"
  else
    # write file and update
    op+="${__o[msg]:+<msg>${__o[msg]}</msg>$'\n'}"

    op+="<txt><span"
    op+="${__o[foreground]:+" foreground='${__o[foreground]}'"}"
    op+="${__o[background]:+" background='${__o[background]}'"}"
    op+=">${message//&/&amp;}</span></txt>"

    op+="${__o[tooltip]:+$'\n'<tool>${__o[tooltip]//&/&amp;}</tool>}"
    op+="${__o[icon]:+$'\n'<icon>${__o[icon]}</icon>}"
    op+="${__o[click]:+$'\n'<click>${__o[click]}</click>}"
    op+="${__o[iconclick]:+$'\n'<iconclick>${__o[iconclick]}</iconclick>}"
    op+="${__o[progress]:+$'\n'<bar>${__o[progress]}</bar>}"

    [[ -n ${__o[img]} && -f ${__o[img]} ]] \
      && op+=$'\n'"<img>${__o[img]}</img>"

    echo "$op" > "$trg_file"
    "${cmd_update[@]}"

    ((__o[expire-time])) && { 
      sleep "${__o[expire-time]}"
      # don't clear if the module has changed during
      # the sleep:
      [[ $op = "$(< "$trg_file")" ]] && {
        echo -n "$zero_width_space" > "$trg_file"
        exec "${cmd_update[@]}"
      }
    } &
  fi
  
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "${@}"                                     #bashbud
