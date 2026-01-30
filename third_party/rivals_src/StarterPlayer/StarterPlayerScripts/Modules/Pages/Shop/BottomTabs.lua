local v1 = game:GetService("Players")
require(v1.LocalPlayer.PlayerScripts.Controllers.ShopController)
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.Shop = p4
    v6.Frame = v6.Shop.List:WaitForChild("BottomTabs")
    v6.Container = v6.Frame:WaitForChild("Container")
    v6.GiftingButton = v6.Container:WaitForChild("Gifting")
    v6.RewardsButton = v6.Container:WaitForChild("Rewards")
    v6:_Init()
    return v6
end
function v_u_3.Open(_) end
function v_u_3.Close(_) end
function v_u_3.Setup(_) end
function v_u_3._Init(p_u_7)
    p_u_7.GiftingButton.MouseButton1Click:Connect(function()
        p_u_7.Shop:SetPage("Gifting")
    end)
    p_u_7.RewardsButton.MouseButton1Click:Connect(function()
        p_u_7.Shop:SetPage("Rewards")
    end)
    v_u_2:Add(p_u_7.GiftingButton)
    v_u_2:Add(p_u_7.RewardsButton)
end
return v_u_3