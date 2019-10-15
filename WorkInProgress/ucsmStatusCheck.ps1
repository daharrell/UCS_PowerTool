#Work in progress, Does not work yet

UCSM Name Variables
$ucs1 = "UCSMName1" 
$ucs2 = "UCSMName2"
$ucsmanagers = $ucs1, $ucs2

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false

$UcsPowerTool =  'Cisco.UcsManager'
Get-Module -name $UcsPowerTool -ErrorAction SilentlyContinue
Import-Module $UcsPowerTool -ErrorAction SilentlyContinue

$username = "UserName"
$password = "C:\Path\To\password.txt"
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, (Get-Content $password | ConvertTo-SecureString)

#$workDirectory ="c:\Temp\"

foreach ($ucsmanager in $ucsmanagers){
    Connect-Ucs $ucsmanager -Credential $cred
    If ($DomStatus.FiALeadership -eq "primary") {
        $FabPrimary = "A"
    } Else {
        $FabPrimary = "B"
    }
    
    $Info = New-Object -TypeName PSObject -Property @{
        "Number of Chassis" = (@($Chassis).Count)
        "Number of Blades" = (@($Blades).Count)
        "Number of RackUnits" = (@($RackUnits).Count)
        "Number of Templates" = (@($SvcProfileTempls).Count)
        "Number of Profiles" = (@($SvcProfiles).Count)
        "UCSM FW" = (Get-UcsFirmwareInfra).OperVersion
        "UCS Domain Name:" = $DomStatus.Name
        "Primary Interconnect" = $FabPrimary
        "HA State" = $DomStatus.HaReadiness   
    }
 
    $Info 
Disconnect-Ucs 
}
