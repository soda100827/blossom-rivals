local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.DuelLibrary)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("VoteBanFrame")
local v_u_7 = Color3.fromRGB(255, 50, 50)
local v_u_8 = Color3.fromRGB(127, 25, 25)
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10, p11)
    local v12 = v_u_9
    local v13 = setmetatable({}, v12)
    v13.CreateSound = v_u_5.new()
    v13.Frame = v_u_6:Clone()
    v13.Icon = v13.Frame:WaitForChild("Icon")
    v13.Outline = v13.Frame:WaitForChild("Outline")
    v13.Background = v13.Frame:WaitForChild("Background")
    v13._parent = p10
    v13._size = p11 or UDim2.new(1, 0, 1, 0)
    v13._played = false
    v13:_Init()
    return v13
end
function v_u_9.Play(p14, p15, p16)
    if not p14._played then
        p14._played = true
        local v17 = not p15 and v_u_7 or v_u_4:GetTeamColor(p15)
        local v18 = Color3.new(v17.R * 0.5, v17.G * 0.5, v17.B * 0.5)
        local v19 = p16 and v17 and v17 or v_u_7
        local v20 = p16 and v18 and v18 or v_u_8
        if p16 then
            v17 = v_u_7 or v17
        end
        if p16 then
            v18 = v_u_8 or v18
        end
        p14.Icon.ImageColor3 = v19
        p14.Icon.Size = UDim2.new(1, -16, 1, -16)
        p14.Icon.Position = UDim2.new(0.5, 0, 0.4, 0)
        p14.Icon.Rotation = -45
        p14.Outline.ImageColor3 = v19
        p14.Outline.SliceScale = 0
        p14.Background.ImageColor3 = v20
        p14.Frame.Visible = true
        v_u_2:Create(p14.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            ["Size"] = UDim2.new(0.75, -16, 0.75, -16),
            ["Position"] = UDim2.new(0.5, 0, 0.5, 0),
            ["Rotation"] = 0
        }):Play()
        v_u_2:Create(p14.Icon, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
            ["ImageColor3"] = v17
        }):Play()
        v_u_2:Create(p14.Outline, TweenInfo.new(0.125, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["SliceScale"] = 0.375
        }):Play()
        v_u_2:Create(p14.Outline, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
            ["ImageColor3"] = v17
        }):Play()
        v_u_2:Create(p14.Background, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
            ["ImageColor3"] = v18
        }):Play()
        p14.CreateSound:Fire("rbxassetid://115599786018668", 0.75, 1.5, script, true, 5)
        p14.CreateSound:Fire("rbxassetid://101678983789054", 0.5, 1, script, true, 5)
    end
end
function v_u_9.Destroy(p21)
    p21._played = true
    p21.Frame:Destroy()
end
function v_u_9._Setup(p22)
    p22.Frame.Visible = false
    p22.Frame.Size = p22._size
    p22.Frame.Parent = p22._parent
end
function v_u_9._Init(p23)
    p23:_Setup()
end
return v_u_9