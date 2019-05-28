function ensureVmSwitchInternal ([string]$switchName) {
    if (!(Get-VMSwitch | Where-Object { $_.Name -eq $switchName })) {
        New-VMSwitch -Name $switchName -SwitchType Internal | Out-Null
    }
}