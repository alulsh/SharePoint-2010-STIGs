<#
Applies finding V-2249 from the IIS 7 Site STIG
Title: Web server/site administration must be performed over a secure path.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_site/2014-03-25/finding/V-2249
#>

function Enable-NetworkLevelAuthentication {

    $terminalServerSettings = Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices

    if ($terminalServerSettings.UserAuthenticationRequired -eq 0) {

        Write-Host Not STIG compliant - Network Level Authentication not enabled
        $terminalServerSettings.SetUserAuthenticationRequired(1)
        Write-Host Network level authentication enabled 

    }

    else {

        Write-Host STIG Compliant - Network Level Authentication already enabled for Remote Desktop

    }

}