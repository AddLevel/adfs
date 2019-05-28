function getDiskImageDriveLetter ([string]$imagePath) {
    $volumeDriveLetter = Get-DiskImage -ImagePath $imagePath | Get-Volume | Select-Object -ExpandProperty DriveLetter
    if (!($volumeDriveLetter)) {
        $volumeDriveLetter = Get-DiskImage -ImagePath $imagePath | Get-Disk | Get-Partition | Select-Object -ExpandProperty DriveLetter
    }
    return "$($volumeDriveLetter):\"
}