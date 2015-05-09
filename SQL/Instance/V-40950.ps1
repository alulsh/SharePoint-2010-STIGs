<#
Applies V-40950 from the SQL 2012 Instance STIG
#>

function Enable-FileAuditing ($instanceName) {

    $sqlInstallation = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL11.$instanceName\Setup\").SqlProgramDir

    $sqlACL = New-Object System.Security.AccessControl.DirectorySecurity

    $auditEvents = "ExecuteFile,ReadData,ReadAttributes,ReadExtendedAttributes,CreateFiles,AppendData,WriteAttributes,WriteExtendedAttributes,Delete,ReadPermissions"

    $AccessRule = New-Object System.Security.AccessControl.FileSystemAuditRule("Everyone",$auditEvents,"ContainerInherit,ObjectInherit","None","Success,Failure")

    $sqlACL.AddAuditRule($AccessRule)

    Set-Acl -Path $sqlInstallation -AclObject $sqlACL

    Write-Output "NTFS auditing enabled on SQL Server data libraries"

}