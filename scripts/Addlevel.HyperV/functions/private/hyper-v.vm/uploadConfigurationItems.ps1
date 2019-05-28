function uploadConfigurationItems ([hashtable]$Environment, [hashtable]$VirtualMachine, [string]$CertificatePath, [string]$ModulePath, [string]$ScriptPath, [string]$DriveLetter) {
    $destinationCertificatePath = Join-Path $DriveLetter 'certificates'
    if (!(Test-Path $destinationCertificatePath)) { mkdir $destinationCertificatePath | Out-Null }
    Copy-Item -Path "$CertificatePath" -Destination $DriveLetter -Recurse -Force

    $destinationModulePath = Join-Path $DriveLetter 'Program Files\WindowsPowerShell\Modules'
    if (!(Test-Path $destinationModulePath)) { mkdir $destinationModulePath | Out-Null }
    Copy-Item -Path "$ModulePath\*" -Destination $destinationModulePath -Recurse -Force

    $destinationScriptPath = Join-Path $DriveLetter 'scripts'
    if (!(Test-Path $destinationScriptPath)) { mkdir $destinationScriptPath | Out-Null }
    Copy-Item -Path "$ScriptPath\*" -Destination $destinationScriptPath -Recurse -Force

    # Set unattended initial script
    $scriptPath = Join-Path $driveLetter 'unattend.ps1'
    $command = setStartupScript -Environment $Environment -VirtualMachine $VirtualMachine
    $command | Out-File -FilePath $scriptPath -Encoding Utf8
}