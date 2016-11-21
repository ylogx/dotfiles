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
    execute('ln -fv home/.* ~/')
    execute('ln -fv home/.oh-my-zsh/themes/*.zsh-theme ~/.oh-my-zsh/themes/')


def setup_vim():
    execute('git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle')
    execute('vim +PluginInstall +qa')


def extra_stuff():
    try_to_install('git')
    try_to_install('tmux')
    try_to_install('tree')
    try_to_install('cloc')
    try_to_install('watch')
    try_to_install('tig')
    try_to_install('gnupg2')    # ssh-agent caching across terminals
    try_to_install('python3')
    try_to_install('pygments')


def try_to_install(software):
    ''' Try very hard to install something '''
    execute('brew install ' + software +
            ' || sudo apt-get install ' + software +
            ' || sudo yum install ' + software +
            ' || pip install ' + software +
            ' || sudo pip install ' + software)


def execute(command):
    return os.system(command)


def main():
    print('Installing zsh') #TODO: Check if exist
    try_to_install('zsh')

    print('Installing ohmyz.sh')
    execute('sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"')
    # execute('sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')

    filelist = get_file_list()
    number_of_files_backed_up = backup_dupes(filelist)
    print(number_of_files_backed_up, 'files backed up')

    print('Linking all files from dotfiles/home')
    copy_files(filelist)

    setup_vim()
    extra_stuff()
    return 0

if __name__ == '__main__':
    sys.exit(main())
