function Revoke-Permission ($granteeName) {

    $SQLServer.Revoke($permission, $granteeName)

}

function Remove-Permissions ($serverName, $SQLPermission) {

    $SQLServer = New-Object "Microsoft.SQLServer.Management.Smo.Server" $serverName
    $permission = [Microsoft.SQLServer.Management.Smo.ServerPermission]::$SQLPermission

    $permissions = $SQLServer.EnumServerPermissions($permission)

    foreach ($item in $permissions) {

        $principalName = $item.grantee

        if ($principalName -like "##*") {

            Write-Output "$principalName is a default SQL account - not revoking permissions"

        }

        else {

            Revoke-Permission $principalName
            Write-Output "Revoked $SQLPermission from $principalName"

        }

    }

}