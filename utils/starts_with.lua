return function(str, start)
    return str:sub(1, #start) == start
end
