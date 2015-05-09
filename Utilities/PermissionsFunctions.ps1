function Disable-PermissionsInheritance ($path) {

    $accessControlList = Get-Acl -Path $path

    if ($accessControlList.AreAccessRulesProtected -eq $false) {

        Write-Host $path is inheriting permissions - removing inheritance

        $accessControlList.SetAccessRuleProtection($true,$true)
        Set-Acl -Path $path -AclObject $accessControlList

    }

    else {

        Write-Host $path is not inheriting permissions from parent

    }

}

<#

Following function is modified from a Technet Windows PowerShell Tip of the Week
https://technet.microsoft.com/en-us/library/ff730951.aspx

#>

function Remove-NtfsPermissions ($securityPrincipal, $path) {

    $pathPermissions = [System.Security.AccessControl.FileSystemRights]"Read"
    $inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $propagationFlag = [System.Security.AccessControl.PropagationFlags]"None"
    $accessControlEntryType = [System.Security.AccessControl.AccessControlType]::Allow

    $principalObject = New-Object System.Security.Principal.NTAccount($securityPrincipal)
    $principalAccessControlEntry = New-Object System.Security.AccessControl.FileSystemAccessRule($principalObject, $pathPermissions, $inheritanceFlag, $propagationFlag, $accessControlEntryType)

    $principalAccessControlList = Get-Acl -Path $path
    $principalAccessControlList.RemoveAccessRuleAll($principalAccessControlEntry)

    Set-Acl -Path $path -AclObject $principalAccessControlList

}