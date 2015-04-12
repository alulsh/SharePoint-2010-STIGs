<#
Mitigates the following SQL 2012 Instance STIGs:
V-41021, V-41027, V-41028, V-41029, V-41030, V-41031, V-41032, V-41033, V-41035, V-41306, V-41307
Mitigates V-41402 from the SQL 2012 Database STIG
Summary: Runs ConfigureAuditing.sql and then executes the stored procedure
#>

function Set-SQLServerAuditing ($scriptFile, $serverName, $instanceName, $traceFile, $maxFileSize, $fileCount) {

    $cleanTraceFilePath = $traceFile.Replace("'","")
    $traceFolder = [System.IO.Path]::GetDirectoryName($cleanTraceFilePath)

    if ($instanceName -eq "MSSQLSERVER") {

        $sqlServerAccount = "NT SERVICE\MSSQLSERVER"
        $sqlAgentAccount = "NT SERVICE\SQLSERVERAGENT"

    }

    else {

        $sqlServerAccount = "NT SERVICE\MSSQL`$$instanceName"
        $sqlAgentAccount = "NT SERVICE\SQLAGENT`$$instanceName"

    }

    if (!(Test-Path $traceFolder)) {

        Write-Output "Folder does not exist - creating $traceFolder for SQL audit logs"

        # Create the folder #

        New-Item $traceFolder -Type GetDirectoryName

        # Grant permissions to database engine and SQL Agent accounts #

        grantPermissions $sqlServerAccount $traceFolder "FullControl"
        grantPermissions $sqlAgentAccount $traceFolder "Read,ReadAndExecute,Write"

    }

    else {

        Write-Output "$traceFolder already exists, granting permissions to SQL database engine and SQL agent service accounts"

        # Grant permissions to database engine and SQL Agent accounts #

        grantPermissions $sqlServerAccount $traceFolder "FullControl"
        grantPermissions $sqlAgentAccount $traceFolder "Read,ReadAndExecute,Write"

    }

    $traceParam1 = "traceFile=" + $traceFile
    $traceParam2 = "maxFileSize=" + $maxFileSize
    $traceParam3 = "fileCount=" + $fileCount

    $traceParams = $traceParam1, $traceParam2, $traceParam3

    Invoke-Sqlcmd -InputFile $scriptFile -Variable $traceParams -ServerInstance $serverName

    Invoke-Sqlcmd -Query "EXEC master.dbo.STIG_Audits" -ServerInstance $serverName

}