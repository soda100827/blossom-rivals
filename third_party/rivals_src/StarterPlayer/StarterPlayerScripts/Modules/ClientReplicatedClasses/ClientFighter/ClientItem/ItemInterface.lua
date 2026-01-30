local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.SettingsLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Signal)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
require(v3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_10 = require(v3.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_11 = require(script:WaitForChild("SpeedLines"))
local v_u_12 = require(script:WaitForChild("Cooldowns"))
local v_u_13 = require(script:WaitForChild("Mouse"))
local v_u_14 = require(script:WaitForChild("Other"))
local v_u_15 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ItemInterface")
local v_u_16 = {}
v_u_16.__index = v_u_16
function v_u_16.new(p17)
    local v18 = v_u_16
    local v19 = setmetatable({}, v18)
    v19.ActiveChanged = v_u_6.new()
    v19.ClientItem = p17
    v19.Frame = v_u_15:Clone()
    v19.SpeedLines = v_u_11.new(v19)
    v19.Cooldowns = v_u_12.new(v19)
    v19.Mouse = v_u_13.new(v19)
    v19.Other = v_u_14.new(v19)
    v19._destroyed = false
    v19._connections = {}
    v19._fighter_interface_connections = {}
    v19._is_equipped = false
    v19._original_sizings = {}
    v19:_Init()
    return v19
end
function v_u_16.CooldownEffect(p20, ...)
    return p20.Cooldowns:Create(...)
end
function v_u_16.StopCooldownEffect(p21, ...)
    return p21.Cooldowns:Clear(...)
end
function v_u_16.SetScopeActive(p22, ...)
    return p22.Mouse.Scope:SetActive(...)
end
function v_u_16.IsScopeActive(p23, ...)
    return p23.Mouse.Scope:IsActive(...)
end
function v_u_16.PlaySpeedLines(p24, ...)
    return p24.SpeedLines:Create(...)
end
function v_u_16.DamageEffect(p25, ...)
    return p25.Mouse.Hitmarker:DamageEffect(...)
end
function v_u_16.IsActive(p26)
    local v27 = p26.ClientItem.ClientFighter.FighterInterface
    if v27 then
        v27 = p26.ClientItem.ClientFighter.FighterInterface:IsActive()
    end
    return v27
end
function v_u_16.CreateSound(p28, ...)
    if p28:IsActive() then
        return v_u_5:CreateSound(...)
    end
end
function v_u_16.Equip(p29)
    p29._is_equipped = true
end
function v_u_16.Unequip(p30)
    p30._is_equipped = false
    p30.Mouse.Scope:SetActive(false)
end
function v_u_16.Update(p31, p32, p33, p34)
    if p33.IsSpectating and (not p33.IsHiddenByCutscene and p34.IsActive) then
        p31.Other:Update(p32, p33, p34)
        p31.Mouse:Update(p32, p33, p34)
        p31.Frame.Visible = true
    else
        p31.Frame.Visible = false
    end
end
function v_u_16.Destroy(p35)
    p35._destroyed = true
    for _, v36 in pairs(p35._connections) do
        v36:Disconnect()
    end
    for _, v37 in pairs(p35._fighter_interface_connections) do
        v37:Disconnect()
    end
    p35._connections = {}
    p35._fighter_interface_connections = {}
    p35.ActiveChanged:Destroy()
    p35.SpeedLines:Destroy()
    p35.Cooldowns:Destroy()
    p35.Mouse:Destroy()
    p35.Other:Destroy()
    p35.Frame:Destroy()
end
function v_u_16._UpdateSizing(p38)
    local v39 = v_u_10.MainGui.AbsoluteSize.X / p38.Frame.AbsoluteSize.X
    local v40 = v_u_10.MainGui.AbsoluteSize.Y / p38.Frame.AbsoluteSize.Y
    for _, v41 in pairs({ "AimingVignette", "SpeedLinesThick", "SpeedLinesThin" }) do
        local v42 = p38.Frame[v41]
        p38._original_sizings[v42] = p38._original_sizings[v42] or {
            ["Position"] = v42.Position,
            ["Size"] = v42.Size
        }
        v42.Size = UDim2.new(p38._original_sizings[v42].Size.X.Scale * v39, p38._original_sizings[v42].Size.X.Offset * v39, p38._original_sizings[v42].Size.Y.Scale * v40, p38._original_sizings[v42].Size.Y.Offset * v40)
        v42.Position = UDim2.new(0.5 + (p38._original_sizings[v42].Position.X.Scale - 0.5) * v39, 0, 0.5 + (p38._original_sizings[v42].Position.Y.Scale - 0.5) * v40, 0)
    end
end
function v_u_16._UpdateVisibility(p43)
    local v44 = not v_u_9.PageSystem.CurrentPage
    p43.Mouse:SetVisible(v44)
end
function v_u_16._FighterInterfaceRemoved(p45)
    for _, v46 in pairs(p45._fighter_interface_connections) do
        v46:Disconnect()
    end
    p45._fighter_interface_connections = {}
end
function v_u_16._FighterInterfaceAdded(p_u_47, p48)
    p_u_47:_FighterInterfaceRemoved()
    local v49 = p_u_47._fighter_interface_connections
    local v50 = p48.ActiveChanged
    table.insert(v49, v50:Connect(function()
        p_u_47.ActiveChanged:Fire()
    end))
    p_u_47.ActiveChanged:Fire()
end
function v_u_16._Setup(p51)
    p51.Frame.Visible = false
    p51.Frame.Name = p51.ClientItem.ClientFighter.Player.Name .. " - " .. p51.ClientItem.Name
    p51.Frame.Parent = v_u_10:GetTo("MainFrame", "ItemInterfaces")
end
function v_u_16._Init(p_u_52)
    p_u_52.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_52:_UpdateSizing()
    end)
    local v53 = p_u_52._connections
    local v54 = p_u_52.ClientItem.ClientFighter.InterfaceAdded
    table.insert(v53, v54:Connect(function(p55)
        p_u_52:_FighterInterfaceAdded(p55)
    end))
    local v56 = p_u_52._connections
    local v57 = p_u_52.ClientItem.ClientFighter.InterfaceRemoved
    table.insert(v56, v57:Connect(function()
        p_u_52:_FighterInterfaceRemoved()
    end))
    local v58 = p_u_52._connections
    local v59 = v_u_2:GetPropertyChangedSignal("MouseIconEnabled")
    table.insert(v58, v59:Connect(function()
        p_u_52.Mouse:Refresh()
    end))
    local v60 = p_u_52._connections
    local v61 = v_u_2:GetPropertyChangedSignal("MouseBehavior")
    table.insert(v60, v61:Connect(function()
        p_u_52.Mouse:Refresh()
    end))
    local v62 = p_u_52._connections
    local v63 = v_u_8.POVStateChanged
    table.insert(v62, v63:Connect(function()
        p_u_52.Mouse:Refresh()
    end))
    local v64 = p_u_52._connections
    local v65 = v_u_9.PageSystem.PageOpened
    table.insert(v64, v65:Connect(function()
        p_u_52:_UpdateVisibility()
    end))
    local v66 = p_u_52._connections
    local v67 = v_u_9.PageSystem.PageClosed
    table.insert(v66, v67:Connect(function()
        p_u_52:_UpdateVisibility()
    end))
    if p_u_52.ClientItem.ClientFighter.IsLocalPlayer then
        for v68, v69 in pairs(v_u_4.Info) do
            if v69.Section == "Crosshair" then
                local v70 = p_u_52._connections
                local v71 = v_u_7:GetDataChangedSignal(v68)
                table.insert(v70, v71:Connect(function()
                    p_u_52.Mouse.MouseCrosshair:Refresh()
                end))
            end
        end
    else
        local v72 = p_u_52._connections
        local v73 = p_u_52.ClientItem.ClientFighter:GetDataChangedSignal("CompressedCrosshairAppearance")
        table.insert(v72, v73:Connect(function()
            p_u_52.Mouse.MouseCrosshair:Refresh()
        end))
    end
    if p_u_52.ClientItem.ClientFighter.FighterInterface then
        task.defer(p_u_52._FighterInterfaceAdded, p_u_52, p_u_52.ClientItem.ClientFighter.FighterInterface)
    end
    p_u_52:_Setup()
    p_u_52:_UpdateSizing()
    p_u_52:_UpdateVisibility()
    p_u_52.Mouse.MouseCrosshair:Refresh()
    p_u_52.Mouse:Refresh()
    p_u_52:Unequip()
end
return v_u_16