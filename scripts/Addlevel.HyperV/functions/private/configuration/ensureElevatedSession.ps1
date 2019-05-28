function ensureElevatedSession {
    $windowsIdentity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()

    if ($windowsIdentity.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") -eq $false) {
        throw "The Hyper-V module must be run in an elevated prompt (Run as Administrator)"
    }
}