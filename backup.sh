#!/bin/bash
WPDBNAME=`cat wp-config.php | DB_NAME | cut -d \' -f 4`
WPDBUSER=`cat wp-config.php | DB_USER | cut -d \' -f 4`
WPDBPASS=`cat wp-config.php | DB_PASSWORD | cut -d \' -f 4`

username=""

# backups filenames
db_backup_name="wp-db-backup-"`date "+%Y-%m-%d"`".sql.gz"
wpfiles_backup_name="wp-files-backup-"`date "+%Y-%m-%d"`".tar.gz"

## db connection
db_name="database_name"
db_username="database_username"
db_password="database_password"

## paths
wp_upload_folder="/home/$username/public_html/wp-content/uploads"
wp_theme_folder="/home/$username/public_html/wp-content/themes"
backup_folder_path="/home/$username/wp_backup"

# backup database and zip
mysqldump --opt -u$db_username -p$db_password $db_name | gzip > $backup_folder_path/$db_backup_name

# backup wordpress directory
tar -czf $backup_folder_path/$wpfiles_backup_name $wp_upload_folder $wp_theme_folder
