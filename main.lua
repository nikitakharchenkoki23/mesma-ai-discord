local discordia = require('discordia')
 _G.discordia = discordia 
local client = discordia.Client()

local inspect = require('./lib/inspect')

local readJsonFile = require('./lib/readJsonFile')
local command_handler = require('./classes/CommandHandler')
_G.CommandManager = require('./classes/CommandManager')
local starts_with = require('./utils/starts_with')
local Logger = require('./utils/Logger')

local config = readJsonFile('./config.json')

local CommandHandler = command_handler.new(config.prefix)
local logger = Logger.new('main')

_G.inspect = inspect

client:on('ready', function()
	logger:info('Logged in as '.. client.user.username)

    CommandManager:register_commands()
end)

client:on('messageCreate', function(message)
    if message.author.bot then return end
    if not starts_with(message.content, config.prefix) then return end

    local success, err = pcall(function()
        CommandHandler:on_command(message, client)
    end)

    if not success then
        logger:error("Error in CommandHandler:on_command: " .. tostring(err))
    end
end)

client:run(config.token)