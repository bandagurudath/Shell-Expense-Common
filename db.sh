#!/bin/bash

source ./common.sh

root

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
mysql_secure_installation --set-root-pass $mysql_root_password &>>$LOGPATH
validate $? "Setting root Password"
fi
