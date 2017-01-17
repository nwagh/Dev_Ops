#! /bin/sh

set -vx

MYSQL_HOST=mysql53
JREPORT_HOST=jreport
CLEO_INSTALL_FOLDER=/opt/harmony
HY_SERVER_IP=localhost
EMAIL_DOMAIN=localhost

setup_globals(){

# Create certificates
cd /tmp
openssl req -x509 -subj '/C=US/CN=Harmony' -newkey rsa:2048 -keyout server_key.pem -out server_cert.pem -days 365 -passout pass:"cleo"
openssl req -x509 -subj '/C=US/CN=SIGN' -newkey rsa:2048 -keyout sign_key.pem -out sign_cert.pem -days 365 -passout pass:"cleo"
openssl req -x509 -subj '/C=US/CN=ENCRYPT' -newkey rsa:2048 -keyout encrypt_key.pem -out encrypt_cert.pem -days 365 -passout pass:"cleo"

cd $CLEO_INSTALL_FOLDER

/usr/local/bin/shell.sh <<SHELL
 db set mysql:root:cleo@$MYSQL_HOST:3306/harmony
 xferlog mysql:root:cleo@$MYSQL_HOST:3306/harmony
 set '' replicatelogevents true
 opts Users.xml Users/Usergroup[Administrators]/Vlpoolaccess=mySystem \
                Users/Applications/Dbconnection=mysql:root:cleo@$MYSQL_HOST:3306/harmony
 import key SERVER /tmp/server_key.pem /tmp/server_cert.pem cleo 
 import key SIGN /tmp/sign_key.pem /tmp/sign_cert.pem cleo 
 import key ENCRYPT /tmp/encrypt_key.pem /tmp/encrypt_cert.pem cleo 
 scheduler autostart on
SHELL

}

install_uri(){

cd $CLEO_INSTALL_FOLDER

/usr/local/bin/shell.sh <<SHELL
  uri install com.cleo.labs%uri-s3%5.3.0.0-SNAPSHOT
  uri install com.cleo.labs%uri-hdfs%5.3.0.0-SNAPSHOT
SHELL

}

setup_listeners(){

cd $CLEO_INSTALL_FOLDER

/usr/local/bin/shell.sh <<SHELL
  set "Local Listener" Ftpisselected        True
  set "Local Listener" Ftpport              10021
  set "Local Listener" Ftpsauthisselected        True
  set "Local Listener" Ftpsauthport              990
  set "Local Listener" Ftpsexplicitauthrequiredisselected False
  set "Local Listener" advanced.FTPUTF8Pathnames true
  set "Local Listener" Sslftpservercertalias     SERVER
  set "Local Listener" Sslftpservercertpassword  cleo
  set "Local Listener" Httpisselected            True
  set "Local Listener" Httpsisselected           True
  set "Local Listener" Httpport                  5080
  set "Local Listener" Httpsport                 5443
  set "Local Listener" Sslservercertalias        SERVER
  set "Local Listener" Sslservercertpassword     cleo
  set "Local Listener" Sshftpisselected          True
  set "Local Listener" Sshftpport                10022
  set "Local Listener" Sshftpservercertalias     SERVER
  set "Local Listener" Sshftpservercertpassword  cleo
  set "Local Listener" localsigncertalias        SIGN
  set "Local Listener" localsigncertpassword     cleo
  set "Local Listener" localencrcertalias        ENCRYPT
  set "Local Listener" localencrcertpassword     cleo
  set "Web Browser::Local Listener" Businessdashboardresourceenabled True
  set "Web Browser::Local Listener" Businessdashboardresourcepath    /VLDashboards
  set "Web Browser::Local Listener" Systemmonitorresourceenabled     True
  set "Web Browser::Local Listener" Systemmonitorresourcepath        /VLMonitor
  set "Web Browser::Local Listener" Reportserverurl                  http://$JREPORT_HOST:8888
  set "Web Browser::Local Listener" Trustresourceenabled             True
  set "Web Browser::Local Listener" Trustresourcepath                /Trust
  set "Web Browser::Local Listener" Unifyresourceenabled             True
  set "Web Browser::Local Listener" Unifyresourcepath                /Unify
  save "Local Listener"
  opts VLApplicationNum\(Application=Dashboards\)       IsEnabled=1
  opts VLApplicationNum\(Application='System Monitor'\) IsEnabled=1
  opts VLApplicationNum\(Application='Operator Audit Trail'\) IsEnabled=1
  opts VLApplicationNum\(Application=Unify\)            IsEnabled=1
  opts VLApplicationNum\(Application=Trust\)            IsEnabled=1
  !mkdir $CLEO_INSTALL_FOLDER/repo
  opts VLUnifyOptions fileRepository=$CLEO_INSTALL_FOLDER/repo senderEmailAddress=no-reply@$EMAIL_DOMAIN repositorySize=50000 repositoryOverflowSize=0
  opts VLTrustOptions fileRepository=$CLEO_INSTALL_FOLDER/repo senderEmailAddress=no-reply@$EMAIL_DOMAIN repositorySize=50000 repositoryOverflowSize=0
SHELL

}


setup_globals
setup_listeners
install_uri
