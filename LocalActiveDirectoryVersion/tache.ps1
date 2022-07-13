param ($bj)

function ReadLogWriteDataToFile($abc){

$A_XML = [XML]$A.ToXML()

if($bj -eq 'LOGON'){

    ## Retrieve Logon Type from XML Object
    $LogonType = (($A_XML.Event.EventData.Data | Select "#text")[8])."#text"

    if($LogonType -eq 2 -or $LogonType -eq 10){
            
            $LogonUser = (($A_XML.Event.EventData.Data | Select "#text")[$abc])."#text"
            $date=[datetime]::Now
            $datetimeString=[String]$date
            $date_time=$datetimeString.replace("/","-").Split(" ")
            
            $destination=$date_time[0]+"_"+$env:COMPUTERNAME
            
            $res=$date_time[0]+","+$date_time[1]+","+$env:COMPUTERNAME+","+$LogonUser+","+$bj
            
            Add-Content "c:\Intune\$destination.txt" "$res"
    }
} 
else{

    $LogonUser = (($A_XML.Event.EventData.Data | Select "#text")[$abc])."#text"

    $date=[datetime]::Now
    $datetimeString=[String]$date
    $date_time=$datetimeString.replace("/","-").Split(" ")

    $destination=$date_time[0]+"_"+$env:COMPUTERNAME

    $res=$date_time[0]+","+$date_time[1]+","+$env:COMPUTERNAME+","+$LogonUser+","+$bj

    Add-Content "c:\Intune\$destination.txt" "$res"
    }
}


if($bj -eq 'SESSION_UNLOCK'){
$A = Get-WinEvent -MaxEvents 1 -FilterHashtable @{ProviderName='Microsoft-Windows-Security-Auditing';ID=4801}
ReadLogWriteDataToFile 1
}
elseif($bj -eq 'SESSION_LOCK'){
$A = Get-WinEvent -MaxEvents 1 -FilterHashtable @{ProviderName='Microsoft-Windows-Security-Auditing';ID=4800}
ReadLogWriteDataToFile 1
}
elseif($bj -eq 'REMOTE_CONNECT'){
$A = Get-WinEvent -MaxEvents 1 -FilterHashtable @{ProviderName='Microsoft-Windows-Security-Auditing';ID=4778}
ReadLogWriteDataToFile 0
}
elseif($bj -eq 'REMOTE_DISCONNECT'){
$A = Get-WinEvent -MaxEvents 1 -FilterHashtable @{ProviderName='Microsoft-Windows-Security-Auditing';ID=4779}
ReadLogWriteDataToFile 0
}
elseif($bj -eq 'LOGON'){
$A = Get-WinEvent -MaxEvents 1 -FilterHashtable @{ProviderName='Microsoft-Windows-Security-Auditing';ID=4624}
ReadLogWriteDataToFile 5
}
elseif($bj -eq 'LOGOFF'){
$A = Get-WinEvent -MaxEvents 1 -FilterHashtable @{ProviderName='Microsoft-Windows-Security-Auditing';ID=4647}
ReadLogWriteDataToFile 1
}
elseif($bj -eq 'CONSOLE_CONNECT'){
$A = Get-WinEvent -MaxEvents 1 -FilterHashtable @{ProviderName='Microsoft-Windows-Security-Auditing';ID=4778}
ReadLogWriteDataToFile 0
}
elseif($bj -eq 'CONSOLE_DISCONNECT'){
$A = Get-WinEvent -MaxEvents 1 -FilterHashtable @{ProviderName='Microsoft-Windows-Security-Auditing';ID=4779}
ReadLogWriteDataToFile 0
}