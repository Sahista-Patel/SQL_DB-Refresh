<#
.SYNOPSIS
    This script will do the database refresh. 
    It is multi-purpose Script which can be used for Database backup, Copy backup to Target Server and Restore the backup.
    For full Database refresh single pressed of Start button.
    For individual use each section. Make sure all details entered correctly.
    
.DESCRIPTION
    Primary or development server database backup will be taken,
    Next it copied to Target or Production server location,
    Next it will first take backup of the Target or Production Server database,
    Finally, restore the database from the backup file taken from production server.
    
.INPUTS
    ---------- Primary DB Details ----------
    Server Name - Primary Database whose backup/Refresh needs to be done,
    Instance Name - SQL Server Instance Name,
    DB Name - Database Name,
    Backup Path - Location where Backup needs to be stored,
    Status - It shows either operation DOne or Failed,

    ---------- Copy Backup to Server ----------
    Destination Path - Location where target server backup located - Path from where restore file computed,
    Status - Copied Successfully or Failed,

    ---------- Target DB Details ----------
    Server Name - Target Server Name,
    Instance Name - Target Instance Name,
    DB Name - Target Database name which needs to be refreshed,
    Backup Path - Path where Target Server database backup taken first before restoring,
    Restore Path - Path from where restore computed same as copy path in all one go case, 
    Status - DB Refresh Successfull or Failed.

.EXAMPLE
    .\DBRefresh.ps1
    This will execute the GUI and need to add appropriate information as mentioned in an Input section.

.NOTES
    PUBLIC
    SqlServer Module need to be installed if not than type below command in powershell prompt.
    Install-Module -Name SqlServer

.AUTHOR
    Harsh Parecha
    Sahista Patel
#>


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$DB_Refresh                      = New-Object system.Windows.Forms.Form
$DB_Refresh.ClientSize           = New-Object System.Drawing.Point(680,610)
$DB_Refresh.text                 = "Database Refresh"
$DB_Refresh.TopMost              = $false
$DB_Refresh.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#000000")

$Panel1                          = New-Object system.Windows.Forms.Panel
$Panel1.height                   = 210
$Panel1.width                    = 660
$Panel1.location                 = New-Object System.Drawing.Point(10,10)
$Panel1.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Label4                          = New-Object system.Windows.Forms.Label
$Label4.text                     = "Primary DB Details:"
$Label4.AutoSize                 = $true
$Label4.width                    = 25
$Label4.height                   = 10
$Label4.location                 = New-Object System.Drawing.Point(10,10)
$Label4.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$PS_Name                         = New-Object system.Windows.Forms.TextBox
$PS_Name.multiline               = $false
$PS_Name.width                   = 200
$PS_Name.height                  = 20
$PS_Name.location                = New-Object System.Drawing.Point(200,50)
$PS_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Server Name:"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(10,50)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Instance Name:"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(10,80)
$Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$PI_Name                         = New-Object system.Windows.Forms.TextBox
$PI_Name.multiline               = $false
$PI_Name.width                   = 200
$PI_Name.height                  = 20
$PI_Name.location                = New-Object System.Drawing.Point(200,80)
$PI_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$PD_Name                         = New-Object system.Windows.Forms.TextBox
$PD_Name.multiline               = $false
$PD_Name.width                   = 200
$PD_Name.height                  = 20
$PD_Name.location                = New-Object System.Drawing.Point(200,110)
$PD_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "DB Name:"
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(10,110)
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label9                          = New-Object system.Windows.Forms.Label
$Label9.text                     = "Backup Path:"
$Label9.AutoSize                 = $true
$Label9.width                    = 25
$Label9.height                   = 10
$Label9.location                 = New-Object System.Drawing.Point(10,140)
$Label9.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$PB_Name                         = New-Object system.Windows.Forms.TextBox
$PB_Name.multiline               = $false
$PB_Name.width                   = 300
$PB_Name.height                  = 20
$PB_Name.location                = New-Object System.Drawing.Point(200,140)
$PB_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$P_Status                        = New-Object system.Windows.Forms.TextBox
$P_Status.multiline              = $false
$P_Status.width                  = 200
$P_Status.height                 = 20
$P_Status.enabled                = $false
$P_Status.location               = New-Object System.Drawing.Point(200,170)
$P_Status.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label14                         = New-Object system.Windows.Forms.Label
$Label14.text                    = "Status:"
$Label14.AutoSize                = $true
$Label14.width                   = 25
$Label14.height                  = 10
$Label14.location                = New-Object System.Drawing.Point(10,170)
$Label14.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$First_Run                       = New-Object system.Windows.Forms.Button
$First_Run.text                  = "Run"
$First_Run.width                 = 80
$First_Run.height                = 30
$First_Run.location              = New-Object System.Drawing.Point(570,170)
$First_Run.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Panel3                          = New-Object system.Windows.Forms.Panel
$Panel3.height                   = 120
$Panel3.width                    = 660
$Panel3.location                 = New-Object System.Drawing.Point(10,230)
$Panel3.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Label12                         = New-Object system.Windows.Forms.Label
$Label12.text                    = "Copy Backup to Server:"
$Label12.AutoSize                = $true
$Label12.width                   = 25
$Label12.height                  = 10
$Label12.location                = New-Object System.Drawing.Point(10,10)
$Label12.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$Label13                         = New-Object system.Windows.Forms.Label
$Label13.text                    = "Destination Path:"
$Label13.AutoSize                = $true
$Label13.width                   = 25
$Label13.height                  = 10
$Label13.location                = New-Object System.Drawing.Point(10,50)
$Label13.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$CD_Name                         = New-Object system.Windows.Forms.TextBox
$CD_Name.multiline               = $false
$CD_Name.width                   = 300
$CD_Name.height                  = 20
$CD_Name.location                = New-Object System.Drawing.Point(200,50)
$CD_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Copy_Backup                     = New-Object system.Windows.Forms.Button
$Copy_Backup.text                = "Copy"
$Copy_Backup.width               = 80
$Copy_Backup.height              = 30
$Copy_Backup.location            = New-Object System.Drawing.Point(570,80)
$Copy_Backup.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label15                         = New-Object system.Windows.Forms.Label
$Label15.text                    = "Status:"
$Label15.AutoSize                = $true
$Label15.width                   = 25
$Label15.height                  = 10
$Label15.location                = New-Object System.Drawing.Point(10,80)
$Label15.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$CD_Status                       = New-Object system.Windows.Forms.TextBox
$CD_Status.multiline             = $false
$CD_Status.width                 = 200
$CD_Status.height                = 20
$CD_Status.enabled               = $false
$CD_Status.location              = New-Object System.Drawing.Point(200,80)
$CD_Status.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Panel2                          = New-Object system.Windows.Forms.Panel
$Panel2.height                   = 240
$Panel2.width                    = 660
$Panel2.location                 = New-Object System.Drawing.Point(10,360)
$Panel2.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Label5                          = New-Object system.Windows.Forms.Label
$Label5.text                     = "Target DB Details:"
$Label5.AutoSize                 = $true
$Label5.width                    = 25
$Label5.height                   = 10
$Label5.location                 = New-Object System.Drawing.Point(10,10)
$Label5.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$Label6                          = New-Object system.Windows.Forms.Label
$Label6.text                     = "Server Name:"
$Label6.AutoSize                 = $true
$Label6.width                    = 25
$Label6.height                   = 10
$Label6.location                 = New-Object System.Drawing.Point(10,50)
$Label6.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TS_Name                         = New-Object system.Windows.Forms.TextBox
$TS_Name.multiline               = $false
$TS_Name.width                   = 200
$TS_Name.height                  = 20
$TS_Name.location                = New-Object System.Drawing.Point(200,50)
$TS_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label7                          = New-Object system.Windows.Forms.Label
$Label7.text                     = "Instance Name:"
$Label7.AutoSize                 = $true
$Label7.width                    = 25
$Label7.height                   = 10
$Label7.location                 = New-Object System.Drawing.Point(10,80)
$Label7.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TI_Name                         = New-Object system.Windows.Forms.TextBox
$TI_Name.multiline               = $false
$TI_Name.width                   = 200
$TI_Name.height                  = 20
$TI_Name.location                = New-Object System.Drawing.Point(200,80)
$TI_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label8                          = New-Object system.Windows.Forms.Label
$Label8.text                     = "DB Name:"
$Label8.AutoSize                 = $true
$Label8.width                    = 25
$Label8.height                   = 10
$Label8.location                 = New-Object System.Drawing.Point(10,110)
$Label8.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TD_Name                         = New-Object system.Windows.Forms.TextBox
$TD_Name.multiline               = $false
$TD_Name.width                   = 200
$TD_Name.height                  = 20
$TD_Name.location                = New-Object System.Drawing.Point(200,110)
$TD_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label10                         = New-Object system.Windows.Forms.Label
$Label10.text                    = "Backup Path:"
$Label10.AutoSize                = $true
$Label10.width                   = 25
$Label10.height                  = 10
$Label10.location                = New-Object System.Drawing.Point(10,140)
$Label10.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TB_Name                         = New-Object system.Windows.Forms.TextBox
$TB_Name.multiline               = $false
$TB_Name.width                   = 300
$TB_Name.height                  = 20
$TB_Name.location                = New-Object System.Drawing.Point(200,140)
$TB_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label11                         = New-Object system.Windows.Forms.Label
$Label11.text                    = "Restore Path:"
$Label11.AutoSize                = $true
$Label11.width                   = 25
$Label11.height                  = 10
$Label11.location                = New-Object System.Drawing.Point(10,170)
$Label11.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TR_Name                         = New-Object system.Windows.Forms.TextBox
$TR_Name.multiline               = $false
$TR_Name.width                   = 300
$TR_Name.height                  = 20
$TR_Name.location                = New-Object System.Drawing.Point(200,170)
$TR_Name.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label16                         = New-Object system.Windows.Forms.Label
$Label16.text                    = "Status:"
$Label16.AutoSize                = $true
$Label16.width                   = 25
$Label16.height                  = 10
$Label16.location                = New-Object System.Drawing.Point(10,200)
$Label16.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$T_Status                        = New-Object system.Windows.Forms.TextBox
$T_Status.multiline              = $false
$T_Status.width                  = 200
$T_Status.height                 = 20
$T_Status.enabled                = $false
$T_Status.location               = New-Object System.Drawing.Point(200,200)
$T_Status.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Second_Run                      = New-Object system.Windows.Forms.Button
$Second_Run.text                 = "Run"
$Second_Run.width                = 80
$Second_Run.height               = 30
$Second_Run.location             = New-Object System.Drawing.Point(570,170)
$Second_Run.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Start                      = New-Object system.Windows.Forms.Button
$Start.text                 = "Start"
$Start.width                = 80
$Start.height               = 30
$Start.location             = New-Object System.Drawing.Point(570,200)
$Start.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$DB_Refresh.controls.AddRange(@($Panel1,$Panel2,$Panel3))
$Panel1.controls.AddRange(@($PS_Name,$Label1,$Label2,$PI_Name,$PD_Name,$Label3,$Label4,$Label9,$PB_Name,$First_Run,$P_Status,$Label14))
$Panel2.controls.AddRange(@($Label5,$Label6,$TS_Name,$Label7,$TI_Name,$Label8,$TD_Name,$Label10,$TB_Name,$Second_Run,$Label11,$TR_Name,$Label16,$T_Status,$Start))
$Panel3.controls.AddRange(@($Label12,$Label13,$CD_Name,$Copy_Backup,$Label15,$CD_Status))

$global:backupF = $null
$global:RestoreF = $null
$global:DBFilename = $null
  
 function FetchP {
    $PS_Name.Text
    $PI_Name.Text
    $PD_Name.Text
    $PB_Name.Text
   
    $SQLInstance = $PI_Name.Text
    $DBName = $PD_Name.Text
    $SharedFolder = $PB_Name.Text
    #$Date = Get-Date -format yyyy-MM-dd HH-mm
    $Date = [Math]::Round((Get-Date).ToFileTime()/10000)
    try{
    Backup-SqlDatabase  -ServerInstance $SQLInstance `
                    -Database $DBName `
                    -CopyOnly `
                    -CompressionOption on `
                    -BackupFile "$($SharedFolder)\$DBName-$date.bak" `
                    -BackupAction Database `
                    -checksum `
                    -verbose | Out-String
    $P_Status.Text = "Done"
    $global:backupF = $SharedFolder+"\" +$DBName + "-" + $date + ".bak"
    $global:DBFilename = $DBName + "-" + $date + ".bak"
    #$global:test="two"
    }catch{
        Write-Host "Backup Failed."
        $P_Status.Text = "Failed"
        $CD_Status.Text = "Backup Failed.Can't proceed."
    }
    
} 

function FetchC {
    #$backupF = "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorks2016_2020-07-07 16-46-03.bak"
    #$backupF = $PB_Name.Text + "\" + "$DBName"
    if ($CD_Status.Text -ne "Backup Failed.Can't proceed."){
    try{
    $destpath = $CD_Name.Text + "\"
    #Copy-Item -Path $backupF -Destination $destpath -PassThru
    if($destpath -contains "\\"){
        $destpathi = $destpath.Replace(':','$')
        $backupFi = "\\"+ $PS_Name.Text+ "\" +$backupF.Replace(':', '$')
    }
    else{
        $backupFi = $backupF 
        $destpathi = $destpath
    }
    Write-Host "Source Path value: "  $backupFi
    Write-Host "Destination Path value: "  $destpathi

    
    Copy-Item -Path $backupFi -Destination $destpathi; 

    $CD_Status.Text = "Successfully Copied!"
    $global:RestoreF = $destpathi
    if ($TR_Name.Text -eq ""){
        $global:RestoreF = $global:RestoreF + $global:DBFilename
        $TR_Name.Text = $global:RestoreF
        #Write-Host "Restore File Path in copy function: "  $TR_Name.Text

    }
    }catch{
       # Write-Host "Backup Failed."
        $CD_Status.Text = "Copied Failed."
        $T_Status.Text = "Copied Failed. Can't proceed."
    }
    }
    else{
    $T_Status.Text = "Copied Failed. Can't proceed."
    }
}  

function FetchR {
    if($T_Status.Text -ne "Copied Failed. Can't proceed."){
    $serverName = $TS_Name.Text
    $Instance = $TI_Name.Text
    $DBName = $TD_Name.Text
    $bkPath = $TB_Name.Text
    $rstrPath = $TR_Name.Text


    Write-Host "Restore File Path in Restore function: " + $rstrPath

    #For saving roles and permissions
    $QueryRoles = "SET nocount ON
                            SELECT scripts AS '--Scripts'
                            FROM   (SELECT Getdate() AS ScriptDateTime,
                                           'CREATE USER [' + DP.name + '] FOR LOGIN ['
                                           + SP.name + ']' + CASE WHEN DP.type_desc != 'WINDOWS_GROUP' THEN
                            ' WITH DEFAULT_SCHEMA = ['+Isnull(DP.default_schema_name, 'dbo')+']'
                            --+ CHAR(13)+CHAR(10)+'GO'
                            ELSE ''--+ CHAR(13)+CHAR(10)+'GO'
                            END       AS Scripts
                            FROM   sys.database_principals DP,
                            sys.server_principals SP
                            WHERE  SP.sid = DP.sid
                            AND DP.name NOT IN ( 'DBO', 'GUEST', 'INFORMATION_SCHEMA', 'SYS',
                                                 'PUBLIC', 'DB_OWNER', 'DB_ACCESSADMIN',
                                                 'DB_SECURITYADMIN',
                                                 'DB_DDLADMIN', 'DB_BACKUPOPERATOR', 'DB_DATAREADER'
                                                 ,
                                                     'DB_DATAWRITER',
                                                 'DB_DENYDATAREADER', 'DB_DENYDATAWRITER', 'DB_X' )
                            UNION

                            --Extracting Database Roles Permissions for the DB USers.

                            SELECT Getdate() AS ScriptDateTime,
                            'EXEC sp_addrolemember @rolename ='
                            + Space(1)
                            + Quotename(User_name(rm.role_principal_id), '''')
                            + ', @membername =' + Space(1)
                            + Quotename(User_name(rm.member_principal_id), '''')
                                      --+ CHAR(13)+CHAR(10)+'GO'
                                      AS '--Role Memberships'
                            FROM   sys.database_role_members AS rm
                            WHERE  User_name(rm.role_principal_id)
                            + User_name(rm.member_principal_id) != 'DB_OWNERDBO'
                            --ORDER BY rm.role_principal_id ASC
                            UNION



                            --Extracting object level permissions

                            SELECT Getdate() AS ScriptDateTime,
                            CASE WHEN perm.state <> 'W' THEN perm.state_desc ELSE 'GRANT' END +
                            Space
                            (1) +
                            perm.permission_name + Space(1)
                            + 'ON ' + Quotename(User_name(obj.schema_id))
                            + '.' + Quotename(obj.name) + CASE WHEN cl.column_id IS NULL THEN Space(
                            0
                            ) ELSE
                            '(' + Quotename(cl.name) + ')' END + Space(1) + 'TO'
                            + Space(1)
                            + Quotename(User_name(usr.principal_id)) COLLATE database_default + CASE
                            WHEN perm.state <> 'W' THEN Space(0)
                            ELSE Space(1) + 'WITH GRANT OPTION'
                                                                                                END
                                      --+ CHAR(13)+CHAR(10)+'GO'
                                      AS '--Object Level Permissions'
                            FROM   sys.database_permissions AS perm
                            INNER JOIN sys.objects AS obj
                                    ON perm.major_id = obj.[object_id]
                            INNER JOIN sys.database_principals AS usr
                                    ON perm.grantee_principal_id = usr.principal_id
                            LEFT JOIN sys.columns AS cl
                                   ON cl.column_id = perm.minor_id
                                      AND cl.[object_id] = perm.major_id
                            --ORDER BY perm.permission_name ASC, perm.state_desc ASC
                            UNION


                            --Extracting database level permissions


                            SELECT Getdate() AS ScriptDateTime,
                            CASE WHEN perm.state <> 'W' THEN perm.state_desc ELSE 'GRANT' END +
                            Space
                            (1) +
                            perm.permission_name + Space(1)
                            + Space(1) + 'TO' + Space(1)
                            + Quotename(User_name(usr.principal_id)) COLLATE database_default + CASE
                            WHEN perm.state <> 'W' THEN Space(0)
                            ELSE Space(1) + 'WITH GRANT OPTION'
                                                                                                END
                                      --+ CHAR(13)+CHAR(10)+'GO'
                                      AS '--Database Level Permissions'
                            FROM   sys.database_permissions AS perm
                            INNER JOIN sys.database_principals AS usr
                                    ON perm.grantee_principal_id = usr.principal_id
                            WHERE  perm.major_id = 0
                            AND ( permission_name
                                  + User_name(usr.principal_id) != 'CONNECTDBO' )
                            --ORDER BY perm.permission_name ASC, perm.state_desc ASC
                            ) AS UserScripts
                            ORDER  BY scripts "


                            $Result = Invoke-Sqlcmd -Database $DBName -Query $QueryRoles -ServerInstance $Instance
                            $Result = $Result | Out-String

                            Write-Host "......Stored Current Roles..." 
                            $Result
                            

                            #Takin Backup before restore
                            $Date = [Math]::Round((Get-Date).ToFileTime()/10000)
                            try{
                            Backup-SqlDatabase  -ServerInstance $Instance `
                    -Database $DBName `
                    -CopyOnly `
                    -CompressionOption on `
                    -BackupFile "$($bkPath)\$DBName-$date.bak" `
                    -BackupAction Database `
                    -checksum `
                    -verbose | Out-String

                    $T_Status.Text = "Dev backup done."
                    Write-Host "Dev backup done"
                    }catch{
                        Write-Host "Dev Backup Failed."
                        $T_Status.Text = "Backup Failed"
                    }
                    Write-Host "Trying to restore backup"
                    Write-Host "Instance: " $Instance
                    Write-Host "DBName: " $DBName
                    Write-Host "backupFile Path: "  $rstrPath

                    try{
    
                    Invoke-Sqlcmd -ServerInstance $Instance -Database $DBName -Query "use [master];"    
    
                    Restore-SqlDatabase -ServerInstance $Instance `
                                    -Database $DBName `
                                    -BackupFile $rstrPath

                    $T_Status.Text = "Restore Backup Done"
                    Write-Host "Restore backup done"
                    }catch{
                        Write-Host "Restore Backup Failed."
                        $T_Status.Text = "Restore Backup Failed"
                    }
    
                    
                    try{
                    $queryDrop = "use ["+$DBName+"]
                                    DROP PROCEDURE IF EXISTS dbo.sp_Drop_OrphanedUsers
                                    go
                                    create proc dbo.sp_Drop_OrphanedUsers
                                    as
                                    begin
                                     set nocount on
                                     -- get orphaned users  
                                     declare @user varchar(max) 
                                     declare c_orphaned_user cursor for 
                                      select name
                                      from sys.database_principals 
                                      where type in ('G','S','U') 
                                      and authentication_type<>2
                                      and [sid] not in ( select [sid] from sys.server_principals where type in ('G','S','U') ) 
                                      and name not in ('dbo','guest','INFORMATION_SCHEMA','sys','MS_DataCollectorInternalUser')  open c_orphaned_user 
                                     fetch next from c_orphaned_user into @user
                                     while(@@FETCH_STATUS=0)
                                     begin
                                      -- alter schemas for user 
                                      declare @schema_name varchar(max) 
                                      declare c_schema cursor for 
                                       select name from  sys.schemas where USER_NAME(principal_id)=@user
                                      open c_schema 
                                      fetch next from c_schema into @schema_name
                                      while (@@FETCH_STATUS=0)
                                      begin
                                       declare @sql_schema varchar(max)
                                       select @sql_schema='ALTER AUTHORIZATION ON SCHEMA::['+@schema_name+ '] TO [dbo]'
                                       print @sql_schema
                                       exec(@sql_schema)
                                       fetch next from c_schema into @schema_name
                                      end
                                      close c_schema
                                      deallocate c_schema   
  
                                      -- alter roles for user 
                                      declare @dp_name varchar(max) 
                                      declare c_database_principal cursor for 
                                       select name from sys.database_principals
                                       where type='R' and user_name(owning_principal_id)=@user
                                      open c_database_principal
                                      fetch next from c_database_principal into @dp_name
                                      while (@@FETCH_STATUS=0)
                                      begin
                                       declare @sql_database_principal  varchar(max)
                                       select @sql_database_principal ='ALTER AUTHORIZATION ON ROLE::['+@dp_name+ '] TO [dbo]'
                                       print @sql_database_principal 
                                       exec(@sql_database_principal )
                                       fetch next from c_database_principal into @dp_name
                                      end
                                      close c_database_principal
                                      deallocate c_database_principal
    
                                      -- drop roles for user 
                                      declare @role_name varchar(max) 
                                      declare c_role cursor for 
                                       select dp.name--,USER_NAME(member_principal_id)
                                       from sys.database_role_members drm
                                       inner join sys.database_principals dp 
                                       on dp.principal_id= drm.role_principal_id
                                       where USER_NAME(member_principal_id)=@user 
                                      open c_role 
                                      fetch next from c_role into @role_name
                                      while (@@FETCH_STATUS=0)
                                      begin
                                       declare @sql_role varchar(max)
                                       select @sql_role='EXEC sp_droprolemember N'''+@role_name+''', N'''+@user+''''
                                       print @sql_role
                                       exec (@sql_role)
                                       fetch next from c_role into @role_name
                                      end
                                      close c_role
                                      deallocate c_role   
      
                                      -- drop user
                                      declare @sql_user varchar(max)
                                      set @sql_user='DROP USER ['+@user +']'
                                      print @sql_user
                                      exec (@sql_user)
                                      fetch next from c_orphaned_user into @user
                                     end
                                     close c_orphaned_user
                                     deallocate c_orphaned_user
                                     set nocount off
                                    end
                                    go
                                    -- mark stored procedure as a system stored procedure
                                    exec sys.sp_MS_marksystemobject sp_Drop_OrphanedUsers
                                    go

                                    USE ["+$DBName+"]
                                    GO
                                    EXEC sp_Drop_OrphanedUsers"

                    Invoke-Sqlcmd -Database $DBName -Query $queryDrop -ServerInstance $Instance 
                    }catch{
                        Write-Host "Orphan User dropped Failed"
                        $T_Status.Text = "Orphan User dropped Failed"
                    }
                    try{
                        $Result1 = Invoke-Sqlcmd -Database $DBName -Query $Result -ServerInstance $Instance 
                        $T_Status.Text = "DB Refresh Successfull"
                    }catch{
                        Write-Host "Failed. Previous Roles applied"
                        $T_Status.Text = "Failed. Previous Roles applied"
                    }
} else{
    $T_Status.Text = "Copied Failed. Can't proceed."
}
} 

function FetchAll {
       Write-Host "Prod Backup called." 
       FetchP
       Write-Host "Copy Backup File at mentioned path Called."
       FetchC
       Write-Host "Restore at detination Called."
       FetchR
} 

$First_Run.Add_Click({ FetchP })
$Copy_Backup.Add_Click({ FetchC })
$Second_Run.Add_Click({ FetchR })
$Start.Add_Click({ FetchAll })


[void]$DB_Refresh.ShowDialog()
