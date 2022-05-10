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
