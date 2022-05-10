function Get-Badges {
    param (
        [Parameter()]
        [int]$Value
    )
    $badges = switch ($Value) {
        {$Value -band 1} {'Staff'}
        {$Value -band 2} {'Partner'}
        {$Value -band 4} {'Hypesquad Event'}
        {$Value -band 8} {'Bug Hunter'}
        {$Value -band 64} {'Bravery'}
        {$Value -band 128} {'Brilliance'}
        {$Value -band 256} {'Balance'}
        {$Value -band 512} {'Early Supporter'}
        {$Value -band 16384} {'Bug Hunter Gold'}
        {$Value -band 131072} {'Early Bot Developer'}
    }
    $badges -join ' | '
}

function Get-Nitro($e) {
    $subscription = ""
    switch -Exact ($e) {
        0 {$subscription += "No Nitro"; break}
        1 {$subscription += "Nitro Classic"; break}
        2 {$subscription += "Nitro Boost"; break}
    }
    return $subscription
}

function Tokencheck {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$token,
        [Parameter(Mandatory=$false)]
        [switch]$trace,
        [Parameter(Mandatory=$false)]
        [switch]$displayConnections,
        [Parameter(Mandatory=$false)]
        [switch]$help,
        [Parameter(Mandatory=$false)]
        [switch]$showBasicInfos,
        [Parameter(Mandatory=$false)]
        [switch]$showConnections,
        [Parameter(Mandatory=$false)]
        [switch]$showApplications,
        [Parameter(Mandatory=$false)]
        [switch]$showFriends
    )
    if ($help.IsPresent) {
        $helpmenu = @"
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
"@
    Write-Host $helpmenu -ForegroundColor Green
    Return
    }
    $header = @{
        authorization = $token
    }
    $discord = Invoke-RestMethod -Uri "https://discord.com/api/v9/users/@me" -Headers $header -UseBasicParsing
    if ($discord.code) {
        Write-Host "Invalid Token" -ForegroundColor Red
        Return
    }
    $toucan = ""
    $traces = ""
    $friend = Invoke-RestMethod -Uri "https://discordapp.com/api/v9/users/@me/relationships" -Headers $header -UseBasicParsing 
    $guild = Invoke-RestMethod -Uri "https://discord.com/api/v9/users/@me/guilds" -Headers $header -UseBasicParsing 
    $connections = Invoke-RestMethod -Uri "https://discordapp.com/api/v9/users/@me/connections" -Headers $header -UseBasicParsing
    $applications = Invoke-RestMethod -Uri "https://discord.com/api/v9/applications" -Headers $header -UseBasicParsing
    if ($discord.bio){$bio=$discord.bio}else{$bio="No bio"}
    if ($discord.phone){$phone=$discord.phone}else{$phone="No Phone"}
    if ($discord.avatar){$avatar="https://cdn.discordapp.com/avatars/$($discord.id)/$($discord.avatar).png"}else{$avatar="None"}
    if ($discord.banner){$banner="https://cdn.discordapp.com/banners/$($discord.id)/$($discord.banner).png"}else{$banner="None"}
    $basicinfos = @"
--- basic Informations ---
Username: $($discord.username)#$($discord.discriminator)
Email: $($discord.email)
Phone: $($phone)
ID: $($discord.id)
Language: $($discord.locale)
NSFW Allowed: $($discord.nsfw_allowed)
MFA Enabled: $($discord.mfa_enabled)
Total Friends: $($friend.length)
Total Guild: $($guild.length)
Total Connections: $($connections.length)
Total Applications: $($applications.length)
Avatar URL: $avatar
Banner URL: $banner
Nitro Subscription: $(Get-Nitro($discord.premium_type))
Badges: $(Get-Badges($discord.flags))
Biography
------- Biography -------
$($bio)
-------------------------
"@
    $toucan += $basicinfos
    if ($displayConnections.IsPresent) {
        for ($g -eq 0;$g -lt $connections.length;$g++) {
            if ($null -eq $g) {Out-Null}else{
            if ($connections[$g].visibility -eq 0) {
                $visibility = "Hidden"
            } else {$visibility="Visible"}
            if ($connections[$g].access_token) {
                $accesstoken = $connections[$g].access_token
            } else {$accesstoken="No Token"}
            if ($connections[$g].name) {
                $name = $connections[$g].name
            } else {$name="No Name"}
                $conn = @"
-------------------------------------------
Type: $($connections[$g].type)

ID: $($connections[$g].id)
Name: $name
Visibility: $visibility
Revoked: $($connections[$g].revoked)
Friend Sync: $($connections[$g].friend_sync)
Show Activity: $($connections[$g].show_activity)
Verified: $($connections[$g].verified)
Access Token: $accesstoken
-------------------------------------------
"@
                $toucan += "`n"+$conn
            }
        }
    }
    Write-Host $toucan -ForegroundColor Green
        switch ($trace.IsPresent) {
            $showBasicInfos {$traces += ($discord|ConvertTo-Json)+",`n"; break}
            $showConnections {$traces += ($connections|ConvertTo-Json)+",`n"; break}
            $showApplications {$traces += ($applications|ConvertTo-Json)+",`n"; break}
            $showFriends {$traces += ($friend|ConvertTo-Json)+",`n"; break}
        }
        Add-Content -Path ".\$($discord.id).json" -Value $traces
}
