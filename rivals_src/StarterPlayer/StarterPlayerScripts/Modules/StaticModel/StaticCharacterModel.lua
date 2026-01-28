local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.StaticModel)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(p5)
    local v6 = v_u_3.new(v_u_2:GenerateCharacterModel(p5).Template:Clone())
    local v7 = v_u_4
    local v8 = setmetatable(v6, v7)
    v8.UserID = p5
    v8:_Init()
    return v8
end
function v_u_4._SetupCharacterModel(p9)
    local v10 = v_u_2:GenerateCharacterModel(p9.UserID, true)
    if not p9._destroyed and v10 then
        local v_u_11 = v10.Template:Clone()
        v_u_11.HumanoidRootPart.Anchored = true
        v_u_11.PrimaryPart = nil
        v_u_11.WorldPivot = v_u_11.HumanoidRootPart.CFrame * CFrame.new(0, 1.5, 0)
        v_u_11:PivotTo(p9.Model:GetPivot())
        v_u_11:ScaleTo(v_u_11:GetScale() * p9.Model:GetScale() / p9._original_scale)
        v_u_11.Parent = p9.Model.Parent
        task.defer(pcall, function()
            if v_u_11:FindFirstChild("Animate") then
                v_u_11.Animate:Destroy()
            end
            for _, v12 in pairs(v_u_11.Humanoid:GetPlayingAnimationTracks()) do
                v12:Stop()
            end
            local v13 = Instance.new("Animation")
            v13.AnimationId = "rbxassetid://507766388"
            v_u_11.Humanoid:LoadAnimation(v13):Play()
        end)
        p9.Model:Destroy()
        p9.Model = v_u_11
        p9._original_scale = v_u_11:GetScale()
    end
end
function v_u_4._Setup(p14)
    p14.Model.PrimaryPart = p14.Model:FindFirstChild("HumanoidRootPart")
end
function v_u_4._Init(p15)
    p15:_Setup()
    task.spawn(p15._SetupCharacterModel, p15)
end
return v_u_4