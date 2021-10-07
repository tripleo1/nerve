---
title: "Tmux cheatsheet"
date: 2017-06-08T12:26:29+03:00
tags: ["linux", "tmux"]
---

Meta key for tmux is `Ctl+b`!

### Panes
To split pane horisontal press `Ctrl+b` and `"`.
To split pane vertical press `Ctrl+b` and `%`.
Navigate through panes with `Ctrl+b` and `direction`; Where `direction` is one of the arrow keys.
Cycle through the panes with `Ctrl+b` and `o`.
Hitting `Ctrl+b` and `q` will show you numbered label on top of each pane.
To zoom pane press `Ctrl+b` and `z`.

### Windows
To create new window press `Ctrl+b` and `c`.
To switch between windows press `Ctrl+b` and `#`; Where `#` number of window.
Rename window with `Ctrl+b` and `,`.

### Sessions
List available sessions in terminal with `tmux ls`.
To attach to session write `tmux a <session name>`.
To detach from running session press `Ctrl+b` and `d`.
Rename current session with `Ctrl+b` and `$`.

### Scrolling buffer

To scroll just hit `Ctrl+b` and `[`. Navigate with arrow keys or page keys.


Yet another cool shortcut is `Ctrl+b` and `t` which print clock.

---
