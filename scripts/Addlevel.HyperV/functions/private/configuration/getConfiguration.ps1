function getConfiguration ([string]$TemplatePath, [string]$EnvironmentPath, [string]$EnvironmentName) {
    $configuration = . $TemplatePath

    foreach ($key in $configuration.Environment.Keys) {
        if ([string]::IsNullOrEmpty($configuration.Environment[$key])) {
            throw "Missing configuration for: $key. Please set this value in $templatePath"
        }
    }

    return $configuration
}