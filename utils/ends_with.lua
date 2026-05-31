return function(str, find)
    -- Compare the end of the string to the suffix
    if str:sub(-#find) == find then
        return true
    end
end
