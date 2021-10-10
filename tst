#!/bin/bash

# realpath and basename don't check if the input exists or not. It has to be manually checked.
if test ! -e $1; then

    echo "$1 doesn't exist."
    exit 1
fi


rpath=$(realpath $1)
# Removing $HOME section from the beginning of $rpath
rpath_edited=$(echo $rpath | sed "s|$HOME/||")
#echo "rpath_edited: $rpath_edited"
#echo "basename: $(basename $1)"

if test -d $1; then

    #echo "$1 is directory"
    ##############  Creating Directory ###############
    dest="$(basename $1)/$rpath_edited"
    final_dest="$HOME/dot/$dest"
    echo $final_dest
    mkdir -p $final_dest

    ############## Copying files to destination ###############
    cp -r "$rpath/." $final_dest 

    ############## Removing Original File ##############  
    rm -r $rpath

    ############## Changing name of the target directory ################
    #read -p $"target Directory name: $(basename $1). You wanna change it? " ans
    #mv "$HOME/dot/$(basename $1)" "$HOME/dot/$ans"


    ############## Making symlink to the Original File path ############## 
    cd "$HOME/dot"
    stow $(basename $1)
    
    
elif test -f $1; then

    #echo "$1 is file"
    ############## Creating Directory ###############
    # Removing "basename $1" at the end of path 
    dest="$(echo "$(basename $1)/$rpath_edited" | sed "s|/$(basename $1)||")"
    final_dest="$HOME/dot/$dest"
    #echo $final_dest
    mkdir -p $final_dest
    
    ############## Copying files to destination ###############
    cp $rpath $final_dest
    
    ############## Removing Original Files ##############  
    rm $rpath

    ############## Making symlink to the Original File path ############## 
    cd "$HOME/dot"
    stow $(basename $1)
fi 

# The right directory
