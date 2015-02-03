# This script needs additional testing #

<#
Applies finding V-13621 from the IIS 7 Server STIG
Title: All web server documentation, sample code, example applications, and tutorials must be removed from a production web server.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_server/2013-04-11/finding/V-13621
#>

function Remove-SampleCode {
    
    $iisRootFolder = "C:\inetpub"
    $adminScriptsFolder = $iisRootFolder+"\AdminScripts"
    $0409Folder = $adminScriptsFolder+"\0409\"
    $sampleFolder = $iisRootFolder+"\scripts\IISSamples"
    $msadcFolder = "C:\Program Files\Common Files\system\msadc"

    Set-Location $iisRootFolder

    if (Test-Path "AdminScripts") {

        Write-Host AdminScripts subfolder found in $iisRootFolder - deleting files and subfolders

        takeown /f AdminScripts /r /d y

        if (Test-Path $0409Folder) {

            takeown /f $0409Folder /r /d y
            CMD /c "icacls $0409Folder /grant BUILTIN\Administrators:(OI)(CI)F"
            Remove-Item $0409Folder+"\*" -Recurse

        }

        Remove-Item $adminScriptsFolder+"\*" -Recurse
        Remove-Item $adminScriptsFolder

        Write-Host $0409Folder and $adminScriptsFolder deleted

    }

    else {

        Write-Host $adminScriptsFolder does not exist - nothing to delete

    }

    if (Test-Path $sampleFolder) {

        Write-Host $sampleFolder found - deleting 

    }

    else {

        Write-Host $sampleFolder does not exist

    }

    if (Test-Path $msadcFolder) {

        Write-Host $msadcFolder exists - deleting

        Set-Location "C:\Program Files\Common Files\System\"
        takeown /f msadc /r /d y
        icacls msadc /grant Administrators:f /t /q
        Remove-Item $msadcFolder -Recurse

    }

    else {

        Write-Host $msadcFolder does not exist

    }

}