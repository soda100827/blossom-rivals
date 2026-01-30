local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.SettingsInfo)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings"):WaitForChild("Dropdown"))
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_7 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BanDropdown")
local v_u_8 = {
    "Exploiting",
    "Exploiting - Movement Cheats",
    "Exploiting - Aim Cheats",
    "Exploiting - Vision Cheats",
    "Requesting Exploits",
    "Playing With Exploiters",
    "Fake Reporting",
    "Farming",
    "Abusing Minor Bugs",
    "Harassment / Hate Speech",
    "Ban Evasion",
    "CLEAR_TRADE_BAN",
    "Custom"
}
local v_u_9 = {
    "Permanent",
    "1 day",
    "3 days",
    "7 days",
    "14 days",
    "30 days",
    "90 days",
    "180 days",
    "365 days",
    "Custom"
}
local v_u_10 = setmetatable({}, v_u_6)
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = v_u_6.new(script.Name)
    local v13 = v_u_10
    local v14 = setmetatable(v12, v13)
    v14.CloseButton = v14.PromptFrame:WaitForChild("Close")
    v14.ConfirmButton = v14.PromptFrame:WaitForChild("Confirm")
    v14.TitleText = v14.PromptFrame:WaitForChild("Title")
    v14.DetailsFrame = v14.PromptFrame:WaitForChild("Details")
    v14.ReasonFrame = v14.DetailsFrame:WaitForChild("Reason")
    v14.ReasonDropdownFrame = v14.ReasonFrame:WaitForChild("Dropdown")
    v14.ReasonCustomFrame = v14.DetailsFrame:WaitForChild("ReasonCustom")
    v14.ReasonCustomBox = v14.ReasonCustomFrame:WaitForChild("Input"):WaitForChild("Box")
    v14.ReasonNoticeFrame = v14.DetailsFrame:WaitForChild("ReasonNotice")
    v14.DurationFrame = v14.DetailsFrame:WaitForChild("Duration")
    v14.DurationDropdownFrame = v14.DurationFrame:WaitForChild("Dropdown")
    v14.DurationCustomFrame = v14.DetailsFrame:WaitForChild("DurationCustom")
    v14.DurationCustomBox = v14.DurationCustomFrame:WaitForChild("Input"):WaitForChild("Box")
    v14.ReasonDropdown = v_u_4.new(v_u_3.new("", "", "", "", "", "Dropdown", v_u_8[1], v_u_8), v_u_7)
    v14.DurationDropdown = v_u_4.new(v_u_3.new("", "", "", "", "", "Dropdown", v_u_9[1], v_u_9), v_u_7)
    v14._ban_data = p11
    v14:_Init()
    return v14
end
function v_u_10.Confirm(p15)
    local v16
    if p15.ReasonDropdown.Value == "Custom" then
        v16 = p15.ReasonCustomBox.Text
    else
        v16 = p15.ReasonDropdown.Value
    end
    local v17
    if p15.ReasonDropdown.Value == "CLEAR_TRADE_BAN" then
        v17 = 1
    elseif p15.DurationDropdown.Value == "Custom" then
        local v18 = p15.DurationCustomBox.Text
        v17 = tonumber(v18)
    elseif p15.DurationDropdown.Value == "Permanent" then
        v17 = -1
    else
        local v19 = p15.DurationDropdown.Value
        local v20 = string.find(p15.DurationDropdown.Value, " ") - 1
        local v21 = string.sub(v19, 1, v20)
        v17 = tonumber(v21)
    end
    if v17 then
        if #v16 >= 5 and #v16 <= 100 then
            v_u_1.Remotes.Moderator.Ban:FireServer(p15._ban_data.Name, v17, v16)
            task.defer(p15.CloseRequest, p15)
        end
    else
        return
    end
end
function v_u_10.Destroy(p22)
    p22.ReasonDropdown:Destroy()
    p22.DurationDropdown:Destroy()
    v_u_6.Destroy(p22)
end
function v_u_10._Update(p23)
    local v24 = p23.ReasonDropdown.Value
    local v25 = p23.DurationDropdown.Value
    p23.ReasonNoticeFrame.Visible = v24 == "CLEAR_TRADE_BAN"
    p23.ReasonCustomFrame.Visible = v24 == "Custom"
    p23.DurationFrame.Visible = v24 ~= "CLEAR_TRADE_BAN"
    local v26 = p23.DurationCustomFrame
    local v27
    if v25 == "Custom" then
        v27 = v24 ~= "CLEAR_TRADE_BAN"
    else
        v27 = false
    end
    v26.Visible = v27
end
function v_u_10._Setup(p28)
    p28.TitleText.Text = "@" .. p28._ban_data.Name
    p28.ReasonDropdown.SettingFrame.Parent = p28.ReasonDropdownFrame
    p28.DurationDropdown.SettingFrame.Parent = p28.DurationDropdownFrame
end
function v_u_10._Init(p_u_29)
    p_u_29.CloseButton.MouseButton1Click:Connect(function()
        p_u_29:CloseRequest()
    end)
    p_u_29.ConfirmButton.MouseButton1Click:Connect(function()
        p_u_29:Confirm()
    end)
    p_u_29.DurationCustomBox.FocusLost:Connect(function()
        if p_u_29.DurationCustomBox.Text ~= "" then
            local v30 = p_u_29.DurationCustomBox
            local v31 = p_u_29.DurationCustomBox.Text
            local v32
            if tonumber(v31) then
                local v33 = p_u_29.DurationCustomBox.Text
                local v34 = tonumber(v33)
                local v35 = math.floor(v34)
                v32 = math.clamp(v35, 1, 999) or ""
            else
                v32 = ""
            end
            v30.Text = v32
        end
    end)
    p_u_29.ReasonDropdown.Replicate:Connect(function()
        p_u_29:_Update()
    end)
    p_u_29.DurationDropdown.Replicate:Connect(function()
        p_u_29:_Update()
    end)
    p_u_29:_Setup()
    p_u_29:_Update()
    v_u_5:Add(p_u_29.CloseButton)
    v_u_5:Add(p_u_29.ConfirmButton)
end
return v_u_10