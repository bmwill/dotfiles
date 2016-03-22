#!/bin/bash


for file in "$@"
do
  newName=`echo $file | tr ' ' '_' | tr -d '[{}(),\!]' | tr -d "\'" | sed 's/_-_/_/g' | sed 's/_USA//g' | sed 's/\&/and/g'`
  newName=`echo $newName | sed 's/_EnFr//g'`
  mv -v "$file" "$newName"
done
