# SQL_DB-Refresh
This script will do the database refresh. It is multi-purpose Script which can be used for Database backup, Copy backup to Target Server and Restore the backup. For full Database refresh single pressed of Start button. For individual use each section. Make sure all details entered correctly.

Primary or development server database backup will be taken, Next it copied to Target or Production server location, Next it will first take backup of the Target or Production Server database, Finally, restore the database from the backup file taken from production server.

## Prerequisites

Windows OS - Powershell<br>
SqlServer Module need to be installed if not than type below command in powershell prompt.<br>
Install-Module -Name SqlServer

## Note
  
---------- Primary DB Details ----------<br>
Status - It shows either operation Done or Failed,<br>
---------- Copy Backup to Server ----------<br>
Status - Copied Successfully or Failed,<br>
---------- Target DB Details ----------<br>
Status - DB Refresh Successfull or Failed.<br><br>
![alt text](https://github.com/Sahista-Patel/SQL_DB-Refresh/blob/Powershell/refresh_1.jpg)<br>
<br>For individual steps use each section. Make sure all details entered correctly.

## Use

Open Powershell<br>
"C:\IO_Occurences.ps1"


# Input
---------- Primary DB Details ----------<br>
Server Name - Primary Database whose backup/Refresh needs to be done,<br>
Instance Name - SQL Server Instance Name,<br>
DB Name - Database Name,<br>
Backup Path - Location where Backup needs to be stored,<br>
Status - It shows either operation DOne or Failed,<br>

---------- Copy Backup to Server ----------<br>
Destination Path - Location where target server backup located - Path from where restore file computed,<br>
Status - Copied Successfully or Failed,<br>

---------- Target DB Details ----------<br>
Server Name - Target Server Name,<br>
Instance Name - Target Instance Name,<br>
DB Name - Target Database name which needs to be refreshed,<br>
Backup Path - Path where Target Server database backup taken first before restoring,<br>
Restore Path - Path from where restore computed same as copy path in all one go case,<br>
Status - DB Refresh Successfull or Failed.

## Example O/P

![alt text](https://github.com/Sahista-Patel/SQL_DB-Refresh/blob/Powershell/refresh_2.jpg)

## License

Copyright 2020 Harsh & Sahista

## Contribution

* [Harsh Parecha] (https://github.com/TheLastJediCoder)
* [Sahista Patel] (https://github.com/Sahista-Patel)<br>
We love contributions, please comment to contribute!

## Code of Conduct

Contributors have adopted the Covenant as its Code of Conduct. Please understand copyright and what actions will not be abided.
