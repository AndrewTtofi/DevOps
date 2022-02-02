#!/bin/bash
result=/var/www/html/<enter name of directory> # to assign to a variable
result1=${result:14} # allows only the name of the directory that will be saved e.g. fxgt/
resultfinal=`echo $result1 | tr '/' '_'`   #deletes potential / or _
name=$resultfinal$(date '+%Y-%m-%d')   # adds the current date at the end of the backup
echo $name  #prints out the name produced
sudo tar {DAME MPENI TI THELIS NA KAMIS EXLUDE} -zcvf /var/www/html/Backups/$name.tar.gz /var/www/html/<enter name of directory> #tars the folder and stores it under Backups directory. in case a directory needs to be excluded: --exlude='/var/www/html/fxgt/gl'
aws s3 cp /var/www/html/Backups/$name.tar.gz s3://<enter name of S3 folder>  #send the tar file to the s3
rm -rf /var/www/html/Backups/* # delete the tar file from the Backups directory
