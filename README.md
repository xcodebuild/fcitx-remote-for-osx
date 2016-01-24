Table Of Contents
====================================================================

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [fcitx-remote OS X](#fcitx-remote-os-x)
  - [fcitx-remote](#fcitx-remote)
  - [Plugins](#plugins)
  - [How this works](#how-this-works)
- [Install](#install)
  - [brew](#brew)
  - [Manual Install](#manual-install)
  - [Prebuild binary](#prebuild-binary)
- [Trouble shooting](#trouble-shooting)
- [TODOS](#todos)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

fcitx-remote OS X
=================

fcitx-remote
------------

fcitx-remote is a tool for control fcitx state via console.Users in
Linux use it for interact with their vim or emacs to avoid being
interrupted by input method.

Plugins
-------

-   ~~Vim: [fcitx.vim - keep and restore fcitx state when
    leaving/re-entering insert mode : vim
    online](http://www.vim.org/scripts/script.php?script_id=3764) (not
    supported for now,this is next to do)~~
-   Vim:
    [CodeFalling/fcitx-vim-osx](https://github.com/CodeFalling/fcitx-vim-osx)
    ,this is a modified version `fcitx.vim` works well with
    `fcitx-remote-osx`.Also works with `fcitx` in Linux.
-   Emacs:
    [cute-jumper/fcitx.el](https://github.com/cute-jumper/fcitx.el)

How this works
--------------

fcitx-remote for OS X dosen't reply on fcitx at all.It just a small
program respond to fcitx.el etc just like it's really fcitx-remote in
Linux.

You can choose your Chinese input method and English layout(or others)
in compile.

Install
=======

brew
----

```bash
brew install fcitx-remote-for-osx --with-input-method=baidu-pinyin
```

`--with-input-method=baidu-pinyin` means install for Baidu-pinyin Input
Method.

You can use `brew info fcitx-remote-for-osx` to get more options info
for input method support.

```bash
--with-input-method=
  Select input method: baidu-pinyin(default), baidu-wubi, sogou-pinyin, qq-wubi, squirrel-rime, osx-pinyin
```

Manual Install
--------------

```bash
git clone https://github.com/CodeFalling/fcitx-remote-for-osx
cd fcitx-remote-for-osx
xcodebuild GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS CHINNESE_KEYBOARD_LAYOUT=@\"com.baidu.inputmethod.BaiduIM.pinyin\"' install
```

`com.baidu.inputmethod.BaiduIM.pinyin` is imname of Baidu Pinyin
inputmethod.

You can use `fcitx-remote -n` to get imname of current inputmethod.

Inputmethod   | imname
------------- | --------------------------------------------------
Baidu Pinyin  | com.baidu.inputmethod.BaiduIM.pinyin
Baidu Wubi    | com.baidu.inputmethod.BaiduIM.wubi
Sougou Pinyin | com.sogou.inputmethod.sogou.pinyin
QQ Wubi       | com.tencent.inputmethod.QQInput.QQWubi
Squirrel Rime | com.googlecode.rimeime.inputmethod.Squirrel.Rime
OS X Pinyin   | com.apple.inputmethod.SCIM.ITABC
Qingg Wubi    | com.aodaren.inputmethod.Qingg

Feel free to perfecting this table,issue or pull&requests is fine.

Prebuild binary
---------------

If you don't want to install XCode.You can also download pre-build
binary from
~~[https://github.com/CodeFalling/fcitx-remote-for-osx/releases/tag/0.0.1，unzip](https://github.com/CodeFalling/fcitx-remote-for-osx/releases/tag/0.0.1，unzip)
and~~ <https://github.com/CodeFalling/fcitx-remote-for-osx/tree/binary>
,then rename `fcitx-remote` and copy to `/usr/local/bin/`.

Please let me know if something not work.

Trouble shooting
================

~~My emacs hangs when I press `C-xC-f` in my spacemacs with this project
and `fcitx.el`.Actually I don't know why,but `(fcitx-prefix-keys-setup)`
and `(fcitx-prefix-keys-turn-on)` cause this. Good news is we just now
need them in OS X beacuse most inputmethod in OS X dosen't block second
key like fcitx. So just **don't** use them.~~

-   My Emacs got hanged when press C-x C-f

Just add `(setq shell-file-name "bash")` to your `.emacs`.

TODOS
=====

- [X] fcitx.vim support
