<#
Applies V-40944 from the SQL 2012 Instance STIG
Title: The OS must limit privileges to change SQL Server software resident within software libraries (including privileged programs).
Summary: Limits permissions on the SQL Server binn, install, and shared code directories
#>

function Set-SQLSoftwareLibrariesPermissions ($instanceName) {

    # Get service accounts based on instance name #

    if ($instanceName -eq "MSSQLSERVER") {

        $sqlServerAccount = "NT SERVICE\MSSQLSERVER"
        $sqlAgentAccount = "NT SERVICE\SQLSERVERAGENT"
        $fullTextAccount = "NT SERVICE\MSSQLFDLauncher"

    }

    else {

        $sqlServerAccount = "NT SERVICE\MSSQL`$$instanceName"
        $sqlAgentAccount = "NT SERVICE\SQLAGENT`$$instanceName"
        $fullTextAccount = "NT SERVICE\MSSQLFDLauncher`$$instanceName"

    }

    # Registry keys for folder locations #

    $sqlInstallation = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL11.$instanceName\Setup\").SqlProgramDir
    $instanceInstallation = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL11.$instanceName\Setup\").SqlPath
    $binnFolder = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL11.$instanceName\Setup\").SQLBinRoot
    $sharedCodeFolder = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\110\").sharedCodeFolder
    $installFolder = "$instanceInstallation\Install"

    if (Test-Path $binnFolder) {

        Write-Output "$binnFolder exists in $instanceInstallation"

        disableInheritance $binnFolder
        removePermissions "BUILTIN\Users" $binnFolder
        grantPermissions $sqlServerAccount $binnFolder "Read,ReadAndExecute"
        grantPermissions $sqlAgentAccount $binnFolder "FullControl"

    }

    else {

        Write-Output "$binnFolder does not exist in $instanceInstallation"

    }

    if (Test-Path $sharedCodeFolder) {

        Write-Output "$sharedCodeFolder exists"

        Set-Location $sharedCodeFolder
        Set-Location ..

        takeown /f Shared /a

        disableInheritance $sharedCodeFolder
        removePermissions "BUILTIN\USERS" $sharedCodeFolder

        grantPermissions $sqlServerAccount $sharedCodeFolder "Read,ReadAndExecute"
        grantPermissions $sqlAgentAccount $sharedCodeFolder "Read,ReadAndExecute,Write"
        grantPermissions $fullTextAccount $sharedCodeFolder "Read,Write"

    }

    else {

        Write-Output "$sharedCodeFolder does not exist"

    }

    if (Test-Path $installFolder) {

        Write-Output "$installFolder exists in $instanceInstallation"

        disableInheritance $installFolder
        removePermissions "BUILTIN\Users" $installFolder
        grantPermissions $sqlServerAccount $binnFolder "Read,ReadAndExecute"

    }

    else {

        Write-Output "$installFolder does not exist in $instanceInstallation"

    }

}