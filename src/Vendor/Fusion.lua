-- Fusion Loader Module
-- This module acts as a bridge to load Fusion.
-- In a production build script, this file would be replaced by the actual Fusion bundle.

local success, Fusion = pcall(function()
    -- Loading Fusion v0.2 (common for exploits) or v0.3
    -- Using a reliable mirrored source or official repo
    -- Note: In a real environment, you should save this to file or use a build tool
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/dphfox/Fusion/main/src/init.luau"))()
end)

if not success then
    -- Mock Fusion for local syntax checking / fallback
    warn("[Blossom] Failed to download Fusion. If you are in VS Code, this is expected.")
    
    -- Minimal mock for local editor to not stroke out (Optional)
    Fusion = {
        New = function() return function() end end,
        Value = function() end,
        Computed = function() end,
        Children = {},
        OnEvent = function() end,
    }
end

return Fusion
