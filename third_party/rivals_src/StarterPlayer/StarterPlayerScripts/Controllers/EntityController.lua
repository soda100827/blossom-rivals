local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
require(v1.Modules.GameplayUtility)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.EnemyController)
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7._new()
    local v8 = v_u_7
    local v9 = setmetatable({}, v8)
    v9:_Init()
    return v9
end
function v_u_7.GetScreenPoints(_, p10, p11)
    local v12 = {}
    for _, v13 in pairs({ v_u_6.Objects, v_u_5:GetEntities() }) do
        for _, v14 in pairs(v13) do
            if not (p11 and v14.AimAssistBlacklist) and p10:IsValidTarget(v14) then
                local v15, v16 = v14:GetScreenPoint()
                if v16 and v15.Z < v_u_3.RENDER_DISTANCE then
                    v12[v14] = v15
                end
            end
        end
    end
    return v12
end
function v_u_7._SetupHurtEffect(_, p_u_17)
    local v18
    if typeof(p_u_17) == "Instance" then
        v18 = p_u_17:IsA("Model")
    else
        v18 = false
    end
    assert(v18, "Argument 1 invalid, expected a Model")
    p_u_17:SetAttribute("PlayHurtEffect", 0)
    local v_u_19 = nil
    p_u_17:GetAttributeChangedSignal("PlayHurtEffect"):Connect(function()
        if v_u_19 then
            v_u_19:Destroy()
            v_u_19 = nil
        end
        local v_u_20 = Instance.new("Highlight")
        v_u_20.Name = "HurtEffect"
        v_u_20.FillColor = Color3.fromRGB(255, 255, 255)
        v_u_20.OutlineColor = Color3.fromRGB(255, 100, 100)
        v_u_20.DepthMode = Enum.HighlightDepthMode.Occluded
        v_u_20.Adornee = p_u_17
        v_u_20.Parent = p_u_17
        v_u_19 = v_u_20
        v_u_4:RenderstepForLoop(0, 100, 1, function(p21)
            if v_u_20 ~= v_u_19 then
                return true
            end
            local v22 = 1 - (1 - p21 / 100) ^ 5
            local v23 = v_u_20
            local v24 = Color3.fromRGB(255, 255, 255)
            local v25 = Color3.fromRGB(255, 50, 50)
            local v26 = p21 / 5
            v23.FillColor = v24:Lerp(v25, (math.min(1, v26)))
            v_u_20.FillTransparency = v22
            v_u_20.OutlineTransparency = v22
        end)
        v_u_20:Destroy()
    end)
end
function v_u_7._SetupHurtEffects(p27)
    local v28 = Instance.new("Model")
    v28.Name = "HurtEffect"
    v28.Parent = workspace
    p27:_SetupHurtEffect(v28)
    p27:_SetupHurtEffect(workspace:WaitForChild("ViewModels"):WaitForChild("FirstPerson"))
end
function v_u_7._Init(p29)
    task.spawn(p29._SetupHurtEffects, p29)
end
return v_u_7._new()