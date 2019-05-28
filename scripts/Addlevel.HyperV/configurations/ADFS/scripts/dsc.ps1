configuration ADFSConfiguration
{
    param (
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [String]$CertificateThumbprint,
        
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$DomainCredentials
    )

    Import-DscResource -ModuleName ComputerManagementDsc -ModuleVersion 6.3.0.0
    Import-DscResource -ModuleName NetworkingDsc -ModuleVersion 7.1.0.0
    Import-DscResource -ModuleName xActiveDirectory -ModuleVersion 2.25.0.0
    Import-DscResource -ModuleName PSDscResources -ModuleVersion 2.10.0.0

    $interface = Get-NetAdapterStatistics | Where-Object { $_.Name -Like "Ethernet*" -and $_.ReceivedUnicastPackets -eq 0 } | Select-Object -First 1
    $ipAddress = $interface | Get-NetIPAddress | Select-Object -ExpandProperty IPv4Address
    $subject = "sts.$domainName"
    $domainUserName = $DomainCredentials.UserName
    $domainSecret = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DomainCredentials.Password))

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        WindowsFeature DNS
        {
            Ensure = 'Present'
            Name = 'DNS'
        }

        WindowsFeature DnsTools
        {
            Ensure = 'Present'
            Name = 'RSAT-DNS-Server'
            DependsOn = '[WindowsFeature]DNS'
        }

        WindowsFeature ADDSInstall
        {
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
            DependsOn= '[WindowsFeature]DNS'
        }

        WindowsFeature ADFSInstall
        {
            Ensure = 'Present'
            Name   = 'ADFS-Federation'
            DependsOn = '[WindowsFeature]ADDSInstall'
        }

        WindowsFeature ADDSTools
        {
            Ensure = 'Present'
            Name = 'RSAT-ADDS-Tools'
            DependsOn = '[WindowsFeature]ADDSInstall'
        }

        WindowsFeature ADAdminCenter
        {
            Ensure = 'Present'
            Name = 'RSAT-AD-AdminCenter'
            DependsOn = '[WindowsFeature]ADDSTools'
        }

        xADDomain DomainController
        {
            DomainName = $domainName
            DomainAdministratorCredential = $domainCredentials
            SafemodeAdministratorPassword = $domainCredentials
            DependsOn = '[WindowsFeature]ADDSInstall'
        }

        Script EnableDNSDiags
        {
  	        SetScript = {
                Set-DnsServerDiagnostics -All $true
                Write-Verbose -Verbose "Enabling DNS client diagnostics"
            }
            GetScript =  { @{} }
            TestScript = { 
                try {
                    Get-DnsServerDiagnostics -ErrorAction Stop
                    $false
                } catch {
                    $true
                };
            }
            DependsOn = '[WindowsFeature]DNS'
        }

        Script UpdateDNS
        {
            SetScript  = {
                $zoneName = $using:subject
                $primaryZone = Add-DnsServerPrimaryZone -Name $zoneName -ReplicationScope Forest -PassThru
                $resourceRecord = Add-DnsServerResourceRecordA -ZoneName $zoneName -Name '@' -AllowUpdateAny -IPv4Address $using:ipAddress
            }
            GetScript =  { @{} }
            TestScript = { 
                $zoneName = $using:subject
                $dnsZone = Get-DnsServerZone -Name $zoneName -ErrorAction SilentlyContinue
                return ($dnsZone -ine $null)
            }
            DependsOn = '[WindowsFeature]DNS'
        }

        Script InstallADFS
        {
            SetScript = {
                Import-Module ADFS
                
                $thumbPrint = $using:CertificateThumbprint
                $federationServiceName = $using:subject
                $federationDisplayName = 'ADFS ' + $using:subject
                $secret = ConvertTo-SecureString $using:domainSecret -AsPlainText -Force
                $credential = New-Object System.Management.Automation.PSCredential ($using:domainUserName, $secret)

                Install-AdfsFarm -Credential $credential -CertificateThumbprint $thumbprint -FederationServiceName $federationServiceName -FederationServiceDisplayName $federationDisplayName -ServiceAccountCredential $credential -OverwriteConfiguration
                Set-AdfsProperties -EnableIdpInitiatedSignonPage $true
            }
            GetScript = { @{} }
            TestScript = {
                Import-Module ADFS
                try {
                    Get-AdfsFarmInformation -ErrorAction Stop
                    $true
                } catch {
                    $false
                }
            }
            DependsOn = '[xADDomain]DomainController'
        }
    }
}

configuration WAPConfiguration
{
    param (
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [String]$CertificateThumbprint,
        
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$DomainCredentials
    )

    $subject = "sts.$domainName"
    $domainUserName = $DomainCredentials.UserName
    $domainSecret = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DomainCredentials.Password))

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

	    WindowsFeature WebAppProxy
        {
            Ensure = "Present"
            Name = "Web-Application-Proxy"
        }

        WindowsFeature Telnet
        {
            Ensure = "Present"
            Name = "Telnet-Client"
        }

        WindowsFeature RemoteAccessTools 
        {
            Ensure = "Present"
            Name = "RSAT-RemoteAccess"
            IncludeAllSubFeature = $true
        }

        WindowsFeature PowerShellADTools 
        {
            Ensure = "Present"
            Name = "RSAT-AD-PowerShell"
            IncludeAllSubFeature = $true
        }

        Script InstallWAP
        {
            SetScript = {
                Import-Module WebApplicationProxy
                
                $thumbPrint = $using:CertificateThumbprint
                $federationServiceName = $using:subject
                $secret = ConvertTo-SecureString $using:domainSecret -AsPlainText -Force
                $credential = New-Object System.Management.Automation.PSCredential ($using:domainUserName, $secret)

                Install-WebApplicationProxy -FederationServiceTrustCredential $credential -CertificateThumbprint $thumbprint -FederationServiceName $federationServiceName
            }
            GetScript = { @{} }
            TestScript = {
                Import-Module WebApplicationProxy
                try {
                    Get-WebApplicationProxyApplication -ErrorAction Stop
                    $true
                } catch {
                    $false
                }
            }
            DependsOn = '[WindowsFeature]WebAppProxy'
        }
    }
}