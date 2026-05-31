local discord_colors = require('../utils/discord_colors')

return {
    name = "help",
    desc = "Get all commands", -- @TODO: i18n
    category = 'main',
    adminOnly = false,
    exec = function(message, client, args)
        local sub_command_name = args[1] -- arg

        -- prevent recursion (!help help)
        if sub_command_name == "help" then
            return
        end

        local command = CommandManager:get_command(sub_command_name)

        if command and command.name ~= 'help' then
            if command.adminOnly then
                message:reply({
                    embed = {
                        title = "Help: " .. command.name .. " (admin-only)",
                        description = "**Description:** " .. command.desc or "no description",
                        color = discord_colors.green
                    }
                })
            else
                message:reply({
                    embed = {
                        title = "Help: " .. command.name,
                        description = "**Description:** " .. command.desc or "no description",
                        color = discord_colors.green
                    }
                })
            end

        else
            local commands = CommandManager:get_commands()

            if next(commands) == nil then -- next(tbl) повертає nil, якщо таблиця порожня
                return
            end

            local grouped = {}

            for cmd_name, cmd in pairs(commands) do
                if cmd_name ~= 'help' then
                    local cat = cmd.category or "unknown"

                    if not grouped[cat] then
                        grouped[cat] = {}
                    end

                    table.insert(grouped[cat], string.format("`%s`", cmd_name))
                end
            end

            local commands_output = ""

            for cat, names in pairs(grouped) do
                table.sort(names)

                local line = table.concat(names, ", ")
                commands_output = commands_output .. '\n**' .. cat .. '**' .. "\n" .. line .. "\n"
            end

            -- @TODO: i18n
            message:reply({
                embed = {
                    title = "Available commands:",
                    description = commands_output,
                    color = discord_colors.blurple
                }
            })

        end
    end
}
