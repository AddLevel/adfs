function New-AddlevelEnvironment {
    <#
    .SYNOPSIS 
        Creates Hyper-V environments.
    
    .DESCRIPTION
        This function creates hyper-v environments on your local machine. It requires that Hyper-V is enabled on 
        your local machine.
    
    .PARAMETER EnvironmentName
        Specifies the name of the environment that you want to create.
        All resources will be placed in a folder with the environment name.
    
    .PARAMETER EnvironmentPath
        Specifies where you want to create your environments.
        Default set to: C:\environments
    
    .PARAMETER Template
        Specifies which type of environment you want to create.
        Supported environments:
        -- ADFS: Creates two virtual machines with the following roles:
           -- ADFS: DNS, ADDS, ADFS
           -- WAP: WebAppProxy
          
    .EXAMPLE
        New-AddlevelEnvironment -EnvironmentName ADFS-Demo -EnvironmentPath D:\environments -Template ADFS

        Creates an new ADFS environment in C:\environments\ADFS-DEMO.
    
    .NOTES
        AUTHOR: Automation Team
        LASTEDIT: May 28th, 2019 
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$EnvironmentName,

        [parameter(Mandatory = $false)]
        [string]$EnvironmentPath = 'C:\environments',

        [parameter(Mandatory = $false)]
        [ValidateSet('ADFS')]
        [string]$Template = 'ADFS'
    )

    # Configuration variables
    $executablePath = Join-Path $moduleRootPath 'executables'
    $unattendedXmlPath = Join-Path $moduleRootPath 'unattend\unattend.xml'
    $deploymentPath = Join-Path $EnvironmentPath $EnvironmentName
    $templatePath = Join-Path $moduleRootPath (Join-Path 'configurations' (Join-Path $Template "configuration.ps1"))
    $scriptPath = Join-Path $moduleRootPath (Join-Path 'configurations' (Join-Path $Template "scripts"))
    $configuration = getConfiguration -TemplatePath $templatePath -EnvironmentPath $deploymentPath -EnvironmentName $EnvironmentName

    # Ensure environment
    ensureElevatedSession
    ensureEnvironment -Environment $configuration.Environment
    ensurePath -Path $EnvironmentPath
    ensurePath -Path $configuration.Paths.Values
    ensureModules -DestinationPath $configuration.Paths.ModulePath -Modules $configuration.DSCResources
    ensureScripts -DestinationPath $configuration.Paths.ScriptPath -ScriptPath $scriptPath
    ensureCertificate -ExecutablePath $executablePath -CertificatePath $configuration.Paths.CertificatePath -RootCertificateName $configuration.Environment.RootCertificateName -SSLCertificateName $configuration.Environment.SSLCertificateName

    # Create Reference Image
    applyWindowsImage -isoImagePath $configuration.Environment.ISOImagePath -vhdImagePath $configuration.ReferenceImage.ReferenceImagePath -DiskSizeBytes $configuration.ReferenceImage.ReferenceImageDiskSizeBytes

    # Create VMs
    foreach ($virtualMachine in $configuration.VirtualMachines) {
        ensureVirtualMachine -Configuration $configuration -unattendedXmlPath $unattendedXmlPath -VirtualMachine $virtualMachine
    }
}