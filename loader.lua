local Repo = "https://raw.githubusercontent.com/soda100827/blossom-rivals/main/"

getgenv().BlossomImport = function(path)
    local url = Repo .. path
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        error("[Blossom]: Failed to fetch: " .. path .. "\nError: " .. tostring(result))
    end
    
    if string.find(result, "404: Not Found") then
        error("[Blossom]: 404 Not Found for: " .. path .. "\nCheck casing (src/Core vs src/core)!")
    end
    
    local func, err = loadstring(result)
    if not func then
        error("[Blossom]: Syntax error in: " .. path .. "\nError: " .. tostring(err))
    end
    
    return func()
end

BlossomImport("src/init.lua")
