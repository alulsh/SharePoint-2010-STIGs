<#
Applies finding V-13702 from the IIS 7 Site STIG
Title: The Content Location header must not contain proprietary IP addresses.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_site/2014-03-25/finding/V-13702
#>

function Set-AlternateHostName {

    $fqdn = "$env:computername.$env:userdnsdomain"

    $websites = Get-WebSite

    foreach($website in $websites){

        $siteName = $website.Name

        $runtimeConfig = Get-WebConfiguration -Filter "/system.webServer/serverRuntime" -Location $siteName

        if(!$runtimeConfig.alternateHostName){

            Write-Host $siteName - Not STIG compliant - alternateHostName is blank

            Set-WebConfigurationProperty -Filter "/system.webServer/serverRuntime" -Name alternateHostName -Value $fqdn

        }

        else {

            Write-Host $siteName - STIG compliant - alternateHostName is $runtimeConfig.alternateHostName

        }

    }

}