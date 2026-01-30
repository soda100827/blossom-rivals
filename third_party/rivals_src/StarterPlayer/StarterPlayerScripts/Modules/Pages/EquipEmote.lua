local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Controllers:WaitForChild("EmoteController"))
local v_u_4 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_5 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticSlot"))
local v_u_6 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("EmoteWheel"))
local v_u_7 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_8 = setmetatable({}, v_u_7)
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_7.new(script.Name)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.CloseButton = v11.PageFrame:WaitForChild("Close")
    v11.EmoteWheelSlotsFrame = v11.PageFrame:WaitForChild("EmoteWheelSlots")
    v11.EmoteSlotContainer = v11.PageFrame:WaitForChild("EmoteSlotContainer")
    v11.HidePartyDisplay = true
    v11.EmoteWheel = v_u_6.new()
    v11._emote_name = nil
    v11._emote_slot = nil
    v11._just_picked = nil
    v11:_Init()
    return v11
end
function v_u_8.GetDefaultElement(_)
    return nil
end
function v_u_8.SetEmoteName(p12, p13)
    if p12._emote_slot then
        p12._emote_slot:Destroy()
        p12._emote_slot = nil
    end
    p12._emote_name = p13
    if p12._emote_name then
        p12._emote_slot = v_u_5.new(p12._emote_name)
        p12._emote_slot:SetInteractable(false)
        p12._emote_slot.Frame.Parent = p12.EmoteSlotContainer
        p12:_UpdateEmoteSlotPosition()
    end
end
function v_u_8.PickEmoteKey(p14, p15)
    if p14._is_open and not p14._just_picked then
        if p15 and p14._emote_name then
            local v16 = v_u_2:Get("EquippedEmotes")[p15]
            local v17 = v_u_3
            local v18
            if v16 and v16.Name == p14._emote_name then
                v18 = nil
            else
                v18 = p14._emote_name
            end
            v17:EquipEmote(p15, v18)
        else
            p14:CloseRequest()
        end
    else
        return
    end
end
function v_u_8.Open(p19, ...)
    v_u_7.Open(p19, ...)
    p19.EmoteWheel:SetEnabled(true)
    p19.EmoteWheel:StartInputs(true)
    p19._just_picked = nil
end
function v_u_8.Close(p20, ...)
    p20._just_picked = nil
    p20.EmoteWheel:StopInputs()
    p20.EmoteWheel:SetEnabled(false)
    v_u_7.Close(p20, ...)
end
function v_u_8._UpdateEmoteSlotPosition(p21)
    if p21._emote_slot then
        local v22 = p21.EmoteWheel:GetLastHighlightedSlot()
        local v23
        if v22 then
            v23 = (v22:GetContainerPosition() - (p21.EmoteSlotContainer.AbsolutePosition + p21.EmoteSlotContainer.AbsoluteSize / 2)).Unit
        else
            v23 = Vector2.zero
        end
        p21._emote_slot.Frame:TweenPosition(UDim2.new(0.5 + v23.X, 0, 0.5 + v23.Y, 0), "Out", "Quint", 0.25, true)
    end
end
function v_u_8._Setup(p24)
    p24.EmoteWheel.Frame.Parent = p24.EmoteWheelSlotsFrame
end
function v_u_8._Init(p_u_25)
    p_u_25.CloseButton.MouseButton1Click:Connect(function()
        p_u_25:CloseRequest()
    end)
    p_u_25.EmoteWheel.EmoteKeyPicked:Connect(function(p26)
        v_u_4:ClickSound()
        p_u_25:PickEmoteKey(p26)
    end)
    p_u_25.EmoteWheel.EmoteWheelSlotHighlighted:Connect(function(_)
        p_u_25:_UpdateEmoteSlotPosition()
    end)
    p_u_25:_Setup()
    p_u_25:_UpdateEmoteSlotPosition()
    v_u_4:Add(p_u_25.CloseButton)
end
return v_u_8._new()