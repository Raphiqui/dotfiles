$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = "D:\Dev\Backups\ubuntu_backup.tar"
$logFile = "D:\Dev\Backups\wsl_backup_log.txt"

Add-Content -Path $logFile -Value "`n[$timestamp] Starting backup of Debian to $backupFile"

wsl.exe --export Ubuntu-24.04 $backupFile
