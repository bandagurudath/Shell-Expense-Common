#!/bin/bash

USERID=$(id -u)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGPATH=/tmp/$SCRIPTNAME-$TIMESTAMP.log
mysql_root_user=root

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

validate(){
if [ $1 -eq 0 ]
then
echo -e "$2 ...... $G Success $N"
else
echo -e "$2 ...... $R Failure $N"
fi
}

root(){
if [ $USERID -eq 0 ]
then
echo "You are super user"
else 
echo "you are not super user" 
exit 1
fi
}