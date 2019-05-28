function mountDiskImage ([string]$imagePath) {
    $diskImage = Get-DiskImage -ImagePath $imagePath
    if ($diskImage.Attached -eq $false) {
        Stop-Service -Name ShellHWDetection
        $diskImage = Mount-DiskImage -ImagePath $imagePath
        Start-Service -Name ShellHWDetection
    }
}