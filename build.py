#!/usr/bin/python

import os
import sys

CC = 'clang'
BUILD_PATH = 'fcitx-remote-%s'
SOURCE_FILE = './fcitx-remote/main.m'
OPTS = '-framework foundation -framework carbon -DCHINNESE_KEYBOARD_LAYOUT=@\\"%s\\" -o %s'


InputMethod = {
    'baidu-pinyin': 'com.baidu.inputmethod.BaiduIM.pinyin',
    'baidu-wubi': 'com.baidu.inputmethod.BaiduIM.wubi',
    'sogou-pinyin': 'com.sogou.inputmethod.sogou.pinyin',
    'qq-wubi': 'com.tencent.inputmethod.QQInput.QQWubi',
    'squirrel-rime': 'com.googlecode.rimeime.inputmethod.Squirrel.Rime',
    'osx-pinyin': 'com.apple.inputmethod.SCIM.ITABC',
}

def build(imname):
    use_path = BUILD_PATH % imname
    use_opts = OPTS % (InputMethod[imname], use_path)
    use_cmd = '%s %s %s' % (CC, SOURCE_FILE, use_opts)
    print use_cmd
    if os.system(use_cmd) == 0:
        return imname
    else:
        return False

def build_all():
    for imname in InputMethod.iterkeys():
        if build(imname) == False:
            sys.exit(1)

def print_help():
    print './build.py build all\n./build.py clean'
    print './build.py build [im]'
    print 'im:'
    for im in InputMethod.iterkeys():
        print '\t %s' % im

def clean():
    for imname in InputMethod.iterkeys():
        use_path = BUILD_PATH % imname
        os.system('rm %s' % use_path)

if __name__ == '__main__':
    if(len(sys.argv) < 2):
        print_help()
    else:
        if sys.argv[1] == 'build':
            if sys.argv[2] == 'all':
                build_all()
            else:
                build(sys.argv[2])
        elif sys.argv[1] == 'clean':
            clean()
        else:
            print_help()
    sys.exit(0)
