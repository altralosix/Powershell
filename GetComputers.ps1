



$session = New-PSSession -ComputerName "losixdc1" ###-Credential $credential ####Also disabling this
Invoke-Command $session -Scriptblock { Import-Module ActiveDirectory }
Import-PSSession -Session $session -module ActiveDirectory

##This works pretty decently but seems limited as far as getting contents of a group
##$workstations = (Get-ADComputer -properties * -Filter * -SearchBase "CN=PSComputers, OU=Computers, DC=Losix, DC=Net").name

##This works as far as just getting names of computers in the PSComputers group
$workstations = (Get-ADGroupMember 'PSComputers').name

## Holy fuck this actually works
<#ForEach-Object {
    Get-WmiObject -class win32_operatingsystem -cn $workstations -EA SilentlyContinue |
        Select-Object csname, @{LABEL = 'Last Boot Time'; EXPRESSION = {$_.ConverttoDateTime($_.lastbootuptime)}}
} | Format-Table -Property * -AutoSize#>

## Work in progress, can hopefully return boot time as well as install time?
ForEach-Object {
    Get-WmiObject -class win32_operatingsystem -cn $workstations -EA SilentlyContinue |
        Select-Object csname, @{LABEL = 'Last Boot Time'; EXPRESSION = {$_.ConverttoDateTime($_.lastbootuptime)}}, @{LABEL = 'InstallDate'; EXPRESSION = {$_.ConverttoDateTime($_.installdate)}}, Version, Name, OSArchitecture
} | Format-Table -Property * -AutoSize


##This gets a computer's hostname and last bootup time
## Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}

##Get-WmiObject win32_operatingsystem -cn $workstations ## | Export-Csv .\output.csv

##Get-WmiObject -Class win32_operatingsystem -cn $workstations -EA SilentlyContinue | Format-Table __Server, Manufacturer, Version -AutoSize


Exit-PSSession