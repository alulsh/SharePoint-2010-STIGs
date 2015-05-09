<#
Applies finding V-6537 from the IIS 7 Server STIG
Title: Anonymous access accounts must be restricted.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_server/2014-03-11/finding/V-6537
#>

function Disable-AnonymousAccess {

    $serverConfiguration = "/system.webServer/security/authentication/AnonymousAuthentication"
    $anonymousAuthentication = Get-WebConfiguration -Filter $serverConfiguration

    if ($anonymousAuthentication.Enabled -eq "True") {

        Write-Output "Disabling anonymous authentication at the IIS server level"

        Set-WebConfigurationProperty -Filter $serverConfiguration -Value (@{enabled="False"})
    
    }

    $websites = Get-Website

    foreach ($website in $websites) {

        $siteName = $website.Name
        
        Write-Output "Setting anonymous authentication enabled to false for $siteName"

        Set-WebConfiguration -Filter $serverConfiguration -Value (@{enabled="False"}) -PSPath IIS:\ -Location $siteName

    }

}