local Repo = "https://raw.githubusercontent.com/soda100827/blossom-rivals/main/"

getgenv().BlossomImport = function(path)
    -- Add a random number to bypass executor caching (Critical for 404 fixes)
    local url = Repo .. path .. "?v=" .. tostring(math.random(1, 10000))
    
    print("[Blossom] Fetching: " .. url) -- Debug print
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        error("[Blossom]: Failed to fetch: " .. path .. "\nError: " .. tostring(result))
    end
    
    if string.find(result, "404: Not Found") then
        error("[Blossom]: 404 Not Found for: " .. path .. "\nFull URL: " .. url)
    end
    
    local func, err = loadstring(result)
    if not func then
        error("[Blossom]: Syntax error in: " .. path .. "\nError: " .. tostring(err))
    end
    
    return func()
end

BlossomImport("src/init.lua")
