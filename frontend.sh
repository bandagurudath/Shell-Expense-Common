#!/bin/bash

source ./common.sh

root()

dnf install nginx -y &>>$LOGPATH
validate $? "installing nginx"

systemctl start nginx &>>$LOGPATH
validate $? "starting nginx"

systemctl enable nginx &>>$LOGPATH
validate $? "enabling nginx"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip

rm -rf /usr/share/nginx/html/* &>>$LOGPATH
validate $? "removing default html files"

unzip /tmp/frontend.zip /usr/share/nginx/html/ &>>$LOGPATH
validate $? "unzip frontend files"

cp expense.conf /etc/nginx/default.d/ &>>$LOGPATH
validate $? "copying configuration file"

systemctl restart nginx &>>$LOGPATH
validate $? "restarting nginx"