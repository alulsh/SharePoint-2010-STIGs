<#
Applies finding V-40936 from the SQL Server 2012 Instance STIG
Title: SQL Server default account sa must be disabled
#>

function Disable-SaAccount ($serverName) {

    $SQLServer = New-Object "Microsoft.SQLServer.Management.Smo.Server" $serverName

    # SA Account has a SID and ID of 1 even when it has been renamed #

    $saAccount = $SQLServer.Logins | Where-Object {$_.Id -eq 1}

    if (!$saAccount.isDisabled) {

        Write-Output "Not STIG compliant - Default SA account is enabled - Disabling"

        $saAccount.Disable()

    }

    else {

        Write-Output "STIG Compliant - SA account is already disabled"

    }

}