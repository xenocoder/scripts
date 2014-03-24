#!/bin/bash
#echo "Backing up PHPNuke database!"
#/usr/bin/mysqldump --add-drop-table -u dbo158251847 -pYnGGkMJ3 -hdb321.perfora.net db158251847 > /kunden/homepages/15/d157698034/htdocs/backup/PHPNuke_backup.sql
#/bin/gzip -f /kunden/homepages/15/d157698034/htdocs/backup/PHPNuke_backup.sql

#echo "Backing up PHPNuke Sandbox database!"
#/usr/bin/mysqldump --add-drop-table -u dbo158782363 -pWJcyjp6F -hdb334.perfora.net db158782363 > /kunden/homepages/15/d157698034/htdocs/backup/PHPNuke_sandbox_backup.sql
#/bin/gzip -f /kunden/homepages/15/d157698034/htdocs/backup/PHPNuke_sandbox_backup.sql

#OLD DATABASE (PHPBB2)
#echo "Backing up PHPBB database!"
#/usr/bin/mysqldump --add-drop-table -u dbo157787594 -pg5D19HdE -hdb310.perfora.net db157787594 > /kunden/homepages/15/d157698034/htdocs/backup/PHPBB_backup.sql
#/bin/gzip -f /kunden/homepages/15/d157698034/htdocs/backup/PHPBB_backup.sql

#NEW DATABASE (PHPBB3)
echo "Backing up PHPBB3 database!"
/usr/bin/mysqldump --add-drop-table -u dbo284622170 -pRABKTT9m -hdb863.perfora.net db284622170 > /kunden/homepages/15/d157698034/htdocs/backup/PHPBB3_backup.sql
/bin/gzip -f /kunden/homepages/15/d157698034/htdocs/backup/PHPBB3_backup.sql
