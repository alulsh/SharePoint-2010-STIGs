<#
Applies finding V-26045 from the IIS 7 Site STIG
Title: The web-site must not allow double encoded URL requests.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_site/2014-03-25/finding/V-26045
#>

function applyDoubleEscapingURLs {

    $serverConfig = "/system.webServer/security/requestFiltering"

    $requestFiltering = Get-WebConfiguration -Filter $serverConfig

    if($requestFiltering.allowDoubleEscaping -eq $true){

        Write-Host Server configuration is not STIG compliant - setting double escaping to false

        $requestFiltering.allowDoubleEscaping = $false
        $requestFiltering | Set-WebConfiguration -Filter $serverConfig -PSPath IIS:\

    }

    else{

        Write-Host Server configuration is STIG Compliant - allow double escaping already set to false

    }

    $websites = Get-Website

    foreach($website in $websites){

        $siteName = $website.Name

        $requestFiltering = Get-WebConfiguration -Filter $serverConfig -Location $siteName

        if ($requestFiltering.allowDoubleEscaping -eq $true){

            Write-Host $siteName is not STIG compliant - setting allow double escaping to false

            Set-WebConfigurationProperty -Filter $serverConfig -Name allowDoubleEscaping -Value False -PSPath IIS:\sites\$siteName

        }

        else {

            Write-Host $siteName is STIG compliant - allow double escaping is already set to false

        }

    }

}