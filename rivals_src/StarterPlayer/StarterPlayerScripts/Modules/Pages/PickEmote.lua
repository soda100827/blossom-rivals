local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers:WaitForChild("EmoteController"))
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("EmoteWheel"))
local v_u_4 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5._new()
    local v6 = v_u_4.new(script.Name)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8.EmoteWheelSlotsFrame = v8.PageFrame:WaitForChild("EmoteWheelSlots")
    v8.HidePartyDisplay = true
    v8.EmoteWheel = v_u_3.new()
    v8:_Init()
    return v8
end
function v_u_5.GetDefaultElement(_)
    return nil
end
function v_u_5.PickEarly(p9)
    p9.EmoteWheel:FinishInputs()
end
function v_u_5.Open(p10, ...)
    v_u_4.Open(p10, ...)
    p10.EmoteWheel:SetEnabled(true)
    p10.EmoteWheel:StartInputs()
end
function v_u_5.Close(p11, ...)
    p11.EmoteWheel:StopInputs()
    p11.EmoteWheel:SetEnabled(false)
    v_u_4.Close(p11, ...)
end
function v_u_5._Picked(p12, p13)
    if p12._is_open then
        if p13 then
            v_u_2:UseEmote(p13)
        end
        p12:CloseRequest()
    end
end
function v_u_5._Setup(p14)
    p14.EmoteWheel.Frame.Parent = p14.EmoteWheelSlotsFrame
end
function v_u_5._Init(p_u_15)
    p_u_15.EmoteWheel.EmoteKeyPicked:Connect(function(p16)
        p_u_15:_Picked(p16)
    end)
    v_u_2.CanEmoteChanged:Connect(function()
        if not v_u_2:CanEmote(true) then
            p_u_15:CloseRequest()
        end
    end)
    p_u_15:_Setup()
end
return v_u_5._new()