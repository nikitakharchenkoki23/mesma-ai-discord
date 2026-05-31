return {
    name = "bot-restart",
    desc = "restart the bot",
    category = 'Bot control', -- @TODO: i18n
    adminOnly = true,
    exec = function(message, client, command_arguments)
        -- @TODO: use pm2
        message:reply("Restarting... 🔄")

        client:stop()
        os.exit()
    end
}
