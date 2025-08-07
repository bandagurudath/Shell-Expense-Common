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

dnf module disable nodejs -y &>>$LOGPATH
validate $? "Disabling default Nodejs"

dnf module enable nodejs:20 -y &>>$LOGPATH
validate $? "enabling module nodejs version 20"

systemctl install nodejs &>>$LOGPATH
validate $? "Installing nodejs"

systemctl enable nodejs &>>$LOGPATH
validate $? "enabling nodejs"

id expense &>>$LOGPATH
if [ $? -eq 0 ]
then
echo "expense user aready available"
else
useradd expense &>>$LOGPATH
validate $? "Adding expense user"
fi

mkdir -p /app &>>$LOGPATH

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip

cd /app
unzip /tmp/backend.zip

npm install &>>$LOGPATH
validate $? "Installing nodejs dependencies"

cp backend.service /etc/systemd/system/backend.service
validate $? "copying backend service file to systemd"

systemctl daemon-reload &>>$LOGPATH
validate $? "daemon-reload"

systemctl start backend &>>$LOGPATH
validate $? "starting backend"

mysql -h db.gurudathbn.site -uroot -p$mysql_root_password < /app/schema/backend.sql 
validate $? "Adding date to db"

systemctl restart backend &>>$LOGPATH
validate $? "restarting backend"