local Repo = "https://raw.githubusercontent.com/soda100827/blossom-rivals/main/"

getgenv().BlossomImport = function(path)
    -- Add timestamp to bypass GitHub raw cache
    local url = Repo .. path .. "?t=" .. tostring(os.time())
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        error("[Blossom]: Failed to fetch: " .. path .. "\nError: " .. tostring(result))
    end
    
    -- Check for 404 text response
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
