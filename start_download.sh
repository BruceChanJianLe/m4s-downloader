#!/bin/bash
# This script download the init part of the video

# Create seg directory to store seg files
if [ -d "seg" ]
then
    read -p "Do you wish to remove the files in seg folder?[Y/n]" folder
    if [[ $folder = "y" ]] || [[ $folder = "Y" ]] || [ -z $folder ]
    then
        rm -rf seg/*
    fi
    cd seg
else
    mkdir seg
    cd seg
fi

# Download the init segment
echo -e "----------------------\n"
echo -e "Download the init segment"
read -p "Please provide the url to the init file: " url
if [ -z $url ]
then
    echo "Skip init download."
else
    wget -O init.mp4 $url
fi

echo -e "----------------------\n"
echo -e "Now we download the segments from the init file"

i=1
while read -r line; do
    if [[ $line =~ ^http.+$ ]]
    then
        wget -O  seg-$i.m4s $line
        let "i+=1"
    fi
done < init.mp4

echo -e "----------------------\n"
echo -e "Combining into target"
read -p "target name: " target

combine_command=`ls -vx seg-*.m4s`
cat init.mp4 $combine_command > ../$target.mp4

# https://stackoverflow.com/questions/23485759/combine-mpeg-dash-segments-ex-init-mp4-segments-m4s-back-to-a-full-source-m
# https://www.youtube.com/watch?v=8hiuDlrWBz0
