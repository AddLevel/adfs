function ensureVirtualMachine ([hashtable]$Configuration, [string]$unattendedXmlPath, [hashtable]$VirtualMachine) {
    [string]$SwitchName = $Configuration.VirtualSwitch.SwitchName
    [string]$ReferenceImagePath = $Configuration.ReferenceImage.ReferenceImagePath
    [string]$AdministratorPassword = $Configuration.Environment.AdministratorPassword
    [string]$CertificatePath = $Configuration.Paths.CertificatePath
    [string]$modulePath = $Configuration.Paths.ModulePath
    [string]$scriptPath = $Configuration.Paths.ScriptPath

    ensureVmSwitchInternal -switchName $SwitchName
    ensureDifferencingVHD -Path $VirtualMachine.VHDPath -ReferenceImagePath $ReferenceImagePath
    ensureVM -Name $VirtualMachine.Name -MemoryStartupBytes $VirtualMachine.MemorySizeBytes -VHDPath $VirtualMachine.VHDPath -SwitchName $SwitchName -Path $VirtualMachine.Path

    mountDiskImage -imagePath $VirtualMachine.VHDPath
    $driveLetter = getDiskImageDriveLetter -imagePath $VirtualMachine.VHDPath

    setUnattendXmlConfiguration -UnattendedXmlPath $UnattendedXmlPath -AdministratorPassword $AdministratorPassword -VirtualMachine $VirtualMachine -DriveLetter $driveLetter
    uploadConfigurationItems -Environment $Configuration.Environment -VirtualMachine $VirtualMachine -CertificatePath $certificatePath -ModulePath $modulePath -ScriptPath $scriptPath -DriveLetter $driveLetter
    Dismount-DiskImage -ImagePath $VirtualMachine.VHDPath | Out-Null
}