$TaskName = "TASK_LOGOFF"
# The description of the task
$TaskDescr = "Run a powershell script through a scheduled task"
# The Task Action command
$TaskCommand = "c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe"
# The PowerShell script to be executed
$TaskScript = "\\SRV-G3\TRACKER$\tache.ps1"
# The Task Action command argument
$typevent="LOGOFF"

$TaskArg = "-WindowStyle Hidden -NonInteractive -ExecutionPolicy unrestricted -file $TaskScript -bj $typevent"

# The time when the task starts, for demonstration purposes we run it 1 minute after we created the task
$TaskStartTime = [datetime]::Now
# attach the Task Scheduler com object
$service = new-object -ComObject("Schedule.Service")
# connect to the local machine. 
# http://msdn.microsoft.com/en-us/library/windows/desktop/aa381833(v=vs.85).aspx
$service.Connect()
$rootFolder = $service.GetFolder("\")

$TaskDefinition = $service.NewTask(0) 
$TaskDefinition.RegistrationInfo.Description = "$TaskDescr"
$TaskDefinition.Settings.Enabled = $true
$TaskDefinition.Settings.AllowDemandStart = $true

#$requete="<QueryList><Query Id='0'><Select Path='Security'>*[Security[Provider[@Name=''] and EventID=4647]]</Select></Query></QueryList>"
$requete="<QueryList><Query Id='0' Path='Security'><Select Path='Security'>*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and EventID=4647]]</Select></Query></QueryList>"

$triggers = $TaskDefinition.Triggers
#http://msdn.microsoft.com/en-us/library/windows/desktop/aa383915(v=vs.85).aspx
$trigger = $triggers.Create(0) # Creates "On LOGON" Event trigger
$trigger.Subscription = $requete
$trigger.Enabled = $true

# http://msdn.microsoft.com/en-us/library/windows/desktop/aa381841(v=vs.85).aspx
$Action = $TaskDefinition.Actions.Create(0)
$action.Path = "$TaskCommand"
$action.Arguments = "$TaskArg"

#http://msdn.microsoft.com/en-us/library/windows/desktop/aa381365(v=vs.85).aspx
$rootFolder.RegisterTaskDefinition("$TaskName",$TaskDefinition,6,"System",$null,5)