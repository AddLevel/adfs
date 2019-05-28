function newSSLCertificate ([string]$RootCertificateName, [string]$SSLCertificateName, [string]$MakeCertPath, [string]$Pvk2pfxPath) {

    $iv = $RootCertificateName + '.pvk'
    $ic = $RootCertificateName + '.cer'
    $n = 'CN=' + $SSLCertificateName
    $sv = $SSLCertificateName + '.pvk'
    $cer = $SSLCertificateName + '.cer'
    $pfx = $SSLCertificateName + '.pfx'

    $b = getCertificateDate
    $e = getCertificateDate -ExpirationDate

    & $MakeCertPath -iv $iv -ic $ic -n $n -pe -sv $sv -a sha256 -len 2048 -b $b -e $e -sky exchange $cer -eku 1.3.6.1.5.5.7.3.1
    & $Pvk2pfxPath -pvk $sv -spc $cer -pfx $pfx
}