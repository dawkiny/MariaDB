# Set up ```mariadb```


## Install on Ubuntu

MariaDB 10.1:
```sh
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.kaist.ac.kr/mariadb/repo/10.1/ubuntu xenial main'
```

```sh
sudo apt-get update
sudo apt-get install mariadb-server
```


## Run ```MariaDB```

```sh
systemctl start mysql
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to start 'mysql.service'.
Authenticating as: dawkiny,,, (dawkiny)
Password: 
==== AUTHENTICATION COMPLETE ===
```
## Securing ```MariaDB```
```sh
sudo mysql_secure_installation 
-------------------------------------------------------------------------
[sudo] password for dawkiny: 

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

You already have a root password set, so you can safely answer 'n'.

Change the root password? [Y/n] y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
-------------------------------------------------------------------------
```

```sh
sudo mysql -uroot -p
```

## Configuration for users
```sh

```

```sql
CREATE USER 'mdb'@'%' IDENTIFIED BY 'mdb';
GRANT ALL PRIVILEGES ON *.* TO 'mdb';

```

## Configure `my.cnf`

```sh
sudo vi /etc/mysql/my.cnf
```

```sh
#bind-address      = 127.0.0.1  # disabled by #:

```
