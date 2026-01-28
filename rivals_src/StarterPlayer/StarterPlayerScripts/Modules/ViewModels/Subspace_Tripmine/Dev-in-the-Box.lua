local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.WrapController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels["Subspace Tripmine"])
local v_u_7 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("DevintheBoxExplosionEffect")
local v_u_8 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("Dev-in-the-Box")
local v_u_9 = setmetatable({}, v_u_6)
v_u_9.__index = v_u_9
function v_u_9.new(...)
    local v10 = v_u_6.new(...)
    local v11 = v_u_9
    local v12 = setmetatable(v10, v11)
    v12:_Init()
    return v12
end
function v_u_9.ExplosionEffect(p13, p14)
    local v15 = p14:FuzzyEq(workspace.CurrentCamera.CFrame.Position) and CFrame.new(p14)
    if not v15 then
        local v16 = CFrame.new
        local v17 = workspace.CurrentCamera.CFrame.X
        local v18 = p14.Y
        local v19 = workspace.CurrentCamera.CFrame.Z
        v15 = v16(p14, (Vector3.new(v17, v18, v19)))
    end
    local v20 = math.random() < 0.5
    local v_u_21 = v_u_8:Clone()
    v_u_21.Dev.SenseiWarrior.Transparency = v20 and 0 or 1
    v_u_21.Dev.Nosniy.Transparency = v20 and 1 or 0
    v_u_21:PivotTo(v15 + Vector3.new(0, 0.5, 0))
    v_u_21.Parent = workspace
    v_u_3:AddItem(v_u_21, 4)
    v_u_5:ApplyWrap(v_u_5:RecordOriginalWrapProperties(v_u_21), p13.ClientItem:GetWrap(), true)
    v_u_4:CreateSound("rbxassetid://86639533276627", 0.875, 1 + 0.1 * math.random(), p14, true, 10)
    v_u_4:CreateSound("rbxassetid://121003602924254", 1.25, 1 + 0.1 * math.random(), p14, true, 10)
    local v22 = v_u_7:Clone()
    v22.CFrame = CFrame.new(p14)
    v22.Parent = workspace
    v_u_3:AddItem(v22, 5)
    v_u_4:PlayParticles(v22)
    pcall(function()
        task.delay(3, function()
            v_u_21.Primary.Anchored = false
        end)
        v_u_21.AnimationController:LoadAnimation(v_u_21.Animation):Play()
        wait(0.1)
        v_u_21.top.Lid.Delete:Destroy()
        v_u_21.top.Lid.Velocity = (Random.new():NextUnitVector() * Vector3.new(1, 0, 1) + Vector3.new(0, 4, 0)) * (15 + 25 * math.random())
        v_u_21.top.Lid.RotVelocity = CFrame.Angles(math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2).LookVector * (10 + 10 * math.random())
    end)
end
function v_u_9._Init(_) end
return v_u_9