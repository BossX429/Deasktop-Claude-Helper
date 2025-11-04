' VBScript to create Task Scheduler job (alternative to batch)
' Right-click > "Run with PowerShell" or Run as Administrator

Set objScheduler = CreateObject("Schedule.Service")
objScheduler.Connect

Dim rootFolder
Set rootFolder = objScheduler.GetFolder("\")

' Task name and script path
strTaskName = "Claude-Health-Monitor"
strScriptPath = "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1"

' Delete existing task if present
On Error Resume Next
rootFolder.DeleteTask strTaskName, 0
On Error Goto 0

' Create task definition
Set objTaskDef = objScheduler.NewTask(0)

' Set task properties
objTaskDef.RegistrationInfo.Description = "Monitors Claude application health and auto-repairs Squirrel deadlock"
objTaskDef.RegistrationInfo.Author = "System"
objTaskDef.Settings.StartWhenAvailable = True
objTaskDef.Settings.AllowHardTerminate = True
objTaskDef.Settings.RunOnlyIfNetworkAvailable = False
objTaskDef.Settings.Compatibility = 3

' Create trigger (repeat every 5 minutes)
Set objTrigger = objTaskDef.Triggers.Create(1)  ' 1 = Boot trigger
objTrigger.Enabled = True
objTrigger.StartBoundary = FormatDateTime(Now(), 4)
objTrigger.RepetitionInterval = "PT5M"  ' ISO 8601: 5 minutes
objTrigger.RepetitionDuration = "P365D"  ' ISO 8601: 365 days

' Create action (run PowerShell script)
Set objAction = objTaskDef.Actions.Create(0)  ' 0 = Execute
objAction.Path = "powershell.exe"
objAction.Arguments = "-NoProfile -ExecutionPolicy Bypass -File """ & strScriptPath & """"
objAction.WorkingDirectory = "C:\Users\Someone\AppData\Local\AnthropicClaude"

' Register task with highest privileges
Set objRegInfo = objTaskDef.Principal
objRegInfo.Id = "Author"
objRegInfo.DisplayName = "SYSTEM"
objRegInfo.LogonType = 5  ' TASK_LOGON_SERVICE_ACCOUNT
objRegInfo.RunLevel = 1   ' TASK_RUNLEVEL_HIGHEST

' Save the task
rootFolder.RegisterTaskDefinition strTaskName, objTaskDef, 6, Null, Null, 5

MsgBox "✓ Task 'Claude-Health-Monitor' created successfully!" & vbCrLf & vbCrLf & _
        "Schedule: Every 5 minutes" & vbCrLf & _
        "Privilege: SYSTEM (Highest)" & vbCrLf & _
        "Status: ACTIVE"
