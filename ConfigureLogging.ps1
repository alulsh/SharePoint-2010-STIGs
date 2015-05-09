# Import permissions functions #
. "\Utilities\PermissionsFunctions.ps1"

# Load IIS module and SharePoint snapin #
Import-Module WebAdministration
Add-PSSnapin Microsoft.SharePoint.PowerShell

# Set log file paths #
$diagnosticLogs = "L:\Diagnostic"
$usageLogs = "L:\Usage"
$iisLogs = "L:\inetpub\"

$doIisLogsExist = Test-Path -Path $iisLogs

if (! $doIisLogsExist) {

    Write-Host IIS log folder does not exist - creating $iisLogs
    New-Item -ItemType Directory -Path $iisLogs

}

# Disable inheritance and remove non-STIG compliant permissions #

Disable-PermissionsInheritance $iisLogs

Remove-NtfsPermissions "CREATOR OWNER" $iisLogs
Remove-NtfsPermissions "BUILTIN\Users" $iisLogs

icacls $iisLogs+"*" /q /c /t /reset

#Configure IIS logging #

Set-WebConfigurationProperty "/system.applicationHost/sites/siteDefaults" -Name logfile.directory -Value $iisLogs

# Configure SharePoint logging #

Set-SPDiagnosticConfig -DaysToKeepLogs 14 -LogMaxDiskSpaceUsageEnabled:$true -LogDiskSpaceUsageGB "5" -LogLocation $diagnosticLogs
Set-UsageService -UsageLogLocation $usageLogs -UsageLogMaxSpaceGB "5"