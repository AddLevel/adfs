# Module settings
$moduleRootPath = $PSScriptRoot

$private = @( Get-ChildItem -Path $moduleRootPath\functions\private\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$public  = @( Get-ChildItem -Path $moduleRootPath\functions\public\*.ps1 -Recurse -ErrorAction SilentlyContinue )

foreach ($import in @($private + $public)) {
    try {
        . $import.fullname
    }
    catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename