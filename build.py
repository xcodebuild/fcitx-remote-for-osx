#!/usr/bin/env python
#  This file is part of fcitx-remote-for-osx
#  Copyright (c) 2017 fcitx-remote-for-osx's authors
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
import os
import sys
import textwrap

CC = 'clang'
BUILD_PATH = 'fcitx-remote-{}'
SOURCE_FILE = './fcitx-remote/main.m'

InputMethod = {
    'baidu-pinyin': 'com.baidu.inputmethod.BaiduIM.pinyin',
    'baidu-wubi': 'com.baidu.inputmethod.BaiduIM.wubi',
    'loginput': 'com.logcg.inputmethod.LogInputMac.LogInputMacSP',
    'loginput2': 'com.logcg.inputmethod.LogInputMac2.LogInputMac2SP',
    'macos-pinyin': 'com.apple.inputmethod.SCIM.ITABC',
    'macos-shuangpin': 'com.apple.inputmethod.SCIM.Shuangpin',
    'macos-wubi': 'com.apple.inputmethod.SCIM.WBX',
    'qingg': 'com.aodaren.inputmethod.Qingg',
    'qq-wubi': 'com.tencent.inputmethod.QQInput.QQWubi',
    'sogou-pinyin': 'com.sogou.inputmethod.sogou.pinyin',
    'squirrel-rime': 'com.googlecode.rimeime.inputmethod.Squirrel.Rime',
    'squirrel-rime-upstream': 'im.rime.inputmethod.Squirrel.Rime',
    'russian-win': 'com.apple.keylayout.RussianWin',
    'general': 'GENERAL'
}

USkeylayout = {
    'abc': 'com.apple.keylayout.ABC',
    'us': 'com.apple.keylayout.US',
    'colemak': 'com.apple.keylayout.Colemak'
}


def build(imname, uskeylayout):
    out_path = BUILD_PATH.format(imname)
    opts = ('-framework foundation -framework carbon '
            f'-D CHINESE_KEYBOARD_LAYOUT=@\\"{InputMethod[imname]}\\" '
            f'-D US_KEYBOARD_LAYOUT=@\\"{USkeylayout[uskeylayout]}\\" '
            f'-o {out_path}')
    use_cmd = f'{CC} {SOURCE_FILE} {opts}'
    print(use_cmd)

    if os.system(use_cmd):
        raise RuntimeError


def build_all(uskeylayout):
    for imname in InputMethod:
        build(imname, uskeylayout)


def clean():
    for imname in InputMethod:
        use_path = BUILD_PATH.format(imname)
        os.system(f'rm {use_path}')


def print_help():
    print(
        textwrap.dedent('''\
        Example usage:
          ./build.py clean
          ./build.py build all [EN_Keylayout (abc|us)]
          ./build.py build <InputMethod> [EN_Keylayout (abc|us)]
          '''))
    ims = '\n\t'.join(x for x in InputMethod)
    print(f"InputMethod:\n\t{ims}")


def main(action=None, inputmethod=None, us_keylayout='abc', *args):
    if action == 'clean':
        clean()
    elif action == 'build' \
        and (inputmethod in InputMethod or inputmethod == 'all') \
        and us_keylayout in USkeylayout:
        if inputmethod == 'all':
            build_all(us_keylayout)
        else:
            build(inputmethod, us_keylayout)
    else:
        print_help()


if __name__ == '__main__':
    main(*sys.argv[1:])
