$private = @( Get-ChildItem -Path $PSScriptRoot\functions\private\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$public  = @( Get-ChildItem -Path $PSScriptRoot\functions\public\*.ps1 -Recurse -ErrorAction SilentlyContinue )

foreach ($import in @($private + $public)) {
    try {
        . $import.fullname
    }
    catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Module settings
$moduleRootPath = $PSScriptRoot

Export-ModuleMember -Function $Public.Basename