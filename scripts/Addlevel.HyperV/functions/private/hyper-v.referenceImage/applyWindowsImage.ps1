function applyWindowsImage ([string]$isoImagePath, [string]$vhdImagePath, [uint64]$DiskSizeBytes) {

    if (!(Test-Path $vhdImagePath)) {
        $isoDiskImage = initializeIsoDiskImage -imagePath $isoImagePath
        $vhdDiskImage = initializeVhdDiskImage -imagePath $vhdImagePath -SizeBytes $DiskSizeBytes

        $windowsImage = Expand-WindowsImage -ImagePath $isoDiskImage.WindowsImageFilePath -Index $isoDiskImage.Index -ApplyPath $vhdDiskImage.ApplyPath
        invokeBCDBoot -sourcePath $vhdDiskImage.SourcePath -driveLetter $vhdDiskImage.ApplyPath

        Dismount-DiskImage -ImagePath $isoImagePath | Out-Null
        Dismount-DiskImage -ImagePath $vhdImagePath | Out-Null
    }
}