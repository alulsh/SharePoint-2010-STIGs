<#
Applies finding V-26046 from the IIS 7 Site STIG
Title: The production web-site must filter unlisted file extensions in URL requests.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_site/2014-03-25/finding/V-26046
#>

function Disabled-UnlistedFileExtensions {

    $serverConfiguration = "/system.webServer/security/requestFiltering/fileExtensions"
    $requestFiltering = Get-WebConfiguration -Filter $serverConfiguration

    if ($requestFiltering.allowUnlisted -eq "True") {

        Write-Output "Not STIG compliant - Unlisted file extensions are allowed"

        $requestFiltering.allowUnlisted = $false
        $requestFiltering | Set-WebConfiguration -Filter $serverConfiguration -PSPath IIS:\

    }

    else {

        Write-Output "Server setting is STIG compliant - Checking IIS sites now"

    }

}

function Add-FileExtension ($extension,$isAllowed) {

    C:\Windows\System32\inetsrv\appcmd.exe set config -section:system.webServer/security/requestFiltering /+"fileExtensions.[fileExtension='$extension',allowed='$isAllowed']"

}

function Add-AllowedFileExtensions {

    $allowedExtensions = Import-CSV -Path "AllowedFileExtensions.csv"

    foreach ($extension in $allowedExtensions) {

        Write-Output "Setting $($extension.fileExtension) to allowed in Request Filtering"

        Add-FileExtension $extension.fileExtension $extension.Allowed

    }

}