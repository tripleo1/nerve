Title: Diablo 2 multiple copies
Date: 29-07-2012 13:56
Category: Other
Tags: diablo, games

This is a way to run 2 copies of D2 without any crashes on the same computer.
You will need:
* 2 CD keys for BNet
* 1 Hex editor

Instructions:
1. Install D2 with key, patch it fully to 1.11 and enter battle.net.
2. Exit Battle.net again
3. Copy your whole D2 install to another directory, eg `c:gamesdiablo2a`
3. Uninstall d2
4. Install d2 with the 2nd key

Now you have 2 installs of D2 on your computer but you can’t start a 2nd copy since D2 complains that only one copy can be run at the same time.

1. Open `d2gfx.dll` from `c:gamesdiablo2a` in the hexeditor. I used UltraEdit32 for this.
2. Search for the bytes `C0 74 45`. in Ultraedit: press `Ctrl-F` and make sure the `find ASCII` is **UNCHECKED**. Enter `C0 74 45`.
3. The cursor will jump to offset `84ceh`. Change the byte `74` to `EB`.
4. Save `d2gfx.dll` again.

Now the install with the modified `d2gfx.dll` can be started while the other one is already running. It will work fine including the usual `diablo ii.exe -w -ns`.

