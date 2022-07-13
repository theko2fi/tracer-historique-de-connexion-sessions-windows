param ($bj)

Function Send-Syslog {
 
    Param (
    [parameter(Mandatory = $True)]
    [String]$Message
    )


# Sender
# envoie de syslog en tcp :
$port=514
$remoteHost = "intune.xxxxxxx.xyz"
#$Message = 'This is a test of powershell to syslog'
#ref : https://cyber-defense.sans.org/blog/2016/06/01/powershell-function-to-send-udp-syslog-message-packets
$Severity = 5 #notice
$Facility = 4 #Security
$pri = "<" + ($Facility +""+ $Severity) + ">"
$LocaleUS = New-Object System.Globalization.CultureInfo("en-US")
$timestamp =(Get-Date).tostring("MMM dd HH:mm:ss",$LocaleUS) 
$header = $timestamp + " " + ($env:computername).tolower().replace(" ","").trim() + " "
$Tag = "AppTag"
$msg = $pri + $header + $tag + ": " + $Message
# Convert message to array of ASCII bytes.
 $bytearray = $([System.Text.Encoding]::ASCII).getbytes($msg)
# RFC3164 Section 4.1: "The total length of the packet MUST be 1024 bytes or less."
 if ($bytearray.count -gt 996) { $bytearray = $bytearray[0..995] }
$socket = new-object System.Net.Sockets.TcpClient($remoteHost, $port)
$stream = $socket.GetStream()
$stream.Write($bytearray, 0, $bytearray.Length)
$stream.Flush()
    
    }

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
            
            Send-Syslog -Message "$res" 
    }
} 
else{

    $LogonUser = (($A_XML.Event.EventData.Data | Select "#text")[$abc])."#text"

    $date=[datetime]::Now
    $datetimeString=[String]$date
    $date_time=$datetimeString.replace("/","-").Split(" ")

    $destination=$date_time[0]+"_"+$env:COMPUTERNAME

    $res=$date_time[0]+","+$date_time[1]+","+$env:COMPUTERNAME+","+$LogonUser+","+$bj

    Send-Syslog -Message "$res"
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