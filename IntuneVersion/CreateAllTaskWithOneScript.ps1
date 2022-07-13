function create_schedule_task{

    Param (
    [parameter(Mandatory = $True)][String]$TypEvent,
    [parameter()][String]$StateChange
    )

$TaskName = "TASK_SESSION_LOCK"
# The description of the task
$TaskDescr = "Run a powershell script through a scheduled task"
# The Task Action command
$TaskCommand = "c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe"
# The PowerShell script to be executed
$TaskScript = "$psscriptroot\tache.ps1"

#$bj="SESSION_LOCK"
# The Task Action command argument
$TaskArg = "-WindowStyle Hidden -NonInteractive -ExecutionPolicy unrestricted -file $TaskScript -bj $TypEvent"

# The time when the task starts, for demonstration purposes we run it 1 minute after we created the task
$TaskStartTime = [datetime]::Now.AddMinutes(1) 

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

$triggers = $TaskDefinition.Triggers
#http://msdn.microsoft.com/en-us/library/windows/desktop/aa383915(v=vs.85).aspx
$trigger = $triggers.Create(11) # Creates a "One time" trigger
$trigger.StateChange = $StateChange # 

#$trigger.StartBoundary = $TaskStartTime.ToString("yyyy-MM-dd'T'HH:mm:ss")
$trigger.Enabled = $true

# http://msdn.microsoft.com/en-us/library/windows/desktop/aa381841(v=vs.85).aspx
$Action = $TaskDefinition.Actions.Create(0)
$action.Path = "$TaskCommand"
$action.Arguments = "$TaskArg"

#http://msdn.microsoft.com/en-us/library/windows/desktop/aa381365(v=vs.85).aspx
$rootFolder.RegisterTaskDefinition("$TaskName",$TaskDefinition,6,"System",$null,5)


}

create_schedule_task -TypEvent "SESSION_LOCK" -StateChange 7
create_schedule_task -TypEvent "SESSION_UNLOCK" -StateChange 8
create_schedule_task -TypEvent "REMOTE_CONNECT" -StateChange 3
create_schedule_task -TypEvent "REMOTE_DISCONNECT" -StateChange 4
create_schedule_task -TypEvent "CONSOLE_CONNECT" -StateChange "<xs:simpleType name='sessionStateChangeType'>
    <xs:restriction
        base='string'
    >
        <xs:enumeration
            value='ConsoleConnect'
         />
    </xs:restriction>
</xs:simpleType>"

create_schedule_task -TypEvent "LOGON" -StateChange 9
create_schedule_task -TypEvent "SESSION_LOCK" -StateChange 7