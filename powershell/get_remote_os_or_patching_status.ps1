#list of computers, one in each row
$computerlist = Get-Content C:\Temp\comps.csv
#list of hotfixes you're checking
$hotfixes = "KB4012212", "KB4012217", "KB4015551", "KB4019216", "KB4012216", "KB4015550", "KB4019215", "KB4013429", "KB4019472", "KB4015217", "KB4015438", "KB4016635", "KB4012606", "KB4022723", "KB4022715", "KB4032695", "KB4019474" 

#Gets Remote OS Names, Last Boot Time, etc and outputs to specified location
foreach ($computer in $computerlist) {
    if((Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))
    {  
        Get-WMIObject Win32_OperatingSystem -ComputerName $computer |
        select-object CSName, Caption, CSDVersion, OSType, LastBootUpTime, ProductType| export-csv -Path C:\Temp\OS.csv -NoTypeInformation -Append
    }
} 

#Gets Patching status based on above defined list and will output status of each machine
foreach
($computer in $computerlist) {
    if(-not(Test-Connection $computer -Count 1 -quiet)) {
        Write-Warning "$computer is offline"
        continue
    }
   
    $hotfix = Get-HotFix -ComputerName $computer |
        Where-Object {$hotfixes -contains $_.HotfixID} |
        Select-Object -property "HotFixID" 

    if($hotfix) {
  Write-Output "$computer has hotfix $hotfix installed"
 } else {
  Write-Output "$computer is missing hotfix"
  #Write-Verbose "$computer has hotfix $hotfix installed"
    #} else {
        #Write-Warning "$computer is missing hotfix"
    }
} 

