function convertfromEncryptedString ([string]$EncryptedString) {
    $secureString = $EncryptedString | ConvertTo-SecureString

    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
    $value = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

    return $value
}