function getWindowsImageIndex ([string]$windowsImageFilePath) {
    $windowsImage = Get-WindowsImage -ImagePath $windowsImageFilePath
    $imageIndex = $windowsImage | Out-GridView -OutputMode Single -Title 'Select the operating system you want to install.'
    return $imageIndex.ImageIndex
}