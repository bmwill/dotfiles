#!/bin/bash

#####################################################################
#   install.sh                                                      #
#   This script creates symlinks from the home directory to         #
#   dotfiles included in dotfiles/                                  #
#                                                                   #
#   Author: Brandon Williams                                        #
#####################################################################

files="vim bash/bashrc bash/bash_profile git/gitignore"

curdir=`pwd`
backupdir=~/dotfiles_bkup

# Function used to backup old dotfiles
#
function backup {
    oldFile=~/.$1
    # check if the file or directory exists
    #
    if [ -d $oldFile ] || [ -f $oldFile ]
    then
        # Create a backup directory if it doesn't exists
        #
        if [ ! -d $backupdir ]
        then
            mkdir -p $backupdir
        fi

        # Move the file into the backup directory
        #
        mv $oldFile $backupdir/$1
        echo "Backed up $oldFile to $backupdir/$1"
    fi
}

for file in $files
do
    filebasename=$(basename $file)
    backup $filebasename

    ln -s $curdir/$file ~/.$filebasename

    echo "Created symlink from ~/.$filebasename to $curdir/$file"
done
