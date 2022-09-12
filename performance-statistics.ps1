$log = 'C:\users\' + $env:username + '\perflog.txt'
$totalRam = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).Sum
$allBytesSent = 0
$allBytesRecieved = 0
while($true) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $cpuTime = (Get-Counter -Counter "\Processor Information(_Total)\% Processor Time").CounterSamples.CookedValue
    $availMem = (Get-Counter -Counter "\Memory\Available MBytes").CounterSamples.CookedValue
    $ethernetInterface = if ((Get-NetAdapter -Name 'Ethernet' | Select-Object -ExpandProperty InterfaceOperationalStatus) -eq 1) {'Up'} else {'Down'}
    $ethernetMedia = Get-NetAdapter -Name 'Ethernet' | Select-Object -ExpandProperty MediaConnectionState
    $wifiInterface = if ((Get-NetAdapter -Name 'Wi-Fi' | Select-Object -ExpandProperty InterfaceOperationalStatus) -eq 1) {'Up'} else {'Down'}
    $wifiMedia = Get-NetAdapter -Name 'Wi-Fi' | Select-Object -ExpandProperty MediaConnectionState
    $bytesSent = (Get-NetAdapterStatistics -Name 'Ethernet' | Select-Object -ExpandProperty SentBytes) + (Get-NetAdapterStatistics -Name 'Wi-Fi' | Select-Object -ExpandProperty SentBytes) - $allBytesSent
    $bytesRecieved = (Get-NetAdapterStatistics -Name 'Ethernet' | Select-Object -ExpandProperty ReceivedBytes) + (Get-NetAdapterStatistics -Name 'Wi-Fi' | Select-Object -ExpandProperty ReceivedBytes) - $allBytesRecieved
    $output = $date + ' > CPU: ' + $cpuTime.ToString("#,0.000") + '%, Avail. Mem.: ' + $availMem.ToString("N0") + 'MB (' + (104857600 * $availMem / $totalRam).ToString("#,0.0") + '%), ' + 'Ethernet: ' + $ethernetInterface + ' ' + $ethernetMedia + ', Wi-Fi: ' + $wifiInterface + ' ' + $wifiMedia + ', Sent: ' + $bytesSent + ', Received: ' + $bytesRecieved
    Write-Output $output >>$log
    $allBytesSent = (Get-NetAdapterStatistics -Name 'Ethernet' | Select-Object -ExpandProperty SentBytes) + (Get-NetAdapterStatistics -Name 'Wi-Fi' | Select-Object -ExpandProperty SentBytes)
    $allBytesRecieved = (Get-NetAdapterStatistics -Name 'Ethernet' | Select-Object -ExpandProperty ReceivedBytes) + (Get-NetAdapterStatistics -Name 'Wi-Fi' | Select-Object -ExpandProperty ReceivedBytes)
    Start-Sleep -s 30
}



<# METRICS FROM COUNTERS AS ALTERNATIVE SOURCE
(Get-Counter).CounterSamples.Path
\network interface(intel[r] 82579lm gigabit network connection)\bytes total/sec
\network interface(intel[r] centrino[r] ultimate-n 6300 agn)\bytes total/sec
\network interface(isatap.{7cf0580e-071d-46ce-99fe-58328b0b7b35})\bytes total/sec
\network interface(teredo tunneling pseudo-interface)\bytes total/sec
\network interface(isatap.{11c74532-d485-4064-bcc4-3c595d90aec1})\bytes total/sec
\network interface(isatap.{4c5f7956-2451-493b-8a9f-d0331c8d38d2})\bytes total/sec
\processor(_total)\% processor time
\memory\% committed bytes in use
\memory\cache faults/sec
\physicaldisk(_total)\% disk time
\physicaldisk(_total)\current disk queue length
#>