local uv = require('uv')
local logger = require('../utils/Logger').new("classes/CommandManager")

local CommandManager = {}

CommandManager.commandsMap = {}
CommandManager.adminCommandsMap = {}

function CommandManager:register_commands()
    local commands_folder = './commands'
    local res, err = uv.fs_scandir(commands_folder)

    if not res then
        return logger:error(err)
    end

    while true do
        local name, fType = uv.fs_scandir_next(res)
        if not name then
            break
        end

        if fType == 'file' and name:sub(-4) == ".lua" then
            local cleanName = name:gsub("%.lua$", "")
            local success, command = pcall(require, "commands." .. cleanName)
            if not success then
                logger:error("Failed to load " .. cleanName .. ": " .. tostring(command))
            end

            if success and type(command) == "table" and command.name then
                if command.adminOnly then
                    self.adminCommandsMap[command.name] = command
                else
                    self.commandsMap[command.name] = command
                end
                logger:log("Registered: " .. command.name)
            end
        end
    end
end



function CommandManager:get_command(name)
    return self.commandsMap[name] or self.adminCommandsMap[name]
end

function CommandManager:get_commands(admin)
    if admin then
        return self.adminCommandsMap
    else
        return self.commandsMap
    end
end

function CommandManager:disable_command(name)
    -- перевіряємо, чи існує команда в загальній або адмін‑таблиці
    if self.commandsMap[name] then
        self.commandsMap[name] = nil
        return true
    elseif self.adminCommandsMap[name] then
        self.adminCommandsMap[name] = nil
        return true
    end

    return false -- команда не знайдена
end

return CommandManager
