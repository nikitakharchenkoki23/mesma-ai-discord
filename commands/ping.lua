local uv = require('uv')

return {
    name = "ping",
    desc = "desc",
    category = 'Misc',
    adminOnly = false,
    exec = function(message, client, command_arguments)

        -- get start time in nanoseconds
        local start_time = uv.hrtime()

        -- @TODO: i18n
        local sent_message = message:reply("Pinging...")

        if sent_message then
            -- get end time, subtract, and convert to milliseconds
            local end_time = uv.hrtime()
            local latency = math.floor((end_time - start_time) / 1e6)

            sent_message:update({
                content = string.format("🏓 **Pong!** %dms", latency)
            })
        end
    end
}
