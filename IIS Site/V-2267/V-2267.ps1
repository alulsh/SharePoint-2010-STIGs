<#
Applies finding V-2267 from the IIS 7 Site STIG
Title: Web server/site administration must be performed over a secure path.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_site/2014-03-25/finding/V-2249

Blacklist comes from Bugra Postaci - blog.bugrapostaci.com
http://blog.bugrapostaci.com/2011/10/27/how-to-remove-unnecessery-handler-mappings-from-sharepoint-2010-web-application-for-security-purpose/

#>

function Set-HandlerMappings {

    Import-Module WebAdministration

    $handlerMappings = Import-CSV 'BlackList.csv'

    foreach ($handlerMapping in $handlerMappings) {

        Remove-WebHandler -Name $handlerMapping.Name

        Write-Host Removing $handlerMapping.Name

    }

}