<#
Script mitigates the following SQL Server Instance STIGs:
V-40952, V-40953, V-41016, V-41017
#>

function Harden-SQLServerAuditing ($serverName,$instanceName) {

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

    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection "server=$serverName;database=master;Integrated Security=SSPI"
    $sqlConnection.Open()

    $sqlCommand = $sqlConnection.CreateCommand()

    $query = @"
        SELECT DISTINCT
        LEFT(path, (LEN(path) - CHARINDEX('\',REVERSE(path)) + 1)) AS "Audit Path"
        FROM sys.traces
        SELECT log_file_path AS "Audit Path"
        FROM sys.server_file_audits
"@

    $sqlCommand.CommandText = $query

    $sqlReader = $sqlCommand.ExecuteReader()

    # Create an array for results #
    $auditPaths = @()

    while ($sqlReader.Read()) {

        # Push results of command to the array #

        $auditPaths += $sqlReader["Audit Path"]

    }

    $sqlConnection.Close()

    # Using results from the array, remove Local Users group from locations #

    foreach ($path in $auditPaths) {

        Write-Output "Audit file location is $path"

        disableInheritance $path
        
        grantPermissions $env:username $path "FullControl"

        removePermissions "BUILTIN\USERS" $path
        removePermissions "CREATOR OWNER" $path
        removePermissions "SYSTEM" $path

        grantPermissions $sqlServerAccount $path "FullControl"
        grantPermissions $sqlAgentAccount $path "Read,ReadAndExecute,Write"

        removePermissions "BUILTIN\Administrators" $Path
        removePermissions "BUILTIN\Administrators" $path "Read"

        removePermissions $env:username $path

    }

}