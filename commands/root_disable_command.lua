return {
    name = "disable-cmd",
    desc = "Disables any command",
    category = 'Bot control',
    adminOnly = true,
    exec = function(message, client, command_arguments)
        -- trim the input (to fix the "test " vs "test" issue)
        local req_command = command_arguments[1] and command_arguments[1]:match("^%s*(.-)%s*$")

        if not req_command then
            return message:reply("Specify a command name.")
        end

        -- @TODO: i18n

        local cmd = CommandManager:get_command(req_command)

        if cmd then
            if cmd.name ~= 'root' then
                CommandManager:disable_command(req_command)
                message:reply(string.format("Command '%s' is disabled.", req_command))
            end
        else
            message:reply(string.format("Command '%s' not found!", req_command))
        end
    end
}
