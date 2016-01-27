function Get-ExchangeBuildNumber
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$True)]
        [string]$ProductName
    )

    Begin
    {
        function CreateLogString
        {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$True)]
                [string]$Message
            )

            return (Get-Date).ToUniversalTime().ToString("[HH:mm:ss.fff") + " GMT] Get-ExchangeBuildNumber : " + $Message
        }

        function Setup
        {
            Write-Verbose (CreateLogString "Beginning processing.")

            Set-Variable -Name FileName -Value ([Environment]::GetFolderPath('MyDocuments') + "`\Get-ExchangeBuildNumber`\ExchangeBuildNumbers.csv") -Scope 1

	        if(!(Test-Path $FileName))
	        {
                Write-Verbose (CreateLogString "Definition file was not found. Invoke Update-ExchangeBuildNumberDefinition to download definition file.")
		        Update-ExchangeBuildNumberDefinition
	        }

            Set-Variable -Name SetupDone -Value $true -Scope 1

            Write-Verbose (CreateLogString "Setup was completed.")
        }

        Setup
    }

    Process
    {
        if (-not $SetupDone) { Setup }

        Write-Verbose (CreateLogString "Import definition file.")

        $Builds = Import-Csv $FileName
        $Found = $false

	    foreach($Build in $Builds)
	    {
		    if($Build."Product Name" -like "*$ProductName*")
		    {
			    Write-Output ($Build."Product Name" + " : " + $Build."Build Number")
                $found = $true
		    }
	    }

        if (-not $found)
        {
            Write-Verbose (CreateLogString "Nothing was found.")
        }
    }

    End {}
}

function Get-ExchangeProductName
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$True)]
        [System.Version]$BuidNumber
    )

    Begin
    {
        function CreateLogString
        {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$True)]
                [string]$Message
            )

            return (Get-Date).ToUniversalTime().ToString("[HH:mm:ss.fff") + " GMT] Get-ExchangeProductName : " + $Message
        }

        function Setup
        {
            Write-Verbose (CreateLogString "Beginning processing.")

            Set-Variable -Name FileName -Value ([Environment]::GetFolderPath('MyDocuments') + "`\Get-ExchangeBuildNumber`\ExchangeBuildNumbers.csv") -Scope 1

	        if(!(Test-Path $FileName))
	        {
                Write-Verbose (CreateLogString "Definition file was not found. Invoke Update-ExchangeBuildNumberDefinition to download definition file.")
		        Update-ExchangeBuildNumberDefinition
	        }

            Set-Variable -Name SetupDone -Value $true -Scope 1

            Write-Verbose (CreateLogString "Setup was completed.")
        }

        Setup
    }

    Process
    {
        if (-not $SetupDone) { Setup }

        Write-Verbose (CreateLogString "Import definition file.")

        $Builds = Import-Csv $FileName | Select "Product Name", @{n="Build Number";e={$Version = [System.Version]$_."Build Number"; $Version.Revision + $Version.Build * 1000 + $Version.Minor * 10000000 + $Version.Major * 1000000000}}, @{n="Version";e={[System.Version]$_."Build Number"}}
        $BuildString = $BuidNumber.Revision + $BuidNumber.Build * 1000 + $BuidNumber.Minor * 10000000 + $BuidNumber.Major * 1000000000 
        $Found = 0
        $LessThen = 0

	    for($i = 0; $i -le $Builds.Length; $i++)
	    {
		    if($BuildString -lt $Builds[$i]."Build Number")
		    {
			    $LessThen = $i
                break
            }
            elseif($BuildString -eq $Builds[$i]."Build Number")
            {
                return $Builds[$i]."Product Name" + " : " + $Builds[$i].Version
            }
	    }

        if (($LessThen -ne 0))
        {
            return $BuidNumber.ToString() + " is greater than " + $Builds[$LessThen - 1]."Product Name" + " and less then" + $Builds[$LessThen]."Product Name"
        }
        else
        {
            return "Nothing was found."
        }
    }

    End {}
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