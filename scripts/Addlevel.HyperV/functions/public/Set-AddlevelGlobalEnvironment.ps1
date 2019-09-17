function Set-AddlevelGlobalEnvironment {
    <#
    .SYNOPSIS
        Creates a global environment for your Hyper-V environments.

    .DESCRIPTION
        This function creates a global hyper-v environment on your local machine.
        The global environment is used for shared resources.

    .PARAMETER EnvironmentPath
        Specifies where you want to create your environments.
        Default set to: C:\environments

    .EXAMPLE
        New-AddlevelGlobalEnvironment -EnvironmentPath D:\environments

        Creates an new global environment in D:\environments.

    .NOTES
        AUTHOR: Automation Team
        LASTEDIT: May 28th, 2019
    #>

    [CmdletBinding()]

    param (
        [parameter(Mandatory = $false)]
        [string]$EnvironmentPath = 'C:\environments'
    )

    # ensure environment
    ensureElevatedSession

    if (!(Test-path $EnvironmentPath)) {
        mkdir $EnvironmentPath | Out-Null
    }

    $globalConfigurationPath = Join-Path $EnvironmentPath 'globalsettings'

    if (!(Test-Path $globalConfigurationPath)) {
        mkdir $globalConfigurationPath | Out-Null
    }

    setGlobalConfiguration -GlobalConfigurationPath $globalConfigurationPath
}