$session = New-PSSession -ComputerName "losixdc1" ###-Credential $credential ####Also disabling this
Invoke-Command $session -Scriptblock { Import-Module ActiveDirectory }
Import-PSSession -Session $session -module ActiveDirectory


##This works as far as just getting names of computers in the PSComputers group
$workstations = (Get-ADGroupMember 'PSComputers').name


ForEach-Object {
    $wmiworkstations = Get-WmiObject -class win32_operatingsystem -cn $workstations -EA SilentlyContinue
}



$myobject = @()
ForEach ($Object in $wmiworkstations)
{
    $Row = New-Object psobject
    $Row | Add-Member -MemberType NoteProperty -Name "Hostname" -value $Object.csname
    # Getting last time computer boot up.  By adding $var.ConvertToDateTime($var.property) we can convert the values
    $Row | Add-Member -MemberType NoteProperty -Name "LastBootTime" -value $Object.ConvertToDateTime($Object.lastbootuptime)
    $Row | Add-Member -MemberType NoteProperty -Name "Install Date" -value $Object.ConvertToDateTime($Object.installdate)

    $myobject += $Row
} ##| Format-Table -Property * -AutoSize

$myobject | Format-Table -Property * -AutoSize


# $workstations | Format-Table -Property * -AutoSize




Exit-PSSession