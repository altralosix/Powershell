#Script to get a list of computers from an AD group, then return a list of properties from each.

#Connect to DC, not bothering with credentials since I am running this on the local network and already authenticated
$session = New-PSSession -ComputerName "losixdc1" ###-Credential $credential ####Also disabling this
Invoke-Command $session -Scriptblock { Import-Module ActiveDirectory }
Import-PSSession -Session $session -module ActiveDirectory


#Getting names of computers in the PSComputers group
$workstations = (Get-ADGroupMember 'PSComputers').name

# Get the win32_os info from each computer in the list, silently continuing if a machine is offline
ForEach-Object {
    $wmiworkstations = Get-WmiObject -class win32_operatingsystem -cn $workstations -EA SilentlyContinue
}


# Create an array, help from https://www.reddit.com/r/PowerShell/comments/6onj65/custom_object_with_multiple_properties_and/
$workstationOutput = @()
ForEach ($Object in $wmiworkstations)
{
    $Row = New-Object psobject
    # Adding each computer's hostname to array
    $Row | Add-Member -MemberType NoteProperty -Name "Hostname" -value $Object.csname
    # Getting last time computer boot up.  By adding $var.ConvertToDateTime($var.property) we can convert the values
    $Row | Add-Member -MemberType NoteProperty -Name "Last Boot Time" -value $Object.ConvertToDateTime($Object.lastbootuptime)
    # Getting date and time Windows was installed
    $Row | Add-Member -MemberType NoteProperty -Name "Install Date" -value $Object.ConvertToDateTime($Object.installdate)
    # Get free RAM and shorten to GB. -PassThru was key to getting the calculation to work for -value
    $Row | Add-Member -MemberType NoteProperty -Name "Free RAM GB" -value ($Object.FreePhysicalMemory/1MB) -PassThru

    $workstationOutput += $Row
}

$workstationOutput | Format-Table -Property * -AutoSize


# Close the remote Powershell session
Exit-PSSession