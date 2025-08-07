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
echo "$2 ...... $G Success $N"
else
echo "$2 ...... $R Failure $N"
fi
}

if [ $USERID -eq 0]
then
echo "You are super user"
else 
echo "you are not super user" 
exit 1
fi

echo "Enter mysql root password"
read mysql_root_password

dnf install mysql-server -y &>>$LOGPATH
validate $? "Installing mysql-server"

systemctl start mysqld &>>$LOGPATH
validate $? "Starting mysqld service"

systemctl enable mysqld &>>$LOGPATH
validate $? "enabling mysqld service"

mysql -h db.gurudathbn.site -u$mysql_root_user -p$mysql_root_password -e 'show databases;' &>>$LOGPATH
if [ $? -eq 0 ]
then
echo "mysql_root_password is already set"
else
mysql_secure_installation --set-root-pass -p$mysql_root_password &>>$LOGPATH
validate $? "Setting root Password"
fi
