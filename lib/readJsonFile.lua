local json = require('lib/json')

return function(file_path)
    local f = io.open(file_path, "r")
    if f then
        local raw_content = f:read('*all')
        f:close()

        return json.decode(raw_content)
    else
        return nil -- return nil if file doesn't exist
    end
end
