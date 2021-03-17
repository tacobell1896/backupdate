#!/bin/bash
if [ ! -f "wp-config.php"]
then
    DBNAME=`cat configuration.php | $`
    DBUSER=``
    DBPASS=``
else
    DBNAME=`cat wp-config.php | DB_NAME | cut -d \' -f 4`
    DBUSER=`cat wp-config.php | DB_USER | cut -d \' -f 4`
    DBPASS=`cat wp-config.php | DB_PASSWORD | cut -d \' -f 4`
fi
# TODO: conditional to check for what CMS is being used and pull credentials from the appropriate config file
## Should be the name of the directory that the site is in
username=""

# backups filenames
db_backup_name="wp-db-backup-"`date "+%Y-%m-%d"`".sql.gz"
wpfiles_backup_name="wp-files-backup-"`date "+%Y-%m-%d"`".tar.gz"

# paths
wp_upload_folder="/home/$username/public_html/wp-content/uploads"
wp_theme_folder="/home/$username/public_html/wp-content/themes"
backup_folder_path="/home/$username/wp_backup"

# backup database and zip
mysqldump --opt -u$DBUSER -p$DBPASS $DBNAME | gzip > $backup_folder_path/$db_backup_name

# backup wordpress directory
tar -czf $backup_folder_path/$wpfiles_backup_name $wp_upload_folder $wp_theme_folder

# delete all but 5 recent backups
find $backup_folder_path -maxdepth 1 -name "*.sql.gz" -type f | xargs -x ls -t | awk 'NR>5' | xargs -L1 rm
find $backup_folder_path -maxdepth 1 -name "*.tar.gz" -type f | xargs -x ls -t | awk 'NR>5' | xargs -L1 rm