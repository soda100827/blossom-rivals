local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.WrapController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels:WaitForChild("Sniper"))
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_6.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10.BulletTrail = v10.ItemModel:WaitForChild("Bullet"):WaitForChild("MeshPart"):WaitForChild("TrailA0"):WaitForChild("Trail")
    v10:_Init()
    return v10
end
function v_u_7.CustomTracers(p_u_11, p_u_12, _)
    local v_u_13 = p_u_11:GetWrap()
    local function v_u_28()
        local v14 = p_u_11:GetMuzzlePosition()
        if v14 then
            local v15 = v14 + workspace.CurrentCamera.CFrame.RightVector * 0.1
            for _, v_u_16 in pairs(p_u_12.RaycastResults) do
                local v_u_17 = v_u_16.StartPosition or v15
                local v_u_18 = (v_u_17 - v_u_16.Position).Magnitude
                local v_u_19 = Instance.new("Part")
                v_u_19.CastShadow = false
                v_u_19.CanCollide = false
                v_u_19.CanTouch = false
                v_u_19.CanQuery = false
                v_u_19.Anchored = true
                v_u_19.Color = Color3.fromRGB(255, 176, 112)
                v_u_19:SetAttribute("IgnoreTransparency", true)
                v_u_19:AddTag("Wrappable")
                v_u_19:SetAttribute("WrapGroup", 3)
                v_u_19.Parent = workspace
                v_u_3:AddItem(v_u_19, 10)
                v_u_5:ApplyWrap(v_u_5:RecordOriginalWrapProperties(v_u_19), v_u_13)
                v_u_19.Material = Enum.Material.Neon
                v_u_19.MaterialVariant = ""
                task.spawn(function()
                    v_u_4:RenderstepForLoop(0, 100, 2, function(p20)
                        local v21 = p20 / 100
                        local v22 = (1 - v21) ^ 4
                        local v23 = 1 - v21 ^ 4
                        local v24 = v_u_19
                        local v25 = 0.01 + 1 * v22
                        local v26 = 0.01 + 1 * v22
                        local v27 = v_u_18 * v23 - 5
                        v24.Size = Vector3.new(v25, v26, v27)
                        v_u_19.CFrame = CFrame.new(v_u_16.Position, v_u_17) * CFrame.new(0, 0, -v_u_19.Size.Z / 2)
                    end)
                    v_u_19:Destroy()
                end)
            end
        end
    end
    if p_u_11.ClientItem:Get("IsAiming") then
        p_u_11.ClientItem:GetDataChangedSignal("IsAiming"):ConnectOnce(function()
            task.delay(0.06, task.defer, v_u_28)
        end)
    else
        v_u_28()
    end
end
function v_u_7._UpdateBulletTrail(p29)
    p29.BulletTrail.Enabled = p29:IsAnimationPlaying("Shoot1") or p29:IsAnimationPlaying("EmptyReload")
end
function v_u_7._Init(p_u_30)
    p_u_30.AnimationPlayed:Connect(function(p31)
        if p31 == "Shoot1" or p31 == "EmptyReload" then
            p_u_30:_UpdateBulletTrail()
        end
    end)
    p_u_30.AnimationStopped:Connect(function(p32)
        if p32 == "Shoot1" or p32 == "EmptyReload" then
            p_u_30:_UpdateBulletTrail()
        end
    end)
    p_u_30:_UpdateBulletTrail()
end
return v_u_7