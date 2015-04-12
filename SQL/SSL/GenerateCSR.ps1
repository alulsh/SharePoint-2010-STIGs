<#
Update request.inf file with current hostname and generate CSR in the current working directory
Mitigates the following SQL Instance 2012 STIGs:
V-4130, V-41309, V-41308, V-40921, V-40907
#>

function New-CertificateSigningRequest {

    Set-Location C:

    $hostname = "$env:computername.$env:userdnsdomain"
    $csrFile = $hostname+".txt"

    $requestFile = Get-Item "C:\SSLRequest.inf"

    # Add trailing double quote to hostname string #
    $hostname = $hostname+'"'

    (Get-Content $requestFile) | ForEach-Object {$_ -Replace '(?<=cn=).*', $hostname} | Set-Content $requestFile

    certreq -new $requestFile $csrFile

    notepad $csrFile

    Write-Output "CSR is generated and located in $requestFile - send to certificate authority for processing"

}