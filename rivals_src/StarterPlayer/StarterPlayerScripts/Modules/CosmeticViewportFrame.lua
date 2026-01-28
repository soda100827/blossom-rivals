local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.PlayerDataUtility)
local v_u_4 = require(v1.Modules.CosmeticLibrary)
local v_u_5 = require(v1.Modules.SeasonLibrary)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.WrapController)
require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("StaticModel"):WaitForChild("StaticViewModel"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewportCameras"))
local v_u_9 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CosmeticViewportFrame")
local v_u_10 = v2.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("Wrap")
local v_u_11 = v2.LocalPlayer.PlayerScripts.Assets:WaitForChild("Charms")
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12.new(p13, p14)
    local v15 = v_u_12
    local v16 = setmetatable({}, v15)
    v16.Name = p13
    v16.Info = v_u_4.Cosmetics[v16.Name]
    v16.IsLocked = p14
    v16.Frame = v_u_9:Clone()
    v16:_Init()
    return v16
end
function v_u_12.Destroy(p17)
    p17.Frame:Destroy()
end
function v_u_12._SetupSeasonRankCharm(p18, p19)
    if #p18.Name >= 8 then
        local v20 = p18.Name
        if string.sub(v20, 1, 7) == "Season " then
            local v21 = p18.Name
            local v22 = string.sub(v21, 8)
            local v23 = tonumber(v22)
            if v23 then
                local v24 = v_u_5.SeasonsByVersion[v23].Name
                local v25, v26 = v_u_3:GetSeasonInfo(v_u_6, v24)
                v_u_5:FormatSeasonRankCharm(p19, v24, v25, v26)
            end
        end
    end
end
function v_u_12._Setup(p27)
    p27.Frame.ImageColor3 = p27.IsLocked and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p27.Frame.ImageTransparency = p27.IsLocked and 0.5 or 0
    if p27.Name ~= "NONE_COSMETIC" and p27.Name ~= "RANDOM_COSMETIC" then
        if p27.Info.Type == "Charm" then
            local v28 = v_u_11[p27.Name]:Clone()
            v28.PrimaryPart = v28.Primary
            v28:PivotTo(CFrame.identity)
            v28.Hook:Destroy()
            v28.Parent = p27.Frame
            task.defer(p27._SetupSeasonRankCharm, p27, v28)
            p27.Frame.CurrentCamera = v_u_8.Charm
            return
        end
        if p27.Info.Type == "Wrap" then
            local v29 = v_u_10:Clone()
            v29:PivotTo(CFrame.identity)
            v29.Parent = p27.Frame
            v_u_7:ApplyWrap(v_u_7:RecordOriginalWrapProperties(v29), {
                ["Name"] = p27.Name
            })
            p27.Frame.CurrentCamera = v_u_8.Wrap
        end
    end
end
function v_u_12._Init(p30)
    p30:_Setup()
end
return v_u_12