local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_3 = require(script.Parent)
local v_u_4 = v1.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ShopSlot")
local v_u_5 = setmetatable({}, v_u_3)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_3.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8.Frame = v_u_4:Clone()
    v8.DetailsFrame = v8.Frame.Details
    v8.RewardSlot = nil
    v8:_Init()
    return v8
end
function v_u_5.OnClick(p9, ...)
    p9.RewardSlot:OnClick(...)
end
function v_u_5.Destroy(p10)
    p10.Frame:Destroy()
    if p10.RewardSlot then
        p10.RewardSlot:Destroy()
    end
    v_u_3.Destroy(p10)
end
function v_u_5._Setup(p11)
    p11.RewardSlot = v_u_2.new(p11.FirstRewardData, p11.IsLocked or p11.IsOwned)
    p11.RewardSlot:SetNameText("")
    p11.RewardSlot:SetParent(p11.Frame.Container)
    p11.DetailsFrame.Parent = p11.RewardSlot.CosmeticSlot and p11.RewardSlot.CosmeticSlot.Frame.Button or p11.RewardSlot.Frame.Reward
end
function v_u_5._Init(p12)
    p12:_Setup()
    p12:_SetupBuyButton(p12.DetailsFrame.Buy, p12.DetailsFrame.Owned)
end
return v_u_5