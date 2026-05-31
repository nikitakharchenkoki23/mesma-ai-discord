return {
    name = "test",
    desc = "admin-only commands",
    category = 'another category', -- @TODO: i18n
    adminOnly = true,
    exec = function(message, client, command_arguments)
        message.channel:send('test')
    end
}
