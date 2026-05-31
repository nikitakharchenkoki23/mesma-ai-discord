local uv = require('uv')

return {
    name = "eval",
    desc = "executes a Lua code",
    category = 'system',
    adminOnly = true,
    exec = function(message, client, command_arguments)
        local code = command_arguments[1]

        local code = table.concat(command_arguments, " ")
        if code == "" then
            return message:reply("Specify code to evaluate.")
        end


        local header = "local message, client, args = ... "
        local func, load_err = load(header .. "return " .. code)

        if not func then
            func, load_err = load(header .. code)
        end


        local success, result = pcall(func, message, client, command_arguments)

        if not func then
            return message:reply("```lua\n[Load Error]: " .. tostring(load_err) .. "```")
        end

        local success, result = pcall(func, message, client, command_arguments)

        if success then
            local output = inspect(result)
            if #output > 1900 then
                output = output:sub(1, 1900) .. "..."
            end
            message:reply("```lua\n" .. output .. "```")
        else
            message:reply("```lua\n[Runtime Error]: " .. tostring(result) .. "```")
        end

    end
}
