local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.DuelLibrary)
local v_u_5 = require(v1.Modules.ItemLibrary)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface.Inset)
local v_u_8 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EliminationFeedSlot")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_9
    local v12 = setmetatable({}, v11)
    v12.DuelInterface = p10
    v12.Frame = v12.DuelInterface.Frame:WaitForChild("EliminationFeed")
    v12.List = v12.Frame:WaitForChild("List")
    v12._destroyed = false
    v12._connections = {}
    v12:_Init()
    return v12
end
function v_u_9.PlayRaw(p_u_13, p14)
    local v_u_15 = p14 or {}
    v_u_15.State = v_u_15.State or "Default"
    v_u_15.VictimText = v_u_15.VictimText or "???"
    v_u_15.VictimTeamColor = v_u_15.VictimTeamColor or v_u_4.EMPTY_TEAM_COLOR
    v_u_15.EliminatorText = v_u_15.EliminatorText or "???"
    v_u_15.EliminatorTeamColor = v_u_15.EliminatorTeamColor or v_u_4.EMPTY_TEAM_COLOR
    v_u_15.ViewModelName = v_u_15.ViewModelName or nil
    v_u_15.IsCritical = v_u_15.IsCritical or false
    v_u_15.IsBlinded = v_u_15.IsBlinded or false
    v_u_15.IsNoscope = v_u_15.IsNoscope or false
    local v16 = v_u_15.ViewModelName
    if v16 then
        v16 = v_u_5.ViewModels[v_u_15.ViewModelName]
    end
    local v17 = v16 and (v16.EliminationFeedImage or "rbxassetid://91284037292220") or "rbxassetid://91284037292220"
    local v18 = v16 and v16.EliminationFeedImageScale or 1.5
    local v_u_19 = v_u_8:Clone()
    v_u_19.Container.Container.Eliminator.TextLabel.Text = v_u_15.EliminatorText or ""
    v_u_19.Container.Container.Eliminator.Visible = v_u_19.Container.Container.Eliminator.TextLabel.Text ~= ""
    v_u_19.Container.Container.Victim.TextLabel.Text = v_u_15.VictimText or "???"
    v_u_19.Container.Container.Weapon.ImageLabel.Image = v17
    v_u_19.Container.Container.Weapon.Size = UDim2.new(v18, 0, 1, 0)
    v_u_19.Container.Container.Critical.Visible = v_u_15.IsCritical
    v_u_19.Container.Container.Blinded.Visible = v_u_15.IsBlinded
    v_u_19.Container.Container.Noscope.Visible = v_u_15.IsNoscope
    v_u_19.Container.Background.Outline.Visible = v_u_15.State == "LocalElimination"
    v_u_19.Container.Background.Background.ImageColor3 = v_u_15.State == "LocalDeath" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    v_u_19.Parent = p_u_13.List
    v_u_3:AddItem(v_u_19, 10)
    local v_u_20 = v_u_19.Container.Container.Weapon.ImageLabel
    local v_u_21 = false
    local function v24()
        if p_u_13._destroyed then
            return
        elseif not v_u_21 then
            v_u_21 = true
            task.defer(function()
                if not p_u_13._destroyed then
                    v_u_21 = false
                    v_u_19.Container.Container.Eliminator.Size = UDim2.new(0, v_u_19.Container.Container.Eliminator.TextLabel.TextBounds.X, 0.625, 0)
                    v_u_19.Container.Container.Victim.Size = UDim2.new(0, v_u_19.Container.Container.Victim.TextLabel.TextBounds.X, 0.625, 0)
                    v_u_19.Size = UDim2.new(0, v_u_19.Container.Container.Layout.AbsoluteContentSize.X, v_u_19.Size.Y.Scale, 0)
                    local v22 = (v_u_20.AbsolutePosition.X + v_u_20.AbsoluteSize.X / 2 - v_u_19.AbsolutePosition.X) / v_u_19.AbsoluteSize.X
                    local v23 = math.clamp(v22, 0.001, 0.999)
                    v_u_19.Container.Background.Background.UIGradient.Color = v_u_15.State == "LocalDeath" and ColorSequence.new(Color3.fromRGB(255, 255, 255)) or ColorSequence.new({ ColorSequenceKeypoint.new(0, v_u_15.EliminatorTeamColor), ColorSequenceKeypoint.new(v23, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, v_u_15.VictimTeamColor) })
                    v_u_19.Container.Background.Background.UIGradient.Transparency = v_u_15.State == "LocalDeath" and NumberSequence.new(0) or NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(v23, 0.25), NumberSequenceKeypoint.new(1, 0) })
                end
            end)
        end
    end
    v_u_19:GetPropertyChangedSignal("AbsoluteSize"):Connect(v24)
    v_u_20:GetPropertyChangedSignal("AbsolutePosition"):Connect(v24)
    v_u_20:GetPropertyChangedSignal("AbsoluteSize"):Connect(v24)
    v_u_19.Container.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(v24)
    v_u_19.Container.Container.Eliminator.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(v24)
    v_u_19.Container.Container.Victim.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(v24)
    if not (p_u_13._destroyed or v_u_21) then
        v_u_21 = true
        task.defer(function()
            if not p_u_13._destroyed then
                v_u_21 = false
                v_u_19.Container.Container.Eliminator.Size = UDim2.new(0, v_u_19.Container.Container.Eliminator.TextLabel.TextBounds.X, 0.625, 0)
                v_u_19.Container.Container.Victim.Size = UDim2.new(0, v_u_19.Container.Container.Victim.TextLabel.TextBounds.X, 0.625, 0)
                v_u_19.Size = UDim2.new(0, v_u_19.Container.Container.Layout.AbsoluteContentSize.X, v_u_19.Size.Y.Scale, 0)
                local v25 = (v_u_20.AbsolutePosition.X + v_u_20.AbsoluteSize.X / 2 - v_u_19.AbsolutePosition.X) / v_u_19.AbsoluteSize.X
                local v26 = math.clamp(v25, 0.001, 0.999)
                v_u_19.Container.Background.Background.UIGradient.Color = v_u_15.State == "LocalDeath" and ColorSequence.new(Color3.fromRGB(255, 255, 255)) or ColorSequence.new({ ColorSequenceKeypoint.new(0, v_u_15.EliminatorTeamColor), ColorSequenceKeypoint.new(v26, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, v_u_15.VictimTeamColor) })
                v_u_19.Container.Background.Background.UIGradient.Transparency = v_u_15.State == "LocalDeath" and NumberSequence.new(0) or NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(v26, 0.25), NumberSequenceKeypoint.new(1, 0) })
            end
        end)
    end
    if v_u_19:IsDescendantOf(v_u_2.LocalPlayer) then
        v_u_19.Container.Position = UDim2.new(1, 20, 0, 0)
        v_u_19.Container:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quint", 0.25, true)
    end
    task.delay(7, pcall, v_u_19.Container.TweenPosition, v_u_19.Container, UDim2.new(1, 20, 0, 0), "In", "Quint", 0.25, true, function()
        if not p_u_13._destroyed then
            v_u_19:TweenSize(UDim2.new(), "Out", "Quint", 0.25, true, function()
                if not p_u_13._destroyed then
                    v_u_19:Destroy()
                end
            end)
        end
    end)
end
function v_u_9.Play(p27, p28, p29, p30, p31, p32, p33, p34)
    local v35 = {
        ["State"] = p28 == v_u_2.LocalPlayer and "LocalDeath" or ((p29 == v_u_2.LocalPlayer or p30 == v_u_2.LocalPlayer) and "LocalElimination" or "Default")
    }
    local v36
    if p28 then
        v36 = v_u_6:GetName(p28)
    else
        v36 = p28
    end
    v35.VictimText = v36
    v35.VictimTeamColor = v_u_4:GetTeamColor(p28:GetAttribute("TeamID"))
    v35.EliminatorText = (p29 and p29 ~= p28 and (v_u_6:GetName(p29) or "") or "") .. (p30 and (p30 ~= p29 and p30 ~= p28) and (" + " .. v_u_6:GetName(p30) or "") or "")
    v35.EliminatorTeamColor = v_u_4:GetTeamColor(p29:GetAttribute("TeamID"))
    v35.ViewModelName = p31
    v35.IsCritical = p32
    v35.IsBlinded = p33
    v35.IsNoscope = p34
    p27:PlayRaw(v35)
end
function v_u_9.Update(p37)
    local v38 = p37.Frame
    local v39 = not p37.DuelInterface:IsPageOpen()
    if v39 then
        v39 = not p37.DuelInterface.FinalResults:IsActive()
    end
    v38.Visible = v39
end
function v_u_9.UpdatePosition(p40)
    p40.Frame.Position = UDim2.new(1, 0, 0, v_u_7.MainFrame.AbsoluteSize.Y)
end
function v_u_9.Destroy(p41)
    p41._destroyed = true
    for _, v42 in pairs(p41._connections) do
        v42:Disconnect()
    end
    p41._connections = {}
end
function v_u_9._Debug(_) end
function v_u_9._UpdatePosition(_) end
function v_u_9._Init(p_u_43)
    p_u_43.DuelInterface.FinalResults.Activated:Connect(function()
        p_u_43:Update()
    end)
    p_u_43:UpdatePosition()
    task.defer(p_u_43._Debug, p_u_43)
end
return v_u_9