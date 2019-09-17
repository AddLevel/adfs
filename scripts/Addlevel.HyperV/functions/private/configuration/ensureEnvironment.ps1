function ensureEnvironment {
    param (
        [HashTable]$Configuration
    )

    if ($Configuration.Certificates.SSLCertificateName -notmatch ".*$($Configuration.Environment.DomainName)$") {
        throw "SSLCertificateName: $($Configuration.Certificates.SSLCertificateName) should end with Domain Name: $($Environment.DomainName)."
    }

    if (!(Test-Path $Configuration.Environment.ISOImagePath)) {
        throw "ISO Image: $($Environment.ISOImagePath) does not exist"
    }
}