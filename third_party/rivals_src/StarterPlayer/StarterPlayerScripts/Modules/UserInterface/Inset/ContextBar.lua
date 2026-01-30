local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.DebugLibrary)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController"))
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController"))
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("PlayerList"))
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("InsetButtonsBar"))
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_11 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_12 = {
    {
        "Restrictions",
        "",
        "rbxassetid://120647688402991",
        nil,
        nil,
        nil
    },
    {
        "StopFreecam",
        "Turn off freecam mode",
        "rbxassetid://17548980857",
        nil,
        nil,
        nil
    },
    {
        "PlayerList",
        "Open the player list",
        "rbxassetid://108950719202626",
        nil,
        nil,
        nil
    },
    {
        "HUD",
        "Enable your HUD",
        "rbxassetid://137078038380313",
        nil,
        nil,
        nil
    },
    {
        "Moderation",
        "Do not leak the moderation panel",
        "rbxassetid://118920750856778",
        nil,
        nil,
        "Moderation"
    },
    {
        "Debug",
        "Test things out using commands",
        "rbxassetid://18223601855",
        nil,
        UDim2.new(0.6, 0, 0.6, 0),
        "Debug"
    }
}
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13.new(p14)
    local v15 = v_u_13
    local v16 = setmetatable({}, v15)
    v16.Inset = p14
    v16.Bar = v_u_9.new(v_u_11.BUTTON_BACKGROUND_TRANSPARENCY, v_u_11.BUTTON_BACKGROUND_COLOR, v_u_11.BUTTON_ICON_COLOR, true)
    v16:_Init()
    return v16
end
function v_u_13.SetVisible(p17, p18, p19)
    p17.Bar.Frame.Visible = p18
    p17.Bar.Frame.Size = p19 or p17.Bar.Frame.Size
    p17.Bar:Toggle(true)
end
function v_u_13._UpdateVisibility(p20)
    local v21 = v_u_5:Get("WinsFromDuelPadsToday") >= v_u_3.MAX_DUEL_PAD_WINS_PER_DAY_BEFORE_BEING_BLOCKED
    local v22 = v_u_5:Get("IsBadGuy")
    local v23 = v_u_5:Get("IsBadGuy2")
    local v24 = (("" .. (v21 and "You\'ve reached the max amount of wins from duel pads today\n" or "")) .. (v22 and "You\'ve been banned from casual leaderboards due to your ban history\n" or "")) .. (v23 and "You\'ve been banned from competitive leaderboards due to your ban history\n" or "")
    local v25
    if v24 == "" then
        v25 = ""
    else
        local v26 = #v24 - 1
        v25 = string.sub(v24, 1, v26)
    end
    p20.Bar.Buttons.Restrictions:SetBubbleText(v25)
    p20.Bar.Buttons.Restrictions.Frame.Visible = v25 ~= ""
    local v27 = v_u_7.CameraState:HasFreecamAccess()
    local v28 = v_u_7:GetPublicState() == v_u_7.CameraState.States.CustomFreecam
    p20.Bar.Buttons.StopFreecam.Frame.Visible = v27 and v28
    local v29 = p20.Bar.Buttons.PlayerList.Frame
    local v30 = v_u_8.ClosedByInputs
    if v30 then
        v30 = v_u_8:GetBaseVisibility()
    end
    v29.Visible = v30
    p20.Bar.Buttons.HUD.Frame.Visible = v_u_5:Get("Settings Hide HUD")
    if p20.Bar.Buttons.Debug then
        p20.Bar.Buttons.Debug.Frame.Visible = not v_u_5:Get("Settings Staff Team Tools Disabled")
    end
    if p20.Bar.Buttons.Moderation then
        p20.Bar.Buttons.Moderation.Frame.Visible = not v_u_5:Get("Settings Staff Team Tools Disabled")
    end
    p20:SetVisible(p20.Bar.Frame.Visible)
end
function v_u_13._Setup(p31)
    for v32, v33 in pairs(v_u_12) do
        local v34, v35, v36, v37, v38, v_u_39 = table.unpack(v33)
        if v34 ~= "Debug" or v_u_4:HasBasicAccess(v_u_2.LocalPlayer.UserId, v_u_5:Get("GroupRank")) then
            if v34 ~= "Moderation" or v_u_3.HAS_MODERATOR_ACCESS(v_u_5:Get("GroupRank")) then
                p31.Bar:CreateButton(v32, v34, v35, v36, v37, v38).Clicked:Connect(function()
                    if v_u_39 then
                        v_u_10.PageSystem:OpenPage(v_u_39)
                    end
                end)
            end
        end
    end
    p31.Bar.Buttons.StopFreecam.Clicked:Connect(function()
        v_u_7.CameraState:SetCustomFreecamEnabled(false)
    end)
    p31.Bar.Buttons.PlayerList.Clicked:Connect(function()
        v_u_8:SetClosedByInputs(not v_u_8.ClosedByInputs)
    end)
    p31.Bar.Buttons.HUD.Clicked:Connect(function()
        v_u_6:ChangeSetting("Settings Hide HUD", false)
    end)
    p31.Bar.Frame.Parent = p31.Inset.RightButtonsFrame
end
function v_u_13._Init(p_u_40)
    v_u_5:GetDataChangedSignal("Settings Staff Team Tools Disabled"):Connect(function()
        p_u_40:_UpdateVisibility()
    end)
    v_u_5:GetDataChangedSignal("Settings Hide HUD"):Connect(function()
        p_u_40:_UpdateVisibility()
    end)
    v_u_5:GetDataChangedSignal("IsBadGuy"):Connect(function()
        p_u_40:_UpdateVisibility()
    end)
    v_u_5:GetDataChangedSignal("IsBadGuy2"):Connect(function()
        p_u_40:_UpdateVisibility()
    end)
    v_u_5:GetDataChangedSignal("WinsFromDuelPadsToday"):Connect(function()
        p_u_40:_UpdateVisibility()
    end)
    v_u_8.ClosedByInputsChanged:Connect(function()
        p_u_40:_UpdateVisibility()
    end)
    v_u_8.BaseVisibilityChanged:Connect(function()
        p_u_40:_UpdateVisibility()
    end)
    v_u_7.CustomFreecamStateChanged:Connect(function()
        p_u_40:_UpdateVisibility()
    end)
    v_u_7.CameraState.FreecamAccessChanged:Connect(function()
        p_u_40:_UpdateVisibility()
    end)
    p_u_40:_Setup()
    p_u_40:_UpdateVisibility()
end
return v_u_13