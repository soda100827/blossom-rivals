local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6._new()
    local v7 = v_u_5.new(script.Name)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9.ClaimButton = v9.PageFrame:WaitForChild("Claim")
    v9.RewardsFrame = v9.PageFrame:WaitForChild("Rewards")
    v9.TitleText = v9.PageFrame:WaitForChild("Title")
    v9:_Init()
    return v9
end
function v_u_6.CloseRequest(p10, ...)
    v_u_1.Remotes.Data.ClaimWelcomeBackGift:FireServer()
    v_u_5.CloseRequest(p10, ...)
end
function v_u_6._Setup(p11)
    p11.TitleText.Text = "Welcome back, " .. v_u_2.LocalPlayer.DisplayName .. "!"
    v_u_4.new({
        ["Name"] = "Standard Weapon Crate",
        ["Quantity"] = 1
    }):SetParent(p11.RewardsFrame)
end
function v_u_6._Init(p_u_12)
    p_u_12.ClaimButton.MouseButton1Click:Connect(function()
        p_u_12:CloseRequest()
    end)
    p_u_12:_Setup()
    v_u_3:Add(p_u_12.ClaimButton)
end
return v_u_6._new()