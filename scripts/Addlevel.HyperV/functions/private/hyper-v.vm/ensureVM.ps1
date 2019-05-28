function ensureVM ([string]$Name, [string]$MemoryStartupBytes, [string]$VHDPath, [string]$SwitchName, [string]$Path) {
    if (!(Get-VM | Where-Object { $_.Name -eq $Name })) {
        New-VM -Name $Name -MemoryStartupBytes $MemoryStartupBytes -VHDPath $VHDPath -SwitchName $SwitchName -Path $Path | Out-Null
    }
}