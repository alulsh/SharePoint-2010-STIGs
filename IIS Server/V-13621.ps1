# This script needs additional testing #

<#
Applies finding V-13621 from the IIS 7 Server STIG
Title: All web server documentation, sample code, example applications, and tutorials must be removed from a production web server.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_server/2013-04-11/finding/V-13621
#>

function Remove-SampleCode {
    
    $iisRootFolder = "C:\inetpub"
    $adminScriptsFolder = Join-Path -Path $iisRootFolder -ChildPath "AdminScripts"
    $0409Folder = Join-Path -Path $adminScriptsFolder -ChildPath "0409"
    $sampleFolder = Join-Path -Path $iisRootFolder -ChildPath "scripts\IISSamples"
    $msadcFolder = "C:\Program Files\Common Files\system\msadc"

    Set-Location $iisRootFolder

    if (Test-Path $adminScriptsFolder) {

        Write-Output Not STIG compliant - AdminScripts subfolder found in $iisRootFolder - deleting files and subfolders

        takeown /f AdminScripts /r /d y

        if (Test-Path $0409Folder) {

            takeown /f $0409Folder /r /d y
            CMD /c "icacls $0409Folder /grant BUILTIN\Administrators:(OI)(CI)F"
            
            Push-Location $0409Folder
            Get-ChildItem * -Recurse | Remove-Item
            Pop-Location

            Write-Output $0409Folder deleted

        }

        Push-Location $adminScriptsFolder
        Get-ChildItem * -Recurse | Remove-Item
        Pop-Location

        Remove-Item $adminScriptsFolder -Recurse

        Write-Output $adminScriptsFolder deleted

    }

    else {

        Write-Output $adminScriptsFolder does not exist - nothing to delete

    }

    if (Test-Path $sampleFolder) {

        Write-Host $sampleFolder found - deleting 

        Push-Location $sampleFolder
        Get-ChildItem * -Recurse | Remove-Item
        Pop-Location

        Remove-Item $sampleFolder -Recurse

        Write-Output $sampleFolder deleted

    }

    else {

        Write-Output $sampleFolder does not exist

    }

    if (Test-Path $msadcFolder) {

        Write-Output $msadcFolder exists - deleting

        Set-Location "C:\Program Files\Common Files\System\"
        
        takeown /f msadc /r /d y
        icacls msadc /grant Administrators:f /t /q
        Remove-Item $msadcFolder -Recurse

        Write-Output Deleted $msadcFolder

    }

    else {

        Write-Output $msadcFolder does not exist

    }

}