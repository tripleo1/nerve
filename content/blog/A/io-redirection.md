---
title: "Linux I/O redirection"
date: 2017-03-22T12:24:33+03:00
tags: ["linux"]
---

|Name|Number|Description|
|-----|-----|-----|
|stdin|0|Connected to the keyboard, most programs read input from this file|
|stdout|1|Attached to the screen, and all programs send their results to this file|
|stderr|2|Programs send status/error messages to this file which is also attached to the screen|

Redirect standard output as in the example below:

```bash
$ ls -l > ls.log
```

To append the output of a command, use the `“>>” `operator.

```bash
$ ls -l >> ls.log
```

Using the file descriptor number, the output redirect command above is the same as:

```bash
$ ls -l 1> ls.log
```

You can redirect the standard error to a file as below:

```bash
$ ls -l /root/ 2>ls-error.log
$ cat ls-error.log
```

It is also possible to capture all the output of a command (both standard output and standard error) into a single file. This can be done in two possible ways by specifying the file descriptor numbers:

1. The first is a relatively old method which works as follows:
```bash
$ ls -l /root/ >ls-error.log 2>&1
```
The command above means the shell will first send the output of the ls command to the file ls-error.log (using >ls-error.log), and then writes all error messages to the file descriptor 2 (standard output) which has been redirected to the file ls-error.log (using 2>&1). Implying that standard error is also sent to the same file as standard output.

2. The second and direct method is:

```bash
$ ls -l /root/ &>ls-error.log
```

---
