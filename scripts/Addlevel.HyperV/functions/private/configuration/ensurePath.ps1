function ensurePath ([string[]]$Path) {
    foreach ($folderPath in $Path) {
        if (!(Test-Path $folderPath)) {
            mkdir $folderPath | Out-Null
        }
    }
}