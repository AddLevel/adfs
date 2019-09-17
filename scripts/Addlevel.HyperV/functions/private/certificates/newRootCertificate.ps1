function newRootCertificate ([string]$RootCertificateName, [string]$MakeCertPath, [string]$Pvk2pfxPath) {
    $n = 'CN=' + $RootCertificateName
    $sv = $RootCertificateName + '.pvk'
    $cer = $RootCertificateName + '.cer'
    $pfx = $RootCertificateName + '.pfx'

    $b = getCertificateDate
    $e = getCertificateDate -ExpirationDate

    & $MakeCertPath -r -n $n -pe -sv $sv -a sha1 -len 2048 -b $b -e $e -cy authority $cer
    & $Pvk2pfxPath -pvk $sv -spc $cer -pfx $pfx
}