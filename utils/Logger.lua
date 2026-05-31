local Logger = {}
Logger.__index = Logger

function Logger.new(invoker)
    local self = setmetatable({}, Logger)
    self.invoker = invoker
    return self
end

-- ANSI Color Codes
local colors = {
    reset = "\27[0m",
    red = "\27[31m",
    yellow = "\27[33m",
    cyan = "\27[36m",
    white = "\27[37m"
}

-- Internal helper to format the final string
local function format_log(level_name, color, invoker, message)
    local time = os.date("%H:%M:%S")
    return string.format("%s%s [%s] [%s]: %s%s", color, time, level_name, invoker, message, colors.reset)
end

function Logger:log(message)
    print(string.format("%s [%s]: %s", os.date("%H:%M:%S"), self.invoker, message))
end

function Logger:info(message)
    print(format_log("INFO", colors.cyan, self.invoker, message))
end

function Logger:warn(message)
    print(format_log("WARN", colors.yellow, self.invoker, message))
end

function Logger:error(message)
    print(format_log("ERROR", colors.red, self.invoker, message))
end

return Logger
