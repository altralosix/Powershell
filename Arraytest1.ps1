


<#
$workstations = (Get-ADGroupMember 'PSComputers').name

$workstationObject = @()

ForEach ($Object in $workstations)
    {
        $Row = New-Object psobject
        $Row = Add-Member -MemberType NoteProperty -Name "ColumnA" -value $Object.Name
    }
 #>

$sourcedata = Get-ChildItem -Path C:\users   #just using this to get a few data points

$myObject = @()   #have to pre-define the variable as an array so we can add more than 1 object/row
foreach ($Object in $sourcedata)
    {
    $Row = New-Object psobject
    $Row | Add-Member -MemberType NoteProperty -Name "ColumnA" -value $Object.Name
    $Row | Add-Member -MemberType NoteProperty -Name "ColumnB" -value $Object.Mode
    $Row | Add-Member -MemberType NoteProperty -Name "ColumnC" -value $Object.FullName

    $myObject += $Row
    }

$myObject
ColumnA       ColumnB ColumnC
-------       ------- -------
Administrator d-----  C:\users\Administrator
lpeterson     d-----  C:\users\lpeterson
LSI           d-----  C:\users\LSI
Public        d-r---  C:\users\Public

#ForEach-Object {
#    Get-WmiObject -class win32_operatingsystem -cn $workstations -EA SilentlyContinue |
#        Select-Object csname, @{LABEL = 'Last Boot Time'; EXPRESSION = {$_.ConverttoDateTime($_.lastbootuptime)}}, @{LABEL = 'InstallDate'; EXPRESSION = {$_.ConverttoDateTime($_.installdate)}}, Version, Name, OSArchitecture
#} | Format-Table -Property * -AutoSize



<#
Exit-PSSession
 #>





<# $array = @()

(1..4) | ForEach-Object {

    $MyObject = [PSCustomObject] @{
        'ColumnA' = 'ValueA'
        'ColumnB' = 'ValueB'
        'ColumnC' = 'ValueC'
    }

    $array += $MyObject
}


$array #>

















