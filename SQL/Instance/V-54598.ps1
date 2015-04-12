<#
Applies V-54598 from the SQL 2012 Instance STIG
Summary: Limit permissions on the SQL Server data root directory
#>

function Set-SQLDataRootDirectoryPermissions ($instanceName) {

    $sqlDataRoot = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL11.$instanceName\Setup\").SqlDataRoot

    # Remove local users groups from SqlDataRoot #

    if (Test-Path $sqlDataRoot) {

        removePermissions "BUILTIN\USERS" $sqlDataRoot

        Write-Output "Removed local users group from $sqlDataRoot"

    }

    else {

        Write-Output "$sqlDataRoot does not exist"

    }

}