function initializeVhdDiskImage ([string]$imagePath, [uint64]$SizeBytes) {
    $vhdPartitionPath = partitionVHD -imagePath $vhdImagePath -SizeBytes $SizeBytes
    return @{
        ApplyPath = $vhdPartitionPath
        SourcePath = Join-Path $vhdPartitionPath 'Windows'
    }
}