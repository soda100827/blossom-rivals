local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.DuelLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_5 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LockedMapSlot")
local v_u_6 = {
    ["ReleaseRatio"] = 1.025,
    ["HoverRatio"] = 1.025
}
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8, p9)
    local v10 = v_u_7
    local v11 = setmetatable({}, v10)
    v11.Name = p8
    v11.Frame = v_u_5:Clone()
    v11._ignore_button_effect = p9
    v11:_Init()
    return v11
end
function v_u_7.SetParent(p12, p13)
    p12.Frame.Parent = p13
end
function v_u_7.Destroy(p14)
    p14.Frame:Destroy()
end
function v_u_7._Setup(p15)
    local v16 = v_u_3.Maps[p15.Name]
    local v17 = v_u_3.MapDifficulties[v16.Difficulty]
    local _, _, v18 = v17.Color:ToHSV()
    p15.Frame.Button.Background.ImageColor3 = v18 < 0.1 and Color3.fromRGB(31, 31, 31) or Color3.fromRGB(0, 0, 0)
    p15.Frame.Button.Background.Texture.ImageColor3 = v17.Color
    p15.Frame.Button.Difficulty.BackgroundColor3 = v17.Color
    p15.Frame.Button.Difficulty.ImageColor3 = v17.Color
    p15.Frame.Button.Difficulty.UIStroke.Color = v17.Color
    p15.Frame.Button.DifficultyVignette.ImageColor3 = v17.Color
    if not p15._ignore_button_effect then
        v_u_4:Add(p15.Frame.Button, nil, v_u_6)
    end
end
function v_u_7._Init(p19)
    p19:_Setup()
end
return v_u_7