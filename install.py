#!/usr/bin/env python
from __future__ import print_function
import os
import shutil
import sys

def get_file_list():
    output = []
    for dirpath, dirnames, filenames in os.walk('./home/'):
        for filename in filenames:
            output.append(filename)
    return output


def backup_file(filename):
    #TODO: Make backup directory if not exist
    #BACKUP_LOCATION = os.path.join(os.path.expanduser('~'), 'home_backup')
    BACKUP_LOCATION = filename + '.install.bak'
    shutil.copy2(filename, BACKUP_LOCATION)
    print(filename, '->', BACKUP_LOCATION)


def backup_dupes(filelist):
    print('Backup:')
    number_of_files_backed_up = 0
    for filename in filelist:
        filename_in_home = os.path.join(os.path.expanduser('~'), filename)
        if os.path.isfile(filename_in_home):
            backup_file(filename_in_home)
            number_of_files_backed_up += 1
    return number_of_files_backed_up


def copy_files(filelist):
    exec('ln -fv home/.* ~/')
    exec('ln -fv home/.oh-my-zsh/themes/*.zsh-theme ~/.oh-my-zsh/themes/')


def setup_vim():
    exec('git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle')
    exec('vim +PluginInstall +qa')


def exec(command):
    return os.system(command)


def main():
    print('Installing zsh') #TODO: Check if exist
    exec('sudo apt-get install zsh || brew install zsh || sudo yum install zsh')

    print('Installing ohmyz.sh')
    exec('sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"')
    # exec('sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')

    filelist = get_file_list()
    number_of_files_backed_up = backup_dupes(filelist)
    print(number_of_files_backed_up, 'files backed up')

    print('Linking all files from dotfiles/home')
    copy_files(filelist)
    setup_vim()
    return 0

if __name__ == '__main__':
    sys.exit(main())
