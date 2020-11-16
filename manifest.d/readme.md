# readme_banner

I created this to replicate the functionality I
got with **polybar** hook modules and [polify] in
the XFCE panel with the [genmon] plugin.

# readme_install

If you use **Arch Linux** you can get
**genmonify** from [AUR].   all you need is the
`genmonify` script in your PATH. Use the Makefile
to do a systemwide installation of both the script
and the manpage.  

(*configure the installation destination in the Makefile, if needed*)

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
