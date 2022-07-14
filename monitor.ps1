# Set Datto UDF field number (remove # after testing)
$Customfield = "Custom"#+$ENV:UDFNumber
$folder = "C:\Users\Public\PublicScripts"

# Check whether anyone is logged on
If ($explorerprocesses.Count -eq 0)
{
	# Set UDF if no one is logged on
	New-ItemProperty "HKLM:\SOFTWARE\CentraStage" -Name $Customfield -PropertyType string -value ("Logged off ("+(Get-Date -format "MM/dd/yyyy HH:mm")+")") -Force
}

# If someone is logged on...
Else
{
	# Get and format the contents of output.txt (created from scheduled task)
	$idleTimeString = Get-Content $folder\output.txt
	$idleTime = $idleTimeString -as [timespan]
	
	# Set UDF based on whether idle time is over or under 5 minutes
	If ($idleTime -le [timespan]"00:00:05:00")
	{
		New-ItemProperty "HKLM:\SOFTWARE\CentraStage" -Name $Customfield -PropertyType string -value ("Active ("+(Get-Date -format "MM/dd/yyyy HH:mm")+")") -Force
	}
	Else
	{
		New-ItemProperty "HKLM:\SOFTWARE\CentraStage" -Name $Customfield -PropertyType string -value ("Idle ("+(Get-Date -format "MM/dd/yyyy HH:mm")+")") -Force
	}
}

# Datto monitor requires exit code
Exit 0