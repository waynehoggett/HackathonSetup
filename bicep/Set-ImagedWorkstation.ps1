# Download Pester Tests
## Hackathon tests
Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/bicep/hackathon.tests.ps1' -Destination 'C:\Tests\hackathon.tests.ps1'
## Pode Server file
Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/bicep-shared/Server.ps1' -Destination 'C:\Tests\Server.ps1'

# Setup Pode as a Service
# As per: https://pode.readthedocs.io/en/stable/Hosting/RunAsService/
$exe = (Get-Command powershell.exe).Source
$name = 'Pode Web Server'
$file = 'C:\Tests\Server.ps1'
$arg = "-ExecutionPolicy Bypass -NoProfile -Command `"$($file)`""
nssm install $name $exe $arg
nssm start $name