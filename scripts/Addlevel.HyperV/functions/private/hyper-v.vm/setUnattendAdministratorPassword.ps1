function setunattendAdministratorPassword ([xml]$xml, [string]$AdministratorPassword) {
    $xml.unattend.settings.component | Where-Object { $_.Name -eq "Microsoft-Windows-Shell-Setup" } | ForEach-Object {
        if($_.UserAccounts) {
            $_.UserAccounts.AdministratorPassword.Value = $AdministratorPassword
        }
        if ($_.AutoLogon) {
            $_.AutoLogon.Password.Value = $AdministratorPassword
        }
    }
}