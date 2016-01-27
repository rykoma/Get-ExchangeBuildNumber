function Get-ExchangeBuildNumber($ProductName)
{
	$FileName = [Environment]::GetFolderPath('MyDocuments') + "`\Get-ExchangeBuildNumber`\ExchangeBuildNumbers.csv"
	if(!(Test-Path $Dest))
	{
		Update-ExchangeBuildNumberDefinition
	}
	
	$Builds = Import-Csv $FileName

	foreach($Build in $Builds)
	{
		if($Build."Product Name" -like "*$ProductName*")
		{
			Write-Output ($Build."Product Name" + " : " + $Build."Build Number")
		}
	}
}

function Update-ExchangeBuildNumberDefinition()
{
	$Dest = [Environment]::GetFolderPath('MyDocuments') + "`\Get-ExchangeBuildNumber"
	
	if(!(Test-Path $Dest))
	{
		New-Item $Dest -Type directory > $Null
	}
	
	$FileName = $Dest + "`\ExchangeBuildNumbers.csv"
    Invoke-WebRequest -Uri "http://get-exchangebuildnumber.azurewebsites.net/ExchangeBuildNumbers.csv" -OutFile $FileName
}