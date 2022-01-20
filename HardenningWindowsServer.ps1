Write-Host "====Windows Server 2016 Configuration Tool====="
Write-Host "Disable Internet Explorer Popup.."
Start-Sleep -s 2
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" -Name "EnableActiveProbing" -Value 0
Write-Host "Verifying.."
Start-Sleep -s 2
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" -Name "EnableActiveProbing"
Write-Host "Disable SMBv1.."
Set-SmbServerConfiguration -EnableSMB1Protocol $false
Write-Host "Verifying.."
Get-SmbServerConfiguration | Select EnableSMB1Protocol
Start-Sleep -s 2
Write-Host "Installing SNMP Service.."
Import-Module ServerManager
Install-WindowsFeature SNMP-Service
Install-WindowsFeature SNMP-WMI-Provider
Dism /online /enable-feature /featurename:Server-RSAT-SNMP /ALL
Start-Sleep -s 2
Write-Host "Installing Telnet Client.."
Install-WindowsFeature Telnet-Client
Start-Sleep -s 2
Write-Host "Remove Windows Defender Feature.."
Uninstall-WindowsFeature -Name Windows-Defender
Start-Sleep -s 10
Write-Host "Remove SMBv1 Feature.."
Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol
Write-Host "Allow Multiple Logins for RDP Session"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" fSingleSessionPerUser -Type DWORD -Value 0 -Force
Write-Host "Disable anonymus authentication"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\LSA" restrictanonymous -Type DWORD -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\LSA" RestrictAnonymoussam -Type DWORD -Value 1 -Force
Write-Host "Disabling Print Spooler"
Stop-Service -Name Spooler -Force
Set-Service -Name Spooler -StartupType Disabled
Write-Host "Reboot Computer"
Restart-Computer