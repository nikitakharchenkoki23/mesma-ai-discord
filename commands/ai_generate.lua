local readJsonFile = require('./lib/readJsonFile')
local config = readJsonFile('./config.json')
local json = require('lib.json')

package.path = package.path .. ";./deps/?.lua;./deps/?/init.lua"

local http = require('deps.coro-http')

return {
    name = "gen",
    desc = "Send a message to an AI",
    category = 'main',
    adminOnly = false,
    exec = function(message, client, command_arguments)
        local provider = config.ai_providers[config.default_ai_provider]
        local request = message.author.name .. " says: " .. table.concat(command_arguments, ' ')

        if not request then
            return message:reply(string.format("Using '%s' model", config.default_ai_model))
        end

        if provider then
            local headers = {{"Content-Type", "application/json"}}
            local body = {
                input = request,
                model = config.default_ai_model
            }

            message.channel:broadcastTyping()

            local res, body = http.request("POST",
                string.format("%s/%s", provider.base_url, provider.endpoints.post_message), headers, json.encode(body))

            if body == "" then
                return message:reply("Server error")
            end

            local parsed_res = json.decode(body)

            if res.code ~= 200 then
                message:reply(string.format("**Server error:** %s\n\n*provider*: %s", parsed_res.error.code,
                    provider.name))
            else
                message.channel:send{
                    content = parsed_res.output[1].content,
                    reference = {
                        message = message,
                        mention = false
                    }
                }
            end

        else
            message:reply("No AI provider is set! check `config.json`")
        end
    end
}
