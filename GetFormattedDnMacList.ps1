# Fetches list of mac addresses and DN against a match for a specific DN string
# The script as configured will pull a CSV of  all the DN's as their hostname and there MAC address for the MGMT-A-PXE vNic
# Requires UCS PowerTool Modules to be installed in PowerShell
# Example Output which is in CSV format:
# servername1	00:25:B5:00:00:00
# servername2	00:25:B5:00:00:08
# servername3	00:25:B5:00:00:10
#
# This is particularly useful if you need to add this information to a DHCPD scope on one of the TFTP servers and/or mass add/delete records from DNS.
# To change this to what you need to find change the $lookFor variable to a matching vnic string to what you are looking for
# Authored by Dan Harrell - Dan.Harrell@hf.org
# Created on 8/26/2019

$lookFor = "vnicName"
$pathToExport = "C:\Temp\UCSMacAddressList.txt"
$pathToCompletion = "C:\Users\$env:USERNAME\Desktop\UCSMacAddressList.csv"
remove-item -path $pathToExport -ErrorAction Ignore
remove-item -path $pathToCompletion -ErrorAction Ignore
Connect-Ucs
$macs = Get-UcsServiceProfile | Get-UcsVnic | Select-Object dn, addr
foreach ($mac in $macs){
     $macjr = $mac | Select-Object -ExpandProperty DN
     if($macjr -match $lookFor ){
         $dnname = $mac | Select-Object -ExpandProperty DN
         $addrname = $mac | Select-Object -ExpandProperty ADDR
         Write-Output "$DNNAME,$addrNAME" | Out-File $pathToExport -Append
         }
         }
 (Get-Content -path $pathToExport -raw) -replace '/ether-Mgmt-A-PXE','' -replace 'org-root/ls-', '' -replace ',', ', ' | Out-File $pathToExport
 Import-Csv $pathToExport | export-csv $pathtocompletion -NoTypeInformation -UseCulture
 remove-item -Path $pathToExport
