local starts_with = require('../utils/starts_with')
local readJsonFile = require('../lib/readJsonFile')
local string_split = require('../utils/string_split')

local config = readJsonFile('./config.json')

local CommandHandler = {}
CommandHandler.__index = CommandHandler

function CommandHandler.new(command_prefix)
    local self = setmetatable({}, CommandHandler)
    self.command_prefix = command_prefix

    return self
end

function CommandHandler:on_command(message, client)
    local message_content = message.content
    local words = string_split(message_content, ' ')

    local raw_command = words[1]
    local command_name = raw_command:sub(#self.command_prefix + 1)

    local args = words
    table.remove(args, 1)

    local command = _G.CommandManager:get_command(command_name)

    if not command then return end

    -- admin logic
    if command.adminOnly then
        if message.author.id == config.adminId then
            command.exec(message, client, args)
        else
            message:reply('Missing admin permissions!')
        end
    else
        command.exec(message, client, args)
    end
end

return CommandHandler
