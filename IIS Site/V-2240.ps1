<#
Applies finding V-2240 from the IIS 7 Site STIG
Title: Web sites must limit the number of simultaneous requests.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_site/2014-03-25/finding/V-2240
#>

function Set-MaxConnections {

    $serverConfiguration = "/system.applicationHost/sites/*"
    $maxConnections = 4294967294

    $applicationHosts = Get-WebConfiguration -Filter $serverConfiguration

    foreach ($application in $applicationHosts) {

        $name = $application.Name

        Set-WebConfigurationProperty -Filter $serverConfiguration -Name Limits -Value @{MaxConnections=$maxConnections}

    }

}