function ensureModules ([string]$DestinationPath, [hashtable[]]$Modules) {
    foreach ($module in $Modules) {
        $path = Join-Path $DestinationPath (Join-Path $module.Name $module.RequiredVersion)
        if (!(Test-Path $path)) {
            Find-Module -Name $module.Name -RequiredVersion $module.RequiredVersion | Save-Module -Path $DestinationPath
        }
    }
}