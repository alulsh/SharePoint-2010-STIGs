<#
Applies finding V-26044 from the IIS 7 Site STIG
Title: The web-site must not allow non-ASCII characters in URLs.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_site/2014-03-25/finding/V-26044
#>

function Set-HighBitCharacters {

    $serverConfig = "/system.webServer/security/requestFiltering"

    $requestFiltering = Get-WebConfiguration -Filter $serverConfig

    if($requestFiltering.allowHighBitCharacters -eq $true){

        Write-Host Server configuration is not STIG compliant - setting allow high bit characters to false

        $requestFiltering.allowHighBitCharacters = $false
        $requestFiltering | Set-WebConfiguration -Filter $serverConfig -PSPath IIS:\

    }

    else{

        Write-Host Server configuration is STIG Compliant - allow high bit characters already set to false

    }

    $websites = Get-Website

    foreach($website in $websites){

        $siteName = $website.Name

        $requestFiltering = Get-WebConfiguration -Filter $serverConfig -Location $siteName

        if ($requestFiltering.allowHighBitCharacters -eq $true){

            Write-Host $siteName is not STIG compliant - setting allow high bit characters to false

            Set-WebConfigurationProperty -Filter $serverConfig -Name allowHighBitCharacters -Value False -PSPath IIS:\sites\$siteName

        }

        else {

            Write-Host $siteName is STIG compliant - allow high bit chracters is already set to false

        }

    }

}