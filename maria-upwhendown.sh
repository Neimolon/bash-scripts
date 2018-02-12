#monitor db
#!/bin/bash
# MariaDB Process Monitor
# Restart MariaDB When It Goes Down
# -------------------------------------------------------------------------
# RHEL / CentOS / Fedora Linux restart command
RESTART="/sbin/service mariadb restart"

# uncomment if you are using Debian / Ubuntu Linux
#RESTART="/etc/init.d/mariadb restart"

#path to pgrep command
PGREP="/usr/bin/pgrep"

# daemon name
database="mysql"

# find database pid
$PGREP ${database}

if [ $? -ne 0 ] # if mariadb not running
then
 # restart mariadb
 $RESTART
fi
