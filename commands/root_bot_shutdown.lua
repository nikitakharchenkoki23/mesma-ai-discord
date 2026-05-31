return {
    name = "bot-shutdown",
    desc = "shutdown the bot (restarts again, uses pm2)",
    category = 'Bot control', -- @TODO: i18n
    adminOnly = true,
    exec = function(message, client, command_arguments)
        message:reply("Shutting down... 🔄")

        client:stop()
        os.exit()
    end
}
