function ensureScripts ([string]$DestinationPath, [string]$ScriptPath) {
    foreach ($script in Get-ChildItem $scriptPath -Filter '*.ps1') {
        $destinationScript = Join-Path $DestinationPath $script.Name
        if (!(Test-Path $destinationScript)) {
            Copy-Item -Path $script.FullName -Destination $destinationScript -Force
        } else {
            if ((Get-FileHash -Path $destinationScript).Hash -ne (Get-FileHash -Path $script.FullName).Hash) {
                Copy-Item -Path $script.FullName -Destination $destinationScript -Force
            }
        }
    }
}