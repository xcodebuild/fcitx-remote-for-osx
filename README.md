fcitx-remote OS X
=================

## fcitx-remote

fcitx-remote is a tool for control fcitx state via console. Users in
Linux use it for interaction with their vim or emacs to avoid being
interrupted by input method.

## Plugins

-   Vim: [fcitx.vim - keep and restore fcitx state when
    leaving/re-entering insert mode: vim
    online](http://www.vim.org/scripts/script.php?script_id=3764)
    The new version of this plugin uses socket to communicate fcitx which is
    not emulated by current version of fcitx-remote-osx, so you have to use
    the backported version under the directory [so/fcitx.vim](https://github.com/lilydjwg/fcitx.vim/blob/master/so/fcitx.vim) of [lilydjwg/fcitx.vim](https://github.com/lilydjwg/fcitx.vim).
    
    Also available as a stand repo at [CodeFalling/fcitx-vim-osx](https://github.com/CodeFalling/fcitx-vim-osx)
    
-   Emacs:
    [cute-jumper/fcitx.el](https://github.com/cute-jumper/fcitx.el)
    . Due to the limits of the Wubi Xing input source, you may not use Emacs with it.

## How this works

fcitx-remote for OS X dosen't rely on fcitx at all. It is just a small
program which responds to fcitx.el etc. just like it's really a fcitx-remote in
GNU/Linux.

You can choose your Chinese input method and English layout(or others)
in compilation.

## Install

```bash
git clone https://github.com/dangxuandev/fcitx-remote-for-osx -b feature/special-input-method
cd fcitx-remote-for-osx
./build.py build sogou-pinyin
cp ./fcitx-remote-bin /usr/local/bin/fcitx-remote


## fcitx-remote -o
## Should switch to your Chinese input method
```

## System Settings for methods other than general

None.

## System Settings for GENERAL method only

Set your shortcut for `Select next source in input menu` to `Ctrl-Shift-z`.

![preview](https://cloud.githubusercontent.com/assets/5436704/15090907/60f3cc0a-146a-11e6-9f32-8128d1e2a339.png)

And set your English input method to `US`（美式英语）

![preview](https://cloud.githubusercontent.com/assets/5436704/13461653/d1404578-e0bd-11e5-8326-f7ca07558964.png)

Enjoy!
