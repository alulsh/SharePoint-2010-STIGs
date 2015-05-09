<#
Applies finding V-2261 from the IIS 7 Server STIG
Title: A web server must limit e-mail to outbound only.
Reference: http://stigviewer.net/stig/iis_7.0_web_server/2014-03-11/finding/V-2261
#>

function Disable-SMTP {

    Import-Module ServerManager

    $SMTP = Get-WindowsFeature SMTP-Server

    if ($SMTP.Installed -eq $true) {

        Write-Host Server is not STIG compliant - uninstalling SMTP service
        Remove-WindowsFeature SMTP-server
        Write-Host SMTP service uninstalled

    }

    else {

        Write-Host Server is STIG compliant - SMTP service is not installed

    }

}