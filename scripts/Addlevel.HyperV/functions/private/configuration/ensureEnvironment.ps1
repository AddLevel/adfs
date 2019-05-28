function ensureEnvironment {
    param (
        [HashTable]$Environment
    )

    if ($Environment.SSLCertificateName -notmatch ".*$($Environment.DomainName)$") {
        throw "SSLCertificateName: $($Environment.SSLCertificateName) should end with Domain Name: $($Environment.DomainName)."
    }

    if (!(Test-Path $Environment.ISOImagePath)) {
        throw "ISO Image: $($Environment.ISOImagePath) does not exist"
    }
}