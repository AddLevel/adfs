function ensureCertificate ([string]$ExecutablePath, [string]$CertificatePath, [string]$RootCertificateName, [string]$SSLCertificateName) {
    $makeCertPath = Join-Path $ExecutablePath 'makecert.exe'
    $pvk2pfxPath = Join-Path $ExecutablePath 'pvk2pfx.exe'

    Push-Location $CertificatePath

    if ((testCertificates -CertificateName $RootCertificateName -CertificatePath $CertificatePath) -eq $false) {
        newRootCertificate -RootCertificateName $RootCertificateName -MakeCertPath $makeCertPath -Pvk2pfxPath $pvk2pfxPath
    }

    if ((testCertificates -CertificateName $SSLCertificateName -CertificatePath $CertificatePath) -eq $false) {
        newSSLCertificate -RootCertificateName $RootCertificateName -SSLCertificateName $SSLCertificateName -MakeCertPath $makeCertPath -Pvk2pfxPath $pvk2pfxPath
    }

    Pop-Location
}