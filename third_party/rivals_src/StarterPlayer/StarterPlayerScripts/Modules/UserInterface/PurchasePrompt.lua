local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Lighting")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController"))
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7._new()
    local v8 = v_u_7
    local v9 = setmetatable({}, v8)
    v9.Frame = v_u_6:GetTo("PurchasePrompt")
    v9._started = false
    v9._blur = Instance.new("BlurEffect")
    v9:_Init()
    return v9
end
function v_u_7.Start(p_u_10)
    if not p_u_10._started then
        p_u_10._started = true
        v_u_4:CreateSound("rbxassetid://17900058344", 1, 1, script, true, 10)
        v_u_4:RenderstepForLoop(0, 100, 2, function(p11)
            if not p_u_10._started then
                return true
            end
            local v12 = 1 - (1 - p11 / 100) ^ 4
            p_u_10.Frame.BackgroundTransparency = 1 + -0.5 * v12
            p_u_10._blur.Size = 56 * v12
        end)
    end
end
function v_u_7.Finish(p_u_13, p14)
    local v15 = not p14 or typeof(p14) == "boolean"
    local v16 = "Argument 1 invalid, expected a boolean or nil, got " .. tostring(p14)
    assert(v15, v16)
    if p_u_13._started then
        p_u_13._started = false
        if p14 then
            v_u_4:CreateSound("rbxassetid://7819009374", 1, 1, script, true, 10)
        end
        v_u_4:RenderstepForLoop(0, 100, 2, function(p17)
            if p_u_13._started then
                return true
            end
            local v18 = 1 - (1 - p17 / 100) ^ 4
            p_u_13.Frame.BackgroundTransparency = 0.5 + 0.5 * v18
            p_u_13._blur.Size = 56 * (1 - v18)
        end)
    end
end
function v_u_7._Setup(p19)
    p19._blur.Size = 0
    p19._blur.Name = "PurchasePrompt"
    p19._blur.Parent = v_u_2
end
function v_u_7._Init(p_u_20)
    v_u_5.PurchaseStarted:Connect(function(...)
        p_u_20:Start(...)
    end)
    v_u_5.PurchaseFinished:Connect(function(...)
        p_u_20:Finish(...)
    end)
    p_u_20:_Setup()
end
return v_u_7._new()