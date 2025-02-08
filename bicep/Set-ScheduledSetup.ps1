# Create C:\Setup if it doesn't exist
if (-not (Test-Path 'C:\Setup' -ErrorAction SilentlyContinue)) {
    $null = New-Item -Path 'C:\' -Name "Setup" -ItemType Directory
}

# Download the Setup-Workstation script
Start-BitsTransfer -Source "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/bicep/Setup-Workstation.ps1" -Destination "C:\Setup\Setup-Workstation.ps1"

# Define the action to run (change this to the path of your program or command)
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\Setup\Setup-Workstation.ps1"

# Define the trigger to run the task immediately
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMilliseconds(100)

# Define the principal to run the task as SYSTEM
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Create the scheduled task
Register-ScheduledTask -TaskName "Setup-Workstation" -Action $Action -Trigger $Trigger -Principal $Principal