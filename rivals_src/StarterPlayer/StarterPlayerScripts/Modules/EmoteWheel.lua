local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GamepadService")
local v_u_4 = game:GetService("RunService")
local v5 = game:GetService("Players")
local v_u_6 = require(v1.Modules.CONSTANTS)
local v_u_7 = require(v1.Modules.Signal)
local v_u_8 = require(v5.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v5.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_10 = require(v5.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_11 = require(script:WaitForChild("EmoteWheelSlot"))
local v_u_12 = v5.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EmoteWheel")
local v_u_13 = 6.283185307179586 / v_u_6.MAX_EQUIPPABLE_EMOTES
local v_u_14 = v_u_13 * -0.5
local v_u_15 = {}
v_u_15.__index = v_u_15
function v_u_15.new()
    local v16 = v_u_15
    local v17 = setmetatable({}, v16)
    v17.EmoteKeyPicked = v_u_7.new()
    v17.EmoteWheelSlotHighlighted = v_u_7.new()
    v17.Frame = v_u_12:Clone()
    v17._is_enabled = false
    v17._connections = {}
    v17._input_connections = {}
    v17._emote_wheel_slots = {}
    v17._finish_picking_bindable = nil
    v17._last_highlighted_wheel_slot = nil
    v17._generate_hash = 0
    v17:_Init()
    return v17
end
function v_u_15.GetLastHighlightedSlot(p18)
    return p18._last_highlighted_wheel_slot
end
function v_u_15.GetEmoteWheelSlot(p19, p20)
    return p19._emote_wheel_slots[p20]
end
function v_u_15.GetEmoteSlotFromScreenPosition(p21, p22, p23)
    local v24 = p22 or v_u_10:GetMouseLocation()
    local v25 = p21.Frame.AbsolutePosition + p21.Frame.AbsoluteSize / 2
    if (v24 - v25).Magnitude > p21.Frame.AbsoluteSize.X * 0.1 then
        local v26 = v24.Y - v25.Y
        local v27 = v24.X - v25.X
        local v28 = math.atan2(v26, v27) + 1.5707963267948966
        local v29 = { v28 - 6.283185307179586, v28, v28 + 6.283185307179586 }
        for v30, v31 in pairs(p21._emote_wheel_slots) do
            if v31.EquippedData or p23 then
                for _, v32 in pairs(v29) do
                    local v33 = tonumber(v30)
                    local v34 = v_u_13 * (v33 - 1) + v_u_14
                    local v35 = v_u_13 * v33 + v_u_14
                    if v34 <= v32 and v32 < v35 then
                        return v31, v30
                    end
                end
            end
        end
    end
end
function v_u_15.SetEnabled(p_u_36, p37)
    p_u_36:_Clear()
    p_u_36._is_enabled = p37
    if p_u_36._is_enabled then
        local v38 = p_u_36._connections
        local v39 = v_u_8:GetDataChangedSignal("EquippedEmotes")
        table.insert(v38, v39:Connect(function()
            p_u_36:_Generate()
        end))
        task.spawn(p_u_36._Generate, p_u_36, true)
    end
end
function v_u_15.HighlightSlot(p40, p41)
    p40._last_highlighted_wheel_slot = p41
    for _, v42 in pairs(p40._emote_wheel_slots) do
        v42:SetHighlighted(v42 == p40._last_highlighted_wheel_slot)
    end
    p40.EmoteWheelSlotHighlighted:Fire()
end
function v_u_15.StopInputs(p43)
    for _, v44 in pairs(p43._input_connections) do
        v44:Disconnect()
    end
    p43._input_connections = {}
    if p43._finish_picking_bindable then
        p43._finish_picking_bindable:Destroy()
        p43._finish_picking_bindable = nil
    end
    p43:HighlightSlot(nil)
end
function v_u_15.FinishInputs(p45)
    if p45._finish_picking_bindable then
        p45._finish_picking_bindable:Fire()
    end
end
function v_u_15.StartInputs(p_u_46, p_u_47)
    p_u_46:StopInputs()
    p_u_46._finish_picking_bindable = Instance.new("BindableEvent")
    local v_u_48 = nil
    local v_u_49 = false
    local function v53()
        local v51, v51 = p_u_46:GetEmoteSlotFromScreenPosition(v_u_48, p_u_47)
        if v51 then
            if not p_u_47 then
                local v52 = v51.EquippedData
                if not v52 then
                    v51 = v52
                end
            end
        end
        p_u_46.EmoteKeyPicked:Fire(v51)
    end
    p_u_46._finish_picking_bindable.Event:Connect(v53)
    local v54 = p_u_46._input_connections
    local v55 = v_u_2.InputBegan
    local function v57(p56)
        if p56.UserInputType == Enum.UserInputType.MouseButton1 or (p56.UserInputType == Enum.UserInputType.Touch or p56.KeyCode == Enum.KeyCode.ButtonA) then
            v_u_49 = true
        end
    end
    table.insert(v54, v55:Connect(v57))
    local v58 = p_u_46._input_connections
    local v59 = v_u_2.InputEnded
    local function v64(p60)
        if (p60.UserInputType == Enum.UserInputType.MouseButton1 or (p60.UserInputType == Enum.UserInputType.Touch or p60.KeyCode == Enum.KeyCode.ButtonA)) and v_u_49 then
            local v62, v62 = p_u_46:GetEmoteSlotFromScreenPosition(v_u_48, p_u_47)
            if v62 then
                if not p_u_47 then
                    local v63 = v62.EquippedData
                    if not v63 then
                        v62 = v63
                    end
                end
            end
            p_u_46.EmoteKeyPicked:Fire(v62)
        end
    end
    table.insert(v58, v59:Connect(v64))
    local v65 = p_u_46._input_connections
    local v66 = v_u_2.InputChanged
    local function v70(p67)
        if v_u_9.CurrentControls == "Gamepad" then
            if p67.KeyCode == Enum.KeyCode.Thumbstick1 or p67.KeyCode == Enum.KeyCode.Thumbstick2 then
                local v68 = p_u_46:_ThumbstickPositionToScreenPosition(p67.Position)
                local v69, _ = p_u_46:GetEmoteSlotFromScreenPosition(v68, p_u_47)
                if not v69 then
                    return
                end
                v_u_48 = v68
                p_u_46:HighlightSlot(v69)
            end
        end
    end
    table.insert(v65, v66:Connect(v70))
    local v71 = p_u_46._input_connections
    local v72 = v_u_4.RenderStepped
    local function v76()
        if v_u_9.CurrentControls == "Gamepad" then
            if v_u_3.GamepadCursorEnabled then
                v_u_3:DisableGamepadCursor()
            end
            return
        else
            local v73, v74 = v_u_10:GetMouseLocation()
            local v75, _ = p_u_46:GetEmoteSlotFromScreenPosition(v73, p_u_47)
            if v75 or not v74 then
                v_u_48 = v73
                p_u_46:HighlightSlot(v75)
            end
        end
    end
    table.insert(v71, v72:Connect(v76))
end
function v_u_15.Destroy(p77)
    p77:_Clear()
    p77:SetEnabled(false)
    p77:StopInputs()
    p77.Frame:Destroy()
    p77.EmoteKeyPicked:Destroy()
    p77.EmoteWheelSlotHighlighted:Destroy()
end
function v_u_15._NormalizeAngle(_, p78)
    if p78 < 0 then
        return p78 + 6.283185307179586
    end
    if p78 > 6.283185307179586 then
        p78 = p78 - 6.283185307179586
    end
    return p78
end
function v_u_15._ThumbstickPositionToScreenPosition(p79, p80)
    local v81 = p79.Frame.AbsolutePosition + p79.Frame.AbsoluteSize / 2
    if p80.Magnitude <= 0.5 then
        return v81
    else
        return v81 + Vector2.new(p80.X, -p80.Y) * 1000
    end
end
function v_u_15._ClearSlots(p82)
    for _, v83 in pairs(p82._emote_wheel_slots) do
        v83:Destroy()
    end
    p82._emote_wheel_slots = {}
end
function v_u_15._Clear(p84)
    for _, v85 in pairs(p84._connections) do
        v85:Disconnect()
    end
    p84._connections = {}
    p84:_ClearSlots()
end
function v_u_15._Generate(p86, p87)
    p86._generate_hash = p86._generate_hash + 1
    local v88 = p86._generate_hash
    local v89 = {}
    for v90, v91 in pairs(p86._emote_wheel_slots) do
        v89[v90] = v91.EquippedData and v91.EquippedData.Name or nil
    end
    p86:_ClearSlots()
    local v92 = v_u_8:Get("EquippedEmotes")
    local v93 = 360 / v_u_6.MAX_EQUIPPABLE_EMOTES
    for v94 = 1, v_u_6.MAX_EQUIPPABLE_EMOTES do
        if v88 ~= p86._generate_hash then
            return
        end
        local v95 = tostring(v94)
        local v96 = v_u_11.new(v92[v95])
        local v97 = v_u_14
        v96:SetRotation(v93 * 0.5 + (v94 - 1) * v93 + math.deg(v97))
        v96.Frame.Parent = p86.Frame.Slots
        p86._emote_wheel_slots[v95] = v96
        if not p87 then
            local v98 = v89[v95]
            local v99
            if v96.EquippedData then
                v99 = v96.EquippedData.Name or nil
            else
                v99 = nil
            end
            if v98 ~= v99 then
                v96:EquipBounceEffect()
                task.defer(p86.HighlightSlot, p86, v96)
            end
        end
    end
end
function v_u_15._Init(_) end
return v_u_15