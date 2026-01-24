-- Smart Fusion Loader (GitHub Source Tree Support)
-- Dynamically loads Fusion v0.4 from the official repository by emulating Roblox's filesystem behavior.

local BaseUrl = "https://raw.githubusercontent.com/Elttob/Fusion/main/src/"
local ModuleCache = {}

local function CreateVirtualScript(path)
    local VirtualScript = {}
    
    setmetatable(VirtualScript, {
        __index = function(_, key)
            if key == "Parent" then
                -- Handle Parent directory navigation if needed, though rarely used in Fusion imports
                -- Usually Fusion does require(script.Folder.File)
                local parts = string.split(path, "/")
                table.remove(parts, #parts)
                return CreateVirtualScript(table.concat(parts, "/"))
            end
            
            -- Assume accessing a child creates a path to that child
            local childPath = path == "" and key or (path .. "/" .. key)
            return CreateVirtualScript(childPath)
        end
    })
    
    VirtualScript._path = path
    return VirtualScript
end

local function GithubRequire(virtualScript)
    local path = virtualScript._path
    if ModuleCache[path] then return ModuleCache[path] end
    
    -- Try loading as .luau, then .lua, then /init.luau
    local extensions = { ".luau", ".lua", "/init.luau", "/init.lua" }
    local content, finalUrl
    
    for _, ext in ipairs(extensions) do
        -- Add cache busting
        local targetUrl = BaseUrl .. path .. ext .. "?v=" .. tostring(math.random(1, 100000))
        local success, result = pcall(function() return game:HttpGet(targetUrl, true) end)
        if success and result ~= "404: Not Found" and #result > 0 then
            content = result
            finalUrl = targetUrl
            break
        end
    end
    
    if not content then
        error("[Blossom] Fusion Loader: Could not find module '" .. path .. "' at " .. BaseUrl)
    end
    
    -- Compile
    local chunk, err = loadstring(content, path)
    if not chunk then
        error("[Blossom] Syntax Error in " .. path .. ": " .. tostring(err))
    end
    
    -- Sandbox / Environment
    local env = setmetatable({}, { __index = getgenv() })
    
    -- Mock 'script' and 'require'
    env.script = CreateVirtualScript(path)
    env.require = GithubRequire
    
    -- Mock 'table.freeze' if missing (older executors)
    if not table.freeze then env.table.freeze = function(t) return t end end
    
    setfenv(chunk, env)
    
    local result = chunk()
    ModuleCache[path] = result
    return result
end

-- Start loading from init
return GithubRequire(CreateVirtualScript("init"))
