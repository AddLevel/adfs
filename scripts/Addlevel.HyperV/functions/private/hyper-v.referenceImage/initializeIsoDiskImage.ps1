function initializeIsoDiskImage ([string]$imagePath) {
    mountDiskImage -imagePath $imagePath
    $imageDriveLetter = getDiskImageDriveLetter -imagePath $imagePath
    $windowsImageFilePath = Join-Path $imageDriveLetter 'sources\install.wim'
    $imageIndex = getWindowsImageIndex -windowsImageFilePath $windowsImageFilePath
    return @{
        Index = $imageIndex
        WindowsImageFilePath = $windowsImageFilePath
    }
}