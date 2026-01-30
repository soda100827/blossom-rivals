local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("TweenService")
game:GetService("GuiService")
local v4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.CONSTANTS)
local v_u_6 = require(v1.Modules.BetterDebris)
local v_u_7 = require(v1.Modules.Spring)
require(v1.Modules.Signal)
require(v4.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_8 = require(v4.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_9 = require(v4.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_10 = require(script:WaitForChild("MouseCrosshair"))
local v_u_11 = require(script:WaitForChild("Hitmarker"))
local v_u_12 = require(script:WaitForChild("Scope"))
local v_u_13 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MouseCooldownSlot")
local v_u_14 = {}
v_u_14.__index = v_u_14
function v_u_14.new(p15)
    local v16 = v_u_14
    local v17 = setmetatable({}, v16)
    v17.ItemInterface = p15
    v17.Frame = v17.ItemInterface.Frame:WaitForChild("Mouse")
    v17.CooldownsFrame = v17.Frame:WaitForChild("Cooldowns")
    v17.HitmarkerFrame = v17.Frame:WaitForChild("Hitmarker")
    v17.MouseCrosshair = v_u_10.new(v17)
    v17.Hitmarker = v_u_11.new(v17)
    v17.Scope = v_u_12.new(v17)
    v17._slide_spring = v_u_7.new(0, 0.875, 20)
    v17:_Init()
    return v17
end
function v_u_14.SetVisible(p18, p19)
    p18.Frame.Visible = p19
end
function v_u_14.CooldownEffect(p20, p21, p22, _, p23)
    local v24 = p23 and 0 or 1
    local v25 = p23 and 1 or 0
    local v26 = v_u_13:Clone()
    v26.Icon.Image = p21
    v26.Icon.Container.Icon.Image = p21
    v26.Icon.Container.Size = UDim2.new(v24, 0, 1, 0)
    v26.Bar.Bar.Size = UDim2.new(v24, 0, 1.5, 0)
    v26.Parent = p20.CooldownsFrame
    v_u_6:AddItem(v26, p22)
    v_u_3:Create(v26.Icon.Container, TweenInfo.new(p22, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
        ["Size"] = UDim2.new(v25, 0, 1, 0)
    }):Play()
    v_u_3:Create(v26.Bar.Bar, TweenInfo.new(p22, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
        ["Size"] = UDim2.new(v25, 0, 1.5, 0)
    }):Play()
    return v26
end
function v_u_14.Refresh(p27)
    local v28 = v_u_2.MouseIconEnabled
    if v28 then
        v28 = v_u_8:GetPublicState() == v_u_8.CameraState.States.ThirdPersonUnlockedMouse
    end
    local v29 = p27.MouseCrosshair.Crosshair
    local v30
    if v_u_5.DEVICE == "VR" then
        v30 = false
    else
        v30 = not v28
    end
    v29:SetVisible(v30)
    p27.CooldownsFrame.Visible = v_u_5.DEVICE ~= "VR"
    p27.HitmarkerFrame.Visible = v_u_5.DEVICE ~= "VR"
    p27.Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
end
function v_u_14.Update(p31, p32, p33, p34)
    if p33.IsSpectating then
        p31._slide_spring.Target = p33.IsSliding and (p33.IsFirstPerson and not p31.MouseCrosshair.Crosshair:IsStatic()) and 1 or 0
        p31._slide_spring.Value = p31._slide_spring.Target > p31._slide_spring.Value and p31._slide_spring.Target or p31._slide_spring.Value
        local v35 = p31._slide_spring.Value
        local v36 = UDim2.new()
        local v37 = v_u_8.ViewModelOffsetCFrame * v_u_8.ShakeCFrame
        if p33.IsFirstPerson and (v37 ~= CFrame.identity and not p31.MouseCrosshair.Crosshair:IsStatic()) then
            local v38 = workspace.CurrentCamera.CFrame * v37:Inverse() * CFrame.new(0, 0, -100)
            local v39 = workspace.CurrentCamera:WorldToScreenPoint(v38.Position)
            v36 = UDim2.new(0, v39.X - p33.MouseLocation.X, 0, v39.Y - p33.MouseLocation.Y)
        end
        local v40 = v_u_9:ScreenPointToPosition(p33.MouseLocation, p31.ItemInterface.Frame.AbsolutePosition)
        p31.Frame.Position = UDim2.new(0, v40.X, 0, v40.Y) + v36
        local v41 = p31.Frame
        local v42 = v35 * 20 + 0.5
        v41.Rotation = math.floor(v42)
        p31.MouseCrosshair:Update(p32, p33, p34)
        p31.Hitmarker:Update(p32, p33, p34)
        p31.Scope:Update(p32, p33, p34)
    end
end
function v_u_14.Destroy(p43)
    p43.MouseCrosshair:Destroy()
    p43.Hitmarker:Destroy()
    p43.Scope:Destroy()
end
function v_u_14._Init(p_u_44)
    p_u_44.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_44:Refresh()
    end)
end
return v_u_14