local uv = require('uv')
local discord_colors = require('../utils/discord_colors')
local readJsonFile = require('../lib/readJsonFile')

local config = readJsonFile('./config.json')

local discordia_version = require('deps.discordia.package').version

local function toGB(bytes)
    return bytes / 1024 / 1024 / 1024
end

local function round(num)
    return math.floor(num + 0.5)
end

return {
    name = "botinfo", -- @TODO: i18n
    desc = "Soft- and hardware info and bot stats",
    category = "Misc",
    exec = function(message, client, command_arguments)
        local totalBytes = uv.get_total_memory()
        local freeBytes = uv.get_free_memory()
        local usedBytes = totalBytes - freeBytes
        local luaMemGB = collectgarbage("count") / 1024 / 1024

        local memoryUsage =
            string.format("%.2fMB (%.1fGB/%.1fGB)", luaMemGB * 1024, -- showing lua ram usage in MB is usually more helpful
            toGB(usedBytes), toGB(totalBytes))

        local cpuModel = uv.cpu_info()[1].model

        -- 2. System Uptime
        local total_seconds = math.floor(uv.uptime())
        local days = math.floor(total_seconds / 86400)
        local hours = math.floor((total_seconds % 86400) / 3600)
        local minutes = math.floor((total_seconds % 3600) / 60)
        local seconds = total_seconds % 60

        local statsMessage = string.format(
            "**Lua Version:** %s\n" .. "**Discordia Version:** %s\n" .. "**CPU:** %s\n" .. "**ОЗУ:** %s\n" ..
                "**System uptime:** %dd %dh %dm %ds\n" .. "**Developer:** %s\n" .. "**Guilds:** %d",
            _VERSION, -- 1
            discordia_version, -- 2
            cpuModel, -- 3
            memoryUsage, -- 4
            days, -- 5
            hours, -- 6
            minutes, -- 7
            seconds, -- 8
            client:getUser("643945264868098049").mentionString, #client.guilds or "unknown")

        local embed_title = "mesma-ai v" .. config.version

        local reply = message.channel:send({
            embed = {
                title = embed_title,
                thumbnail = {
                    url = client.user.avatarURL
                },
                description = statsMessage .. "\n**Ping:** ..."
            }
        })

        local pingTime = math.abs(round((reply.createdAt - message.createdAt) * 1000))

        if reply then
            -- edit the message with the final result
            reply:setEmbed({
                title = embed_title,
                thumbnail = {
                    url = client.user.avatarURL
                },
                color = discord_colors.fuchsia,
                description = statsMessage .. "\n**Ping:** " .. pingTime .. "мс"
            })
        end

    end
}
