# PowershellTokenChecker
Discord Token Checker written in Powershell with an installer to install the function globaly(cuz im too lazy to make a clean module)

## Features
 - Basic Informations Lookup(@me API)
 - Connections Informations
 - Application Informations(JSON Only)
 - Relationship Informations(JSON Only)
 - JSON File Output

## Usage
```
Usage: Tokencheck <token> <showConnections> <trace> <help>


<token> -> Token to lookup, it has to respect one of those 2 regex: [\w-]{24}\.[\w-]{6}\.[\w-]{27} or mfa\.[\w-]{84}

<DisplayConnections> -> Show all connected social medias on the token

<trace> -> Debug informations. Outputs it in a JSON file
[SubParameters]
<showBasicInfos> -> gives you the @me json output 
<showFriends> -> gives you the relationship json output
<showApplications> -> gives you the applications json output
<showConnections> -> gives you the connections json output

<help> -> Displays the help menu
```

## Installation
### Installer
Simply put this in your Powershell terminal
```ps1
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/TaxMachine/PowershellTokenChecker/main/ScriptInstaller.ps1" | Invoke-Expression
```
### Source
Clone this repository
```
git clone https://github.com/TaxMachine/PowershellTokenChecker.git
cd PowershellTokenChecker
```
Copy the path to the tokenchecker.ps1 and put this in your terminal
```ps1
Add-Content -Path $PROFILE -Value "`npath of the tokenchecker.ps1"
```
**KEEP THE \`n ITS A NEWLINE AND ITS IMPORTANT**
