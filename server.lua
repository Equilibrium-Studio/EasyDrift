-- server.lua
RegisterServerEvent('drift:logToDiscord')
AddEventHandler('drift:logToDiscord', function(points)
    local discordWebhook = ConfigShared.DiscordLog  -- Replace with your webhook URL
    local playerName = GetPlayerName(source)
    local playerIdentifier = GetPlayerIdentifier(source, 0) -- 0 for license identifier

    local message = {
        {
            ["color"] = 16711680,
            ["title"] = "**Drift Points Logged**",
            ["description"] = "Player: " .. playerName .. "\nSteam License: " .. playerIdentifier .. "\nPoints: " .. points,
            ["footer"] = {
                ["text"] = "Drift Logging System By Clin",
            },
        }
    }

    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = 'Drift Logger', embeds = message}), { ['Content-Type'] = 'application/json' })
end)
