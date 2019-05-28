function partitionVHD ([string]$imagePath, [uint64]$SizeBytes) {
    $vhd = New-VHD -Path $imagePath -SizeBytes $SizeBytes
    $diskImage = Mount-DiskImage -ImagePath $vhd.Path -NoDriveLetter
    $diskNumber = $diskImage | Get-Disk | Select-Object -ExpandProperty Number
    Initialize-Disk -Number $diskNumber -PartitionStyle MBR
    
    Stop-Service -Name ShellHWDetection
    $partition = New-Partition -DiskNumber $diskNumber -UseMaximumSize -AssignDriveLetter -IsActive | Format-Volume -Confirm:$false -Force
    Start-Service -Name ShellHWDetection

    return $partition.DriveLetter + ':\'
}