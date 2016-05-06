Table Of Contents
====================================================================

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [fcitx-remote OS X](#fcitx-remote-os-x)
  - [fcitx-remote](#fcitx-remote)
  - [Plugins](#plugins)
  - [How this works](#how-this-works)
- [Install](#install)
  - [Using Homebrew](#using-homebrew)
  - [Manual Install](#manual-install)
  - [Prebuilt binaries](#prebuilt-binaries)
- [Troubleshooting](#troubleshooting)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

fcitx-remote OS X
=================

fcitx-remote
------------

fcitx-remote is a tool for control fcitx state via console. Users in
Linux use it for interaction with their vim or emacs to avoid being
interrupted by input method.

Plugins
-------

-   Vim: [fcitx.vim - keep and restore fcitx state when
    leaving/re-entering insert mode: vim
    online](http://www.vim.org/scripts/script.php?script_id=3764)
    The new version of this plugin uses socket to communicate fcitx which is
    not emulated by current version of fcitx-remote-osx, so you have to use
    the backported version under the directory [so/fcitx.vim](https://github.com/lilydjwg/fcitx.vim/blob/master/so/fcitx.vim) of [lilydjwg/fcitx.vim](https://github.com/lilydjwg/fcitx.vim).
-   ~~Vim:
    [CodeFalling/fcitx-vim-osx](https://github.com/CodeFalling/fcitx-vim-osx)
    ,this is a modified version `fcitx.vim` which works well with
    `fcitx-remote-osx`. Also works with `fcitx` in Linux. Now merged into the
    previous one under [so/fcitx.vim](https://github.com/lilydjwg/fcitx.vim/blob/master/so/fcitx.vim).~~
-   Emacs:
    [cute-jumper/fcitx.el](https://github.com/cute-jumper/fcitx.el)
    . Due to the limits of the Wubi Xing input source, you may not use Emacs with it.

How this works
--------------

fcitx-remote for OS X dosen't rely on fcitx at all. It is just a small
program which responds to fcitx.el etc. just like it's really a fcitx-remote in
GNU/Linux.

You can choose your Chinese input method and English layout(or others)
in compilation.

Install
=======

Using Homebrew
----

```bash
brew install fcitx-remote-for-osx --with-input-method=pinyin
```

`--with-input-method=baidu-pinyin` means install for Baidu-pinyin Input
Method.

You can use `brew info fcitx-remote-for-osx` to get more options info
for input method support.

```bash
--with-input-method=
  Select input method: baidu-pinyin(default), baidu-wubi, sogou-pinyin, qq-wubi, squirrel-rime, osx-pinyin, osx-wubi
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

If you are using ABC instead of US, please replace it with the US Keyboard.

You can use `fcitx-remote -n` to get imname of current inputmethod.

Inputmethod   | imname
------------- | --------------------------------------------------
Baidu Pinyin  | com.baidu.inputmethod.BaiduIM.pinyin
Baidu Wubi    | com.baidu.inputmethod.BaiduIM.wubi
Sougou Pinyin | com.sogou.inputmethod.sogou.pinyin
QQ Wubi       | com.tencent.inputmethod.QQInput.QQWubi
Squirrel Rime | com.googlecode.rimeime.inputmethod.Squirrel.Rime
OS X Pinyin   | com.apple.inputmethod.SCIM.ITABC
OS X Wubi     | com.apple.inputmethod.SCIM.WBX
Qingg Wubi    | com.aodaren.inputmethod.Qingg

Feel free to improve this table, issue or pull requests is fine.

Prebuilt binaries
---------------

If you don't want to install XCode, You can also download the pre-built
binaries from
~~[https://github.com/CodeFalling/fcitx-remote-for-osx/releases/tag/0.0.2，unzip](https://github.com/CodeFalling/fcitx-remote-for-osx/releases/tag/0.0.2，unzip)
and~~ <https://github.com/CodeFalling/fcitx-remote-for-osx/tree/binary>
, then rename to `fcitx-remote` and copy to `/usr/local/bin/`.

Please let me know if anything does not work.

Troubleshooting
================

~~My emacs hangs when I press `C-x C-f` in my spacemacs with this project
and `fcitx.el`. Actually I don't know why, but `(fcitx-prefix-keys-setup)`
and `(fcitx-prefix-keys-turn-on)` cause this. Good news is we just now
need them in OS X beacuse most inputmethod in OS X dosen't block second
key like fcitx. So just **don't** use them.~~

-   My Emacs got hanged when press C-x C-f

Just add `(setq shell-file-name "bash")` to your `.emacs`.

-   fcitx-remote -t don't work

Ensure you have added `com.apple.keylayout.US` into input method source.

![keylayout](https://cloud.githubusercontent.com/assets/5436704/13461653/d1404578-e0bd-11e5-8326-f7ca07558964.png)
