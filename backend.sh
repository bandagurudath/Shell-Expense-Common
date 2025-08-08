#!/bin/bash

source ./common.sh

root

echo "Enter mysql root password"
read mysql_root_password

dnf module disable nodejs -y &>>$LOGPATH
validate $? "Disabling default Nodejs"

dnf module enable nodejs:20 -y &>>$LOGPATH
validate $? "enabling module nodejs version 20"

dnf install nodejs -y &>>$LOGPATH
validate $? "Installing nodejs"

dnf install mysql -y &>>$LOGPATH
validate $? "Installing mysql"

id expense &>>$LOGPATH
if [ $? -eq 0 ]
then
echo "expense user aready available"
else
useradd expense &>>$LOGPATH
validate $? "Adding expense user"
fi

mkdir -p /app &>>$LOGPATH

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGPATH

cd /app
rm -rf *
unzip /tmp/backend.zip &>>$LOGPATH

npm install &>>$LOGPATH
validate $? "Installing nodejs dependencies"

cp /home/ec2-user/Shell-Expense/backend.service /etc/systemd/system/backend.service
validate $? "copying backend service file to systemd"

systemctl daemon-reload &>>$LOGPATH
validate $? "daemon-reload"

systemctl start backend &>>$LOGPATH
validate $? "starting backend"

mysql -h db.gurudathbn.site -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGPATH
validate $? "Adding data to db"

systemctl restart backend &>>$LOGPATH
validate $? "restarting backend"