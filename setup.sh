#!/bin/bash

#BACKUP SCRIPT CREATION
echo "Creating backup script. Will need some info..."
echo "Mysql user:"; read MYSQL_USER
echo "Mysql password:"; read MYSQL_PASS
echo "Database name:"; read DB_NAME
echo "s3 bucket:"; read BUCKET
echo "s3 path (path inside the bucket, eg: /backups):"; read BUCKET_PATH
echo "Creating the backup script..."
touch backup_script.sh
echo "#!/bin/bash" >> backup_script.sh
echo "# File created with setup script" >> backup_script.sh
echo "" >> backup_script.sh
echo DATE="\$(date +'%d%m%Y')" >> backup_script.sh
echo "mysqldump -u $MYSQL_USER -p$MYSQL_PASS $DB_NAME > db_\$DATE.sql"  >> backup_script.sh
echo "tar -zcvf db_\$DATE.tar.gz db_\$DATE.sql" >> backup_script.sh
echo "rm db_\$DATE.sql" >> backup_script.sh
echo "`which aws` s3 cp db_\$DATE.tar.gz s3://$BUCKET$BUCKET_PATH/" >> backup_script.sh
echo "Backup script created succesfully \e[32m\u2714"

#CLEANUP SCRIPT CREATION
echo "Creating the cleanup script..."
touch cleanup_script.sh
echo "#!/bin/bash" >> cleanup_script.sh
echo "# File created with setup script" >> cleanup_script.sh
echo "" >> cleanup_script.sh
echo "for i in 6 5 4 3 2 1" >> cleanup_script.sh
echo "do" >> cleanup_script.sh
echo "rm db_\$(/bin/date --date \"-\$i day\" +%d%m%Y).tar.gz;" >> cleanup_script.sh
echo "`which aws` s3 rm s3://$BUCKET$BUCKET_PATH/db_\$(/bin/date --date \"-\$i day\" +%d%m%Y).tar.gz" >> cleanup_script.sh
echo "done" >> cleanup_script.sh
echo "Cleanup script created succesfully \e[32m\u2714"

# Write out current crontab
crontab -l > mycron
# echo new cron into cron file
echo "00 00 * * * cd && ./backup_script.sh" >> mycron
echo "30 00 * * 6 cd && ./cleanup_script.sh" >> mycron
# Install new cron file
crontab mycron
# Delete the temporary file
rm mycron
echo "Both scripts added to crond succesfully \e[32m\u2714"
