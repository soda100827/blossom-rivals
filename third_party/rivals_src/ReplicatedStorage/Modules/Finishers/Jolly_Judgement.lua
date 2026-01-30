local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
game:GetService("HttpService")
game:GetService("Lighting")
local v3 = game:GetService("Players")
local v4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.Finishers.Ragdoll)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = v4.IS_CLIENT
if v_u_7 then
    v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers.FighterController)
end
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_5.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11:_Init()
    return v11
end
function v_u_8.PlayClient(p12, p13)
    v_u_5.PlayClient(p12, p13)
    if not p13 then
        local v14 = v_u_7:GetFighter(p12._eliminator)
        if not (v14 and v14:Get("IsSpectating")) then
            return
        end
    end
    p12:CreateSound("rbxassetid://127879822444105", 1.25, 0.95 + 0.1 * math.random(), script, true, 10)
    p12:CreateSound("rbxassetid://118355855043527", 0.875, 0.98 + 0.04 * math.random(), script, true, 10)
    local v15 = p12._is_humanoid and p12._subject.RootPart or p12._subject
    local v16 = Instance.new("Part")
    v16.CFrame = CFrame.new(v15.Position)
    v16.Size = Vector3.new(1, 1, 1)
    v16.Transparency = 1
    v16.CastShadow = false
    v16.CanCollide = false
    v16.CanTouch = false
    v16.CanQuery = false
    v16.Anchored = true
    v16.Parent = v15
    local v17 = p12._destroy_these
    table.insert(v17, v16)
    local v18 = math.random() < 0.5
    local v19 = script.BillboardGui:Clone()
    v19.Value.Text = v18 and "NAUGHTY." or "NICE!"
    v19.Value.TextColor3 = v18 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 255, 50)
    v19.Value.UIStroke.Color = v18 and Color3.fromRGB(127, 25, 25) or Color3.fromRGB(50, 127, 25)
    v19.Value.UIStroke.Transparency = 0
    v19.Parent = v16
    local v20 = p12._destroy_these
    table.insert(v20, v19)
    local v_u_21 = v19.Value
    local v_u_22 = v18 and 1 or -1
    v_u_6:RenderstepForLoop(0, 100, 3, function(p23)
        local v24 = p23 / 100
        local v25 = v_u_2:GetValue(v24, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local v26 = v_u_2:GetValue(v24, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local v27 = 1 - 0.5 * v26
        v_u_21.Position = UDim2.new(0.5 + 0.125 * v25 * v_u_22, 0, 0.5 + 0.125 * v26, 0)
        v_u_21.Size = UDim2.new(1 * v27, 0, 0.075 * v27, 0)
        v_u_21.Rotation = v24 ^ 4 * 260 * v_u_22
    end)
    v19:Destroy()
end
function v_u_8._Init(_) end
return v_u_8