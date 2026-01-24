---@diagnostic disable: undefined-global, lowercase-global

-- Fusion Loader Module
-- Loads a bundled version of Fusion 0.2 suitable for exploit environments.

local success, Fusion = pcall(function()
    -- Uses a community bundled version of Fusion 0.2 (Single file)
    -- Original Source: https://github.com/Elttob/Fusion
    -- Bundle maintained by community for easy loadstring usage
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/julek655/Fusion/master/Fusion.lua"))()
end)

if not success or typeof(Fusion) ~= "table" then
    error("[Blossom] Critical Error: Failed to load Fusion Library.\nPossible causes:\n1. No internet connection\n2. HTTP requests blocked\n3. Executor does not support loadstring/HttpGet\n\nError details: " .. tostring(Fusion))
end

return Fusion
