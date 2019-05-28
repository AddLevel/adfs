function invokeBCDBoot ([string]$sourcePath, [string]$driveLetter) {
    $bcdBoot = BCDBoot.exe $sourcePath /s $driveLetter /f BIOS

    if ($LASTEXITCODE -ne 0) {
        Write-Error -Message "$bcdBoot BCDBoot.exe $sourcePath /s $driveLetter /f BIOS" -Category InvalidOperation
    }
}