$bj="STARTUP"
$date=[datetime]::Now
$datetimeString=[String]$date
$date_time=$datetimeString.replace("/","-").Split(" ")

$LogonUser=$env:USERNAME
$destination=$date_time[0]+"_"+$env:COMPUTERNAME

$res=$date_time[0]+","+$date_time[1]+","+$env:COMPUTERNAME+","+$LogonUser+","+$bj

Add-Content \\VOLAZI-SRV-G3\G3_SESSION_RECORD$\$destination.txt "$res"