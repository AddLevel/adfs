function ensureDifferencingVHD ([string]$Path, [string]$ReferenceImagePath) {
    if (!(Test-Path $Path)) {
        New-VHD -Path $Path -Differencing -ParentPath $ReferenceImagePath | Out-Null
    }
}