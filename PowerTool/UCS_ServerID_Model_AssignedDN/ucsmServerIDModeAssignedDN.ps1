#Grabs inventory of ServerID (Server / Chassis Number Model Number and Its AssignedDN and exports the output to a CSV
#directly to the current user's desktop.
#Must have the UCS PowerTool Modules installed to run this.
#Authored by Dan Harrell
#Created on 6/6/2019

#Variable to the UCS Manager
$dc = "YourUCSM"

connect-ucs $dc
Get-UcsBlade | Select-Object ServerId,Model,AssignedToDn | Export-Csv -path "c:\users\$env:USERNAME\desktop\POD_UCS_SERVERS.csv" -NoTypeInformation -UseCulture
disconnect-ucs
