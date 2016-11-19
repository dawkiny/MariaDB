### For Windows

On _Source_ console,
Change directory to ```mysqldump.exe```
```sh
cd C:/Program Files/MariaDB 10.1/bin
```

Then
```sh
mysqldump --opt [source_dbname] | mysql --host=[target_ip] -u [target_username] -p [target_password] -C [target_dbname]
```
