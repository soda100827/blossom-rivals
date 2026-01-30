local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._moving_textures = {}
    v6:_Init()
    return v6
end
function v_u_3.Update(p7, _)
    local v8 = workspace:GetServerTimeNow() / 7
    for v9, v10 in pairs(p7._moving_textures) do
        local v11 = p7:_GetCameraOffset() / v10
        v9.OffsetStudsU = v11.Z + v8 % v9.StudsPerTileU
        v9.OffsetStudsV = v11.Y + v8 % v9.StudsPerTileV
    end
end
function v_u_3._GetCameraOffset(p12)
    return p12.Object.Position - (workspace.CurrentCamera.CFrame * workspace.CurrentCamera.Focus).Position
end
function v_u_3._Setup(p13)
    for _, v14 in pairs(p13.ExtraObjects) do
        if v14:IsA("Texture") then
            p13._moving_textures[v14] = v14.Name == "RibbonTexture2" and 800 or 1300
        end
    end
end
function v_u_3._Init(p15)
    p15:_Setup()
end
return v_u_3