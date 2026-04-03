#!/bin/bash

update_module() {
  dbus-send --session --print-reply --dest=org.freedesktop.DBus /  \
                   org.freedesktop.DBus.GetConnectionUnixProcessID \
                   string:org.xfce.Panel > /dev/null 2>&1          \
    || ERX "Xfce-panel not avialable"

  # if no module is found in the modules array
  # it is still possible to trigger an update event
  # and the first found (?) genmon module will get
  # updated
  > /dev/null 2>&1 nohup env xfce4-panel \
    "--plugin-event=genmon${module:+-$module}:refresh:bool:true" &
}
