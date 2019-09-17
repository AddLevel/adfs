function getGLobalConfigurationData ([string]$GlobalConfigurationPath) {
    return @{
        Environment = @{
            AdministratorPassword = ''
            DomainName = 'auth.local'
            ISOImagePath = ''
        }
        ReferenceImage = @{
            ReferenceImageDiskSizeBytes= [uint64]40GB
            ReferenceImagePath = Join-Path $GlobalConfigurationPath  'global-referenceimage.vhdx'
        }
        Certificates = @{
            RootCertificateName = 'AuthRoot'
            SSLCertificateName = 'sts.auth.local'
            CertificatePath = Join-Path $GlobalConfigurationPath 'certificates'
        }
    }
}

function updateConfigurationData ([hashtable]$ReferenceObject, [hashtable]$DifferenceObject) {
    foreach ($key in $ReferenceObject.Keys) {
        if (!($DifferenceObject.ContainsKey($key))) {
            $DifferenceObject.Add($key, $ReferenceObject[$key])
        }

        foreach ($internalKey in $ReferenceObject[$key].Keys) {
            if (!($DifferenceObject[$key].ContainsKey($internalKey))) {
                $DifferenceObject[$key].Add($internalKey, $ReferenceObject[$key][$internalKey])
            }
        }
    }

    return $DifferenceObject
} 

function getGlobalConfiguration ([string]$GlobalConfigurationPath) {
    $globalConfiguration = getGLobalConfigurationData -GlobalConfigurationPath $GlobalConfigurationPath
    $localConfigurationFile = Join-Path $GlobalConfigurationPath 'globalsettings.json'
    if (Test-Path $localConfigurationFile) {
        $localConfiguration = Get-Content $localConfigurationFile | ConvertFrom-Json | ConvertTo-Hashtable
    }

    if ($localConfiguration) {
        $configuration = updateConfigurationData -ReferenceObject $globalConfiguration -DifferenceObject $localConfiguration
    } else {
        $configuration = $globalConfiguration
    }

    return $configuration
}

function setGlobalConfiguration ([string]$GlobalConfigurationPath) {
    $sourceConfiguration = getGlobalConfiguration -GlobalConfigurationPath $GlobalConfigurationPath
    $targetConfiguration = getGlobalConfiguration -GlobalConfigurationPath $GlobalConfigurationPath

    foreach ($key in $sourceConfiguration.Keys) {
        foreach ($internalKey in $sourceConfiguration[$key].Keys) {
            if ([string]::IsNullOrEmpty($sourceConfiguration[$key][$internalKey])) {

                if ($internalKey -match 'password|secure') {
                    $secureString = Read-Host -Prompt "Enter a secure value for $internalKey" -AsSecureString
                    $value = $secureString | ConvertFrom-SecureString
                } elseif ($internalKey -match 'path$') {
                    $isValid = $false
                    $message = "Enter a valid path for $internalKey"

                    while ($isValid -eq $false) {
                        $value = Read-Host -Prompt $message
                        $message = "$value is not a valid path. Enter a valid path for $internalKey"
                        $isValid = Test-Path $value
                    }
                } else {
                    $value = Read-Host -Prompt "Enter a value for $internalKey"
                }

                $targetConfiguration[$key][$internalKey] = $value
            }
        }
    }

    $localConfigurationFile = Join-Path $GlobalConfigurationPath 'globalsettings.json'
    $targetConfiguration | ConvertTo-Json | Out-File $localConfigurationFile -Force
}