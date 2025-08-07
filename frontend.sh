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