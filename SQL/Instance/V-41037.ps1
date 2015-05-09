<#
Applies V-41037 from the SQL 2012 Instance STIG
Title: SQL Server default account sa must have its name changed
#>

function Rename-SaAccount ($serverName, $newName) {

    $SQLServer = New-Object "Microsoft.SQLServer.Management.Smo.Server" $serverName

    # SA Account has a SID and ID of 1 even when it has been renamed #

    $saAccount = $SQLServer.Logins | Where-Object {$_.Id -eq 1 and $_.Name -eq "sa"}

    if ($saAccount) {

        Write-Output "Not STIG compliant - Default SA account has not been renamed"

        $saAccount.Rename($saAccount)

    }

    else {

        Write-Output "STIG Compliant - SA account was renamed to $saAccount.Name"

    }

}