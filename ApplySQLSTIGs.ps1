# Host name of the SQL Server to be STIGed #
$hostname = "SQLServerHostName"

# Instance name of the SQL Server to be STIGed #
# If the default instance, set equal to MSSQLSERVER #
$instanceName = "MSSQLSERVER"

# Number of max connections for V-41422 #
$maxConnections = 3000

# New name of SA account #
$newName = "SharePointSA"

# Trace audit file variables #
# The folder must already exist or else SQL Server will throw an error creating the trace #
$traceFile = "'H:\STIG\STIG_Trace'"
$maxFileSize = 500
$fileCount = 10

# Location where STIG Scripts copied #
$folderRoot = "C:\STIG_Scripts\"
$ConfigureAuditingScript = "C:\STIG_Scripts\SQL\ConfigureAuditing.sql"

if ($instanceName -EQ "MSSQLSERVER") {

    $sqlServerName = $hostname

}

else {

    $sqlServerName = Join-Path -Path $hostname -ChildPath $instanceName

}

# Load SQL 2012 Module #

Import-Module sqlps -DisableNameChecking

# Load permissions functions #

Write-Output "`n----- Importing permissions functions -----"

. (Join-Path $folderRoot "SQL\Database\V-41422.ps1")
. (Join-Path $folderRoot "SQL\Instance\V-40936.ps1")
. (Join-Path $folderRoot "SQL\Instance\V-40944.ps1")
. (Join-Path $folderRoot "SQL\Instance\V-40950.ps1")
. (Join-Path $folderRoot "SQL\Instance\V-41037.ps1")
. (Join-Path $folderRoot "SQL\Instance\V-54589.ps1")
. (Join-Path $folderRoot "SQL\RevokePermissions.ps1")
. (Join-Path $folderRoot "SQL\ConfigureAuditing.ps1")
. (Join-Path $folderRoot "SQL\HardenAuditing.ps1")
. (Join-Path $folderRoot "SQL\SSL\GenerateCSR.ps1")

# Call functions to apply SQL 2012 STIGs #

Write-Output "`n----- Applying STIGs for SQL 2012 -----"

Write-Output "`n----- Applying V-41422 for SQL 2012 Database -----"

Set-MaxConnections $sqlServerName $maxConnections

Write-Output "`n----- Applying V-40936 for SQL 2012 Instance -----"

Disable-SaAccount $sqlServerName

Write-Output "`n----- Configuring SQL Server Auditing -----"

Set-SQLServerAuditing $ConfigureAuditingScript $sqlServerName $instanceName $traceFile $maxFileSize $fileCount

Write-Output "`n----- Applying V-40944 for SQL 2012 Instance -----"

Set-SQLSoftwareLibrariesPermissions $instanceName

Write-Output "`n----- Applying V-40950 for SQL 2012 Instance -----"

Enable-FileAuditing $instanceName

Write-Output "`n----- Applying V-41037 for SQL 2012 Instance -----"

Rename-SaAccount $sqlServerName $newName

Write-Output "`n----- Applying V-41247 for SQL 2012 Instance -----"

Remove-Permisions $sqlServerName "AlterAnyAvailabilityGroup"

Write-Output "`n----- Applying V-41251 for SQL 2012 Instance -----"

Remove-Permisions $sqlServerName "ViewAnyDatabase"

Write-Output "`n----- Applying V-41294 for SQL 2012 Instance -----"

Remove-Permisions $sqlServerName "ViewServerState"

Write-Output "`n----- Applying V-54589 for SQL 2012 Instance -----"

Set-SQLDataRootDirectoryPermissions $instanceName

Write-Output "`n----- Harden SQL Server Auditing -----"

Harden-SQLServerAuditing $sqlServerName $instanceName

Write-Output "`n----- Generate CSR for SQL Server SSL Certificate -----"

New-CertificateSigningRequest