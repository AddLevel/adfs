function setunattendNetworkConfiguration ([xml]$xml, [string]$IPAddress, [string]$DNSAddress) {
    $xml.unattend.settings.component.interfaces.interface.Ipv4Settings | ForEach-Object {
        if($_.DhcpEnabled) {
            $_.DhcpEnabled = 'false'
        }
    }

    $xml.unattend.settings.component.interfaces.interface.UnicastIpAddresses.IPAddress.'#text' = $IPAddress
    $xml.unattend.settings.component.interfaces.interface.DNSServerSearchOrder.IPAddress."#text" = $DNSAddress
}