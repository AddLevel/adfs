

function setStartupScript ([hashtable]$Environment, [hashtable]$VirtualMachine) {
@'
# Configuration Variables
$domainName = '{0}'
$subjectName = 'sts.' + $domainName
$userName = 'administrator'
$password = '{1}'
$credentials = New-Object System.Management.Automation.PSCredential "$domainName\$userName", (ConvertTo-SecureString -String $password -AsPlainText -Force)
$rootCertificate = Get-ChildItem C:\certificates | Where-Object Name -match '.*root.*\.cer'
$sslCertificate = Get-ChildItem C:\certificates | Where-Object Name -match "$subjectName.*\.pfx"
$scriptPath = 'C:\scripts'
$dscPath = 'C:\dsc'
'@ -f $Environment.DomainName, $Environment.AdministratorPassword

@'

# Script Import
foreach ($script in Get-ChildItem -Path "C:\scripts" -Filter '*.ps1') {
    . $script.FullName
}
'@

@'

# Certificate Import
$rootCertificate = Import-Certificate -FilePath $rootCertificate.FullName -CertStoreLocation Cert:\LocalMachine\Root
$sslCertificate = Import-PfxCertificate -FilePath $sslCertificate.FullName -CertStoreLocation Cert:\LocalMachine\My
$certificateThumbprint = $sslCertificate.Thumbprint
'@

@'

# DSC ConfigurationData
$configurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
        }
    )
}
'@

@'

# DSC Configuration
{0} -DomainName $domainName -DomainCredentials $credentials -ConfigurationData $configurationData -CertificateThumbprint $certificateThumbprint -OutputPath $dscPath
Set-DscLocalConfigurationManager -Path $dscPath
'@ -f $VirtualMachine.DscConfiguration

@'

# Create Scheduled Task
$execute = 'Powershell.exe'
$argument = '-NoProfile -WindowStyle Hidden -command "& {Start-DscConfiguration -Path ' + $dscPath + ' -Wait -Force -Verbose}"'
$action = New-ScheduledTaskAction -Execute $execute -Argument $argument
$settings = New-ScheduledTaskSettingsSet -Hidden -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

$trigger = New-ScheduledTaskTrigger -AtStartup
$taskName = 'dsctask'
$taskDescription = 'dsc scheduled task'
$task = Register-ScheduledTask -Action $action -Settings $Settings -Trigger $trigger -TaskName $taskName -Description $taskDescription -User "NT AUTHORITY\SYSTEM" -RunLevel 1 -TaskPath \AddLevel
Get-ScheduledTask -TaskName $taskName | Start-ScheduledTask
'@
}