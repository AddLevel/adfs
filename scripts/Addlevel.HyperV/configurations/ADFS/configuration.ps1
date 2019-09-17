@{
    Paths = @{
        ModulePath = Join-Path $EnvironmentPath 'modules'
        VMPath = Join-Path $EnvironmentPath 'vm'
        ScriptPath = Join-path $EnvironmentPath 'scripts'
    }
    VirtualSwitch = @{
        SwitchName = (getUniqueString -id $EnvironmentName -length 3) + '-internal'
    }
    VirtualMachines = @{
        Name = (getUniqueString -id $EnvironmentName -length 3) + '-adfs1'
        Path = Join-Path $EnvironmentPath 'vm\vm'
        VHDPath = Join-Path $EnvironmentPath ('vm\vhd\' + (getUniqueString -id $EnvironmentName -length 3) + '-adfs1.vhdx')
        MemorySizeBytes = [uint64]6GB
        IPAddress = '10.0.0.2/24'
        DNSAddress = '10.0.0.2'
        DscConfiguration = 'ADFSConfiguration'
    },
    @{
        Name = (getUniqueString -id $EnvironmentName -length 3) + '-wap1'
        Path = Join-Path $EnvironmentPath 'vm\vm'
        VHDPath = Join-Path $EnvironmentPath ('vm\vhd\' + (getUniqueString -id $EnvironmentName -length 3) + '-wap1.vhdx')
        MemorySizeBytes = [uint64]6GB
        IPAddress = '10.0.0.3/24'
        DNSAddress = '10.0.0.2'
        DscConfiguration = 'WAPConfiguration'
    }
    DSCResources = @{
        Name = 'PSDscResources'
        RequiredVersion = '2.10.0.0'
    },
    @{
        Name = 'ComputerManagementDsc'
        RequiredVersion = '6.3.0.0'
    },
    @{
        Name = 'NetworkingDsc'
        RequiredVersion = '7.1.0.0'
    },
    @{
        Name = 'xActiveDirectory'
        RequiredVersion = '2.25.0.0'
    },
    @{
        Name = 'xPendingReboot'
        RequiredVersion = '0.4.0.0'
    },
    @{
        Name = 'xAdcsDeployment'
        RequiredVersion = '1.4.0.0'
    },
    @{
        Name = 'xCertificate'
        RequiredVersion = '3.2.0.0'
    },
    @{
        Name = 'xSmbShare'
        RequiredVersion = '2.2.0.0'
    }
}