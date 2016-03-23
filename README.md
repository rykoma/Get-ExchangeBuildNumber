# Get-ExchangeBuildNumber

You can search build numbers of Exchange Server.

## Usage

1. Download Get-ExchangeBuildNumber.ps1
2. Unzip the file.
3. Run following command and load Get-ExchangeBuildNumber Cmdlet.

  . D:\GitHub\Get-ExchangeBuildNumber\Get-ExchangeBuildNumber.ps1

4. If you want to know the build number of Exchange 2013 CU11, run following command.

  Get-ExchangeBuildNumber -ProductName "Exchange 2013 CU11"

5. If you want to know the product name of 15.0.1156.6, run following command.

  Get-ExchangeProductName 15.0.1156.6

6. You can update the definition file by following command.

  Update-ExchangeBuildNumberDefinition
