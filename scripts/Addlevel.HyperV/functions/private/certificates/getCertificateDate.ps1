function getCertificateDate ([switch]$ExpirationDate) {
    $date = (Get-Date).AddDays(-30)
    $expires = $date.AddYears(20)

    if ($ExpirationDate) {
        Get-Date -Date $expires -UFormat "%m/%d/%Y"
    } else {
        Get-Date -Date $date -UFormat "%m/%d/%Y"
    }
}