$TaskName = "TASK_CONSOLE_DISCONNECT"
# The description of the task
$TaskDescr = "Run a powershell script through a scheduled task"
# The Task Action command
$TaskCommand = "c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe"
# The PowerShell script to be executed
$TaskScript = "\\SRV-G3\TRACKER$\tache.ps1"
# The Task Action command argument
$typevent="CONSOLE_DISCONNECT"

$TaskArg = "-WindowStyle Hidden -NonInteractive -ExecutionPolicy unrestricted -file $TaskScript -bj $typevent"

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

$requete="<xs:simpleType name='sessionStateChangeType'>
    <xs:restriction
        base='string'
    >
        <xs:enumeration
            value='ConsoleDisconnect'
         />
    </xs:restriction>
</xs:simpleType>"

$triggers = $TaskDefinition.Triggers
#http://msdn.microsoft.com/en-us/library/windows/desktop/aa383915(v=vs.85).aspx
$trigger = $triggers.Create(11) # Creates "On local disconnection to any user" Event trigger
$trigger.StateChange = $requete
$trigger.Enabled = $true

# http://msdn.microsoft.com/en-us/library/windows/desktop/aa381841(v=vs.85).aspx
$Action = $TaskDefinition.Actions.Create(0)
$action.Path = "$TaskCommand"
$action.Arguments = "$TaskArg"

#http://msdn.microsoft.com/en-us/library/windows/desktop/aa381365(v=vs.85).aspx
$rootFolder.RegisterTaskDefinition("$TaskName",$TaskDefinition,6,"System",$null,5)