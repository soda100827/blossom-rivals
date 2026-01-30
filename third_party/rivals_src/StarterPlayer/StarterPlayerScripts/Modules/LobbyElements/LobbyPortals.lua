local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v2.Modules.CONSTANTS)
local v_u_6 = require(v2.Modules.BetterDebris)
local v_u_7 = require(v2.Modules.Utility)
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_13 = setmetatable({}, v_u_12)
v_u_13.__index = v_u_13
function v_u_13._new(...)
    local v14 = v_u_12.new(...)
    local v15 = v_u_13
    local v16 = setmetatable(v14, v15)
    v16._teleport_cooldown = 0
    v16:_Init()
    return v16
end
function v_u_13._ObjectAdded(p_u_17, p18)
    if not v_u_5.IS_ARCADE_SERVER then
        local v_u_19 = p18:WaitForChild("Camera")
        local v_u_20 = p18:WaitForChild("Entrance")
        local v_u_21 = p18:WaitForChild("Exit")
        v_u_20.Touched:Connect(function(p22)
            if tick() < p_u_17._teleport_cooldown then
                return
            elseif p22.Parent == v_u_4.LocalPlayer.Character then
                if v_u_10.LocalFighter and v_u_10.LocalFighter:IsAlive() then
                    if not v_u_8.CurrentDuelSubject and v_u_8.CurrentSubject == v_u_10.LocalFighter then
                        p_u_17._teleport_cooldown = tick() + 5.3 + 1
                        v_u_7:CreateSound("rbxassetid://86785771664692", 0.5, 1 + 0.1 * math.random(), v_u_20, true, 10)
                        v_u_7:CreateSound("rbxassetid://81610952487049", 1, 1 + 0.1 * math.random(), v_u_21, true, 10)
                        local v23 = v_u_10.LocalFighter.Entity.Humanoid
                        local v_u_24 = v_u_10.LocalFighter.Entity.Model:FindFirstChild("UpperTorso")
                        local v_u_25 = v_u_10.LocalFighter.Entity.RootPart
                        local v26 = v_u_25:FindFirstChild("RootRigAttachment")
                        local v27 = Instance.new("AlignPosition")
                        v27.Position = v_u_21.Position
                        v27.Attachment0 = v26
                        v27.Mode = Enum.PositionAlignmentMode.OneAttachment
                        v27.MaxAxesForce = Vector3.new(1, 0, 1) * (1 / 0)
                        v27.Responsiveness = 20
                        v27.ForceRelativeTo = Enum.ActuatorRelativeTo.World
                        v27.ForceLimitMode = Enum.ForceLimitMode.PerAxis
                        v27.Parent = v_u_25
                        v_u_6:AddItem(v27, 5.3)
                        local v28 = Instance.new("AlignOrientation")
                        v28.Attachment0 = v26
                        v28.Mode = Enum.OrientationAlignmentMode.OneAttachment
                        v28.CFrame = v_u_21.CFrame.Rotation
                        v28.RigidityEnabled = true
                        v28.Parent = v_u_25
                        v_u_6:AddItem(v28, 5.3)
                        local v29 = v_u_21.CFrame
                        local v30 = math.random() - 0.5
                        local v31 = math.random() - 0.5
                        v_u_25.CFrame = v29 + Vector3.new(v30, 0, v31) * v_u_21.Size
                        v23:LoadAnimation(v_u_9:GetPreloadedAnimation("LobbyPortalFalling")):Play(0)
                        v_u_3:BindToRenderStep("LobbyPortalFalling", v_u_11:GetRenderstepPriority() + 1, function(_)
                            workspace.CurrentCamera.FieldOfView = 30
                            workspace.CurrentCamera.CFrame = CFrame.new(v_u_19.Position, (v_u_24 or v_u_25).Position)
                        end)
                        wait(5.3)
                        v_u_3:UnbindFromRenderStep("LobbyPortalFalling")
                    end
                else
                    return
                end
            else
                return
            end
        end)
    end
end
function v_u_13._Init(p_u_32)
    v_u_1:GetInstanceAddedSignal("LobbyPortal"):Connect(function(p33)
        p_u_32:_ObjectAdded(p33)
    end)
    for _, v34 in pairs(v_u_1:GetTagged("LobbyPortal")) do
        task.defer(p_u_32._ObjectAdded, p_u_32, v34)
    end
end
return v_u_13._new()