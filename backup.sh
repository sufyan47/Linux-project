#!/bin/bash

<<comment
this script will take backup 
from source to target
comment

create_backup () {
read -p "Enter source" sourcedir

read -p "Enter target" targetdir

src_dir="$sourcedir"



tgt_dir="$targetdir"




backup_filename="backup_$(date +%Y-%m-%d-%H-%M-%S).tar.gz"

echo "Backup started"

echo "Backing up to $backup_filename"


tar -czvf "${tgt_dir}/${backup_filename}"  "$src_dir"


echo "Backup Complete"
}  

create_backup 


