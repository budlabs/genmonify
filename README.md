# genmonify - precision control for xfce4-panels genmon plugin 

I created this to replicate the functionality I got with
**polybar** hook modules and [polify] in the XFCE panel with
the [genmon] plugin.

## installation

If you use **Arch Linux** you can get **genmonify** from
[AUR].   all you need is the `genmonify` script in your
PATH. Use the Makefile to do a systemwide installation of
both the script and the manpage.  

(*configure the installation destination in the Makefile,
if needed*)

```
$ git clone https://github.com/budlabs/genmonify.git
$ cd genmonify
# make install
$ genmonify -v
genmonify - version: 2020.11.16.0
updated: 2020-11-16 by budRich
```


[polify]: https://github.com/budlabs/polify
[genmon]: https://gitlab.xfce.org/panel-plugins/xfce4-genmon-plugin
[AUR]: https://aur.archlinux.org/packages/genmonify/

usage
-----

To make genmonify (and genmon) somewhat usable you need to
do two things:  
1. set up one or more genmon plugins/modules in your
xfce4-panel  
2. set up aliases for these modules.  

The first step is easy, just add a genmon module to your
panel and open its properties dialog. There as the
**command** enter:  
`genmonify --module NAME`  
where NAME can be anything you want. Also be sure to set
the **Period** (interval) to max value of 86400 seconds
(24h).

The second step is a little bit trickier. First execute
`genmonify` without any arguments. This should create an
example *alias-file*. The default location for this file is
**~/.config/genmonify/module-list** In that file there are
instructions for how to set the aliases for the modules.
**genmonify** updates the modules by sending the following
command:  
`xfce4-panel --plugin-event=genmon-ID:refresh:bool:true`  

Where ID should be replaced with the actual plugin-id. You
can find the plugin-id in the file:  


**~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml**  
find lines that looks like this (search for "*genmon*"):  
`<property name="plugin-2" type="string" value="genmon"/>`

The following `sed` command printed all genmon plugin ID's
in my panel:  

```
sed -rn 's/.+name="plugin-([0-9]+)".+genmon"\/>/\1/pg' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
```  


Lets say we have two genmon plugins, and their ID's are
**2** and **10**. And they have the following commands set
in their respective properties:  
2: `genmonify --module mediainfo`  
10: `genmonify --module internet`  

we should then add the following lines to the **module-list
file**:  
```
modules[mediainfo]=2
modules[internet]=10
```



When genmonify is executed with only the `--module
MODULE_NAME` option, all it will do is `cat` the content of
the file: `/tmp/genmonify/MODULE_NAME` . When this is done
from a genmon plugin in the panel, it will set the plugins
text **based** on the content of the file.  

Any arguments to the `genmonify` command that doesn't
belong to an option, will get redirected (and formatted if
needed or requested) to `/tmp/genmonify/MODULE_NAME`. Then
the command `xfce4-panel
--plugin-event=genmon-ID:refresh:bool:true`  will get
executed, causing the module to get updated.

EXAMPLE:  

```
$ genmonify --module mediainfo testing one three four
```


this will first create (or overwrite) the file:
/tmp/genmonify/mediainfo with the single line: testing one
three four

then the command:  `xfce4-panel
--plugin-event=genmon-2:refresh:bool:true`  
is automatically executed, which will update the  plugin
and the **Command** set in the properties  will run again:
(`genmonify --module mediainfo`), which in turn will update
the module with the string: "testing one three four"


The `--expire-time SECONDS` option can be used to clear the
module when SECONDS have passed. It is also possible to
manually clear a module with the `--clear` option.  

genmonify is shipped with the script **genmonifypop**,
which can be used to execute commands on the `--msg`line. It
will only execute a command if it is prefixed with the word
**POLIPOP**. And the first argument to **genmonifypop**
needs to be the name of the module, it is sweet to bind
genmonifypop to a hotkey...


```
$ genmonify --module genmonifyModule1 --msg "POLIPOP notify-send 'hello pop'" hello guy
$ genmonifypop genmonifyModule1
```


In the example below you can see how `--msg` and `--get`
can be used to keep track and toggle a modules state.  

`genmonifymodetoggler.sh`  

``` shell
#!/bin/bash

thisscript="$(readlink -f "$0")"

if [[ $(genmonify --module genmonifyModule1 --get) = mode1 ]]; then
    genmonify --module genmonifyModule1   \
           --iconclick "$thisscript"      \
           --foreground '#00FF00'         \
           --icon dialog-warning          \
           --msg "mode2"                  \
           this is mode two
else 
    genmonify --module genmonifyModule1   \
           --iconclick "$thisscript"      \
           --foreground '#FF0000'         \
           --icon dialog-warning          \
           --msg "mode1"                  \
           this is mode one
fi
```


options
-------

```text
genmonify [--module|-o MODULE_ALIAS] [OPTIONS] [MESSAGE]
genmonify [--module|-o MODULE_ALIAS] [--icon|-i ICON_NAME] [--img|-I IMAGE] [--tooltip|-l PANGO] [--progress|-p PERCENTAGE] [--click|-C COMMAND] [--iconclick|-c COMMAND] [--expire-time|-t SECONDS] [--foreground|-f COLOR] [--background|-b COLOR] [--msg|-s MESSAGE] [MESSAGE]
genmonify [--module|-o MODULE_ALIAS] --clear|-x
genmonify [--module|-o MODULE_ALIAS] --get|-g
genmonify --help|-h
genmonify --version|-v
```


`--module`|`-o` MODULE_ALIAS  
Name of target module

`--icon`|`-i` ICON_NAME  
Sets the `<icon>` to use. use the icon name, not the full
path. And it will use the global icon-theme.

`--img`|`-I` IMAGE  
Sets the `<img>` to use. Full path to an image to prefix
the label with.

`--tooltip`|`-l` PANGO  
Text to display in the tooltip, pango markup can be used
for style and color.

`--progress`|`-p` PERCENTAGE  
Percentage to display in the progressbar.

`--click`|`-C` COMMAND  
COMMAND will be executed when the **IMAGE** is clicked.

`--iconclick`|`-c` COMMAND  
COMMAND will be executed when the **ICON** is clicked.

`--expire-time`|`-t` SECONDS  
If set module will get cleared after SECONDS

`--foreground`|`-f` COLOR  
color value for MESSAGE foreground color.

`--background`|`-b` COLOR  
color value for MESSAGE background color.

`--msg`|`-s` MESSAGE  
This string will not be visible in the module. But stored
in the modules file inside `<msg>` tags. The string can be
retrieved with the `--get` option.

`--clear`|`-x`  
Clears the module.

`--get`|`-g`  
Prints the content of target modules `<msg>` if there is
any.

`--help`|`-h`  
Show help and exit.

`--version`|`-v`  
Show version and exit.

## updates

#### 2020.11.16

Initial release.


## license

**genmonify** is licensed with the **BSD-2-CLAUSE license**


