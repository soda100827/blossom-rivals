local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.BountyLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("NotificationSlot")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10, p11, p12, p13, p14)
    local v15 = v_u_9
    local v16 = setmetatable({}, v15)
    v16.Frame = v_u_8:Clone()
    v16._creation_time = p14 or tick()
    v16._title = p10 or ""
    v16._description = p11 or ""
    v16._first_icon = p12
    v16._second_icon = p13
    local v17 = v16._first_icon
    local v18
    if typeof(v17) == "table" then
        v18 = v16._first_icon
    else
        v18 = false
    end
    v16._first_reward_info = v18
    local v19 = v16._second_icon
    local v20
    if typeof(v19) == "table" then
        v20 = v16._second_icon
    else
        v20 = false
    end
    v16._second_reward_info = v20
    v16._cleanup = {}
    v16:_Init()
    return v16
end
function v_u_9.SetParent(p21, p22)
    p21.Frame.Parent = p22
end
function v_u_9.PlaySound(p23, p24)
    if p24 then
        v_u_5:CreateSound(p24, 1.5, 1, script, true, 5)
        return
    elseif p23._second_reward_info and v_u_4.Rewards[p23._second_reward_info.Name] then
        v_u_5:CreateSound("rbxassetid://17770244373", 1.5, 1, script, true, 5)
        return
    elseif p23._second_reward_info and (v_u_3.Rewards[p23._second_reward_info.Name] and v_u_3.Rewards[p23._second_reward_info.Name].Type == "Weapon") then
        v_u_5:CreateSound("rbxassetid://17769583566", 1.5, 1, script, true, 5)
        return
    elseif p23._second_reward_info and v_u_3.Rewards[p23._second_reward_info.Name] then
        v_u_5:CreateSound("rbxassetid://17769583339", 1.5, 1, script, true, 5)
        return
    elseif p23._second_reward_info and p23._second_reward_info.Weapon == "IsUniversal" then
        v_u_5:CreateSound("rbxassetid://17769583566", 1.5, 1, script, true, 5)
        return
    elseif p23._second_reward_info then
        v_u_5:CreateSound("rbxassetid://17769583804", 1.5, 1, script, true, 5)
    else
        v_u_5:CreateSound("rbxassetid://17769893181", 1.5, 1, script, true, 5)
    end
end
function v_u_9.PlayGlow(p_u_25)
    task.spawn(v_u_5.RenderstepForLoop, v_u_5, 0, 100, 1, function(p26)
        local v27 = p26 / 100
        p_u_25.Frame.Glow.ImageTransparency = v27
    end)
end
function v_u_9.PlaySize(p_u_28, p29, p30)
    local v31 = p29 or 1
    p_u_28.Frame.Size = UDim2.new(1.1 * v31, 0, 1.1 * v31, 0)
    p_u_28.Frame:TweenSize(UDim2.new(1 * v31, 0, 1 * v31, 0), "Out", "Back", 0.25, true)
    if p30 then
        task.delay(p30 - 0.5, pcall, p_u_28.Frame.TweenSize, p_u_28.Frame, UDim2.new(0, 0, 0, 0), "In", "Quint", 0.5, true, function()
            p_u_28.Frame:Destroy()
        end)
    end
end
function v_u_9.UpdateAge(p32)
    local v33 = tick() - p32._creation_time
    local v34 = math.floor(v33)
    p32.Frame.Age.Visible = true
    p32.Frame.Age.Title.Text = v34 < 1 and "just now" or v_u_5:TimeFormat2(v34, true) .. " ago"
end
function v_u_9.Destroy(p35)
    for _, v36 in pairs(p35._cleanup) do
        v36:Destroy()
    end
    p35._cleanup = {}
    p35.Frame:Destroy()
end
function v_u_9._Setup(p37)
    p37.Frame.Title.Text = p37._title or ""
    p37.Frame.Description.Text = p37._description or ""
    local v38 = p37.Frame.FirstIcon
    local v39 = p37._first_icon
    v38.Image = typeof(v39) == "string" and (p37._first_icon or "") or ""
    local v40 = p37.Frame.SecondIcon
    local v41 = p37._second_icon
    v40.Image = typeof(v41) == "string" and (p37._second_icon or "") or ""
    p37.Frame.Background.BackgroundColor3 = v_u_7.BUTTON_BACKGROUND_COLOR
    p37.Frame.Background.BackgroundTransparency = v_u_7.BUTTON_BACKGROUND_TRANSPARENCY
    if p37._first_reward_info then
        if v_u_3.Cosmetics[p37._first_reward_info.Name] then
            p37._first_reward_info.Quantity = nil
        end
        local v42 = v_u_6.new(p37._first_reward_info)
        v42:SetParent(p37.Frame.FirstReward)
        local v43 = p37._cleanup
        table.insert(v43, v42)
    end
    if p37._second_reward_info then
        if v_u_3.Cosmetics[p37._second_reward_info.Name] then
            p37._second_reward_info.Quantity = nil
        end
        local v44 = v_u_6.new(p37._second_reward_info)
        v44:SetParent(p37.Frame.SecondReward)
        local v45 = p37._cleanup
        table.insert(v45, v44)
    end
end
function v_u_9._Init(p46)
    p46:_Setup()
end
return v_u_9