function Import-CSR {

    $hostname = "$env:computername.$env:userdnsdomain"
    $signedCSR = $hostname+".csr"

    certreq -accept $signedCSR

}