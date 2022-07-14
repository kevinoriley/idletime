# Set variables
$taskName = "IdleTime"
$folder = "C:\Users\Public\PublicScripts"

# Create folder and files, if necessary
If (!(Test-Path -PathType container $folder))
{
	New-Item -ItemType Directory -Path $folder
}

If (!(Test-Path -Path $folder\psrun.vbs))
{
	Copy-Item psrun.vbs -Destination $folder\psrun.vbs
}

If (-not(Test-Path -Path $folder\idlecheck.ps1))
{
	Copy-Item idlecheck.ps1 -Destination $folder\idlecheck.ps1
}

# Delete old task
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Ignore

# Create new task
$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "$folder\psrun.vbs $folder\idlecheck.ps1"
$trigger = New-ScheduledTaskTrigger -Once -At 12am -RepetitionDuration  (New-TimeSpan -Days 1)  -RepetitionInterval  (New-TimeSpan -Minutes 5)
$principal = New-ScheduledTaskPrincipal -UserId (Get-CimInstance –ClassName Win32_ComputerSystem | Select-Object -expand UserName)
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
Register-ScheduledTask IdleTime -InputObject $task