function setUnattendXmlConfiguration ([string]$UnattendedXmlPath, [string]$AdministratorPassword, [hashtable]$VirtualMachine, [string]$DriveLetter) {

    $xml = New-Object XML
    $xml.Load($unattendedXmlPath)

    setUnattendComputerName -xml $xml -ComputerName $VirtualMachine.Name
    setunattendAdministratorPassword -xml $xml -AdministratorPassword $AdministratorPassword
    setunattendNetworkConfiguration -xml $xml -IPAddress $VirtualMachine.IPAddress -DNSAddress $VirtualMachine.DNSAddress

    $xmlPath = Join-Path $driveLetter 'unattend.xml'
    $xml.save($xmlPath)
}