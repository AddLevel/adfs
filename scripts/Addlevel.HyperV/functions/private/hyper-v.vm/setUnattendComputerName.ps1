function setUnattendComputerName ([xml]$xml, [string]$ComputerName) {
    $xml.unattend.settings.component | Where-Object { $_.Name -eq "Microsoft-Windows-Shell-Setup" } | ForEach-Object {
        if ($_.ComputerName) {
            $_.ComputerName = $ComputerName
        }
    }
}