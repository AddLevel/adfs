function testCertificates ([string]$CertificateName, [string]$CertificatePath) {
    $result = $true
    $certificates = @('.pvk', '.cer', '.pfx') | ForEach-Object {
        Join-Path $CertificatePath ($CertificateName + $_)
    }

    foreach ($Certificate in $certificates) {
        if (!(Test-Path $Certificate)) {
            $result = $false
        }
    }

    return $result
}