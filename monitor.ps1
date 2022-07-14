# Set Datto UDF field number (remove # after testing)
$Customfield = "Custom"#+$ENV:UDFNumber

If ($explorerprocesses.Count -eq 0)
{
	# Set UDF as "Logged off" if no one is logged on
	New-ItemProperty "HKLM:\SOFTWARE\CentraStage" -Name $Customfield -PropertyType string -value ("Logged off ("+(Get-Date -format "MM/dd/yyyy HH:mm")+")") -Force
}
Else
{
	$idleTimeString = Get-Content C:\Users\Public\output.txt
	$idleTime = $idleTimeString -as [timespan]
	
	If ($idleTime -le [timespan]"00:00:05:00")
	{
		New-ItemProperty "HKLM:\SOFTWARE\CentraStage" -Name $Customfield -PropertyType string -value ("Active ("+(Get-Date -format "MM/dd/yyyy HH:mm")+")") -Force
	}
	Else
	{
		New-ItemProperty "HKLM:\SOFTWARE\CentraStage" -Name $Customfield -PropertyType string -value ("Idle ("+(Get-Date -format "MM/dd/yyyy HH:mm")+")") -Force
	}
}

Exit 0