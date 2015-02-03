<#
Applies finding V-26034 from the IIS 7 Site STIG
Title: The production web-site must configure the Global .NET Trust Level.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_site/2014-03-25/finding/V-26034
#>

function Set-GlobalTrustLevel {

    $configuration = "/system.web/trust"
    $sharepointWebServices = Get-Website -Name "SharePoint Web Services"
    
    # Configure .NET Global Trust level at the server level #

    C:\Windows\System32\inetsrv\appcmd.exe Set Config /Commit:WEBROOT /Section:Trust /Level:Medium

    Set-WebConfigurationProperty -Filter $configuration -Name Level -Value Medium

    if ($sharepointWebServices) {

        Set-WebConfigurationProperty -Filter $configuration -Name Level -Value Full -PSPath "IIS:\Sites\SharePoint Web Services"

    }

}