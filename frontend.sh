#!/bin/bash

source ./common.sh

root

dnf install nginx -y &>>$LOGPATH
validate $? "installing nginx"

systemctl start nginx &>>$LOGPATH
validate $? "starting nginx"

systemctl enable nginx &>>$LOGPATH
validate $? "enabling nginx"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGPATH

rm -rf /usr/share/nginx/html/* &>>$LOGPATH
validate $? "removing default html files"

cd /usr/share/nginx/html/
unzip /tmp/frontend.zip  &>>$LOGPATH
validate $? "unzip frontend files"

cp /home/ec2-user/Shell-Expense-Common/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGPATH
validate $? "copying configuration file"

systemctl restart nginx &>>$LOGPATH
validate $? "restarting nginx"