local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.ServerOsTime)
local v_u_4 = require(v_u_1.Modules.LootLibrary)
local v_u_5 = require(v_u_1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_11 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("StoredStreakSlot")
local v_u_12 = setmetatable({}, v_u_10)
v_u_12.__index = v_u_12
function v_u_12._new()
    local v13 = v_u_10.new(script.Name)
    local v14 = v_u_12
    local v15 = setmetatable(v13, v14)
    v15.CloseButton = v15.PageFrame:WaitForChild("Close")
    v15.List = v15.PageFrame:WaitForChild("List")
    v15.Container = v15.List:WaitForChild("Container")
    v15.Layout = v15.Container:WaitForChild("Layout")
    v15._slots = {}
    v15._countdown_thread = nil
    v15:_Init()
    return v15
end
function v_u_12.Open(p16, ...)
    v_u_10.Open(p16, ...)
    p16:_Generate()
    p16:_StartCountdownLoop()
end
function v_u_12.Close(p17, ...)
    v_u_10.Close(p17, ...)
    p17:_StartCountdownLoop()
end
function v_u_12._StartCountdownLoop(p_u_18)
    if p_u_18._countdown_thread then
        task.cancel(p_u_18._countdown_thread)
        p_u_18._countdown_thread = nil
    end
    if p_u_18:IsOpen() then
        p_u_18._countdown_thread = task.spawn(function()
            while true do
                p_u_18:_UpdateCountdown()
                wait(1)
            end
        end)
    end
end
function v_u_12._UpdateCountdown(p19)
    for _, v20 in pairs(p19._slots) do
        local v21
        if v20.StoredStreak.ExpirationTime then
            v21 = v20.StoredStreak.ExpirationTime - v_u_3:GetRounded()
        else
            v21 = nil
        end
        v20.Slot.Countdown.Icon.Visible = v21 ~= nil
        v20.Slot.Countdown.Text = not v21 and "Oh no, you lost your win streak!" or (v21 <= 0 and "Expired" or v_u_5:TimeFormat2(v21))
        local v22 = v20.Slot.Countdown
        local v23
        if v21 and v21 <= 0 then
            v23 = Color3.fromRGB(255, 50, 50)
        else
            v23 = Color3.fromRGB(255, 255, 255)
        end
        v22.TextColor3 = v23
        v20.Slot.Countdown.Icon.ImageColor3 = v20.Slot.Countdown.TextColor3
    end
end
function v_u_12._Generate(p_u_24)
    for _, v25 in pairs(p_u_24._slots) do
        v25.Slot:Destroy()
    end
    p_u_24._slots = {}
    if p_u_24:IsOpen() then
        for v_u_26, v_u_27 in pairs(v_u_7:Get("StoredStreaks")) do
            local v28 = v_u_11:Clone()
            v28.Streak.Value.Text = v_u_5:PrettyNumber(v_u_27.Value)
            v28.Button.Price.Text = v_u_4:GetRecoverStreakCost(v_u_27.ConsecutiveRecoveries)
            v28.LayoutOrder = v_u_26
            v28.Parent = p_u_24.Container
            local v29 = p_u_24._slots
            table.insert(v29, {
                ["Slot"] = v28,
                ["StoredStreak"] = v_u_27
            })
            v_u_8:Add(v28.Button)
            local v_u_30 = v28.Title
            local v_u_31 = 0
            v28.Button.MouseButton1Click:Connect(function()
                if v_u_3:Get() > (v_u_27.ExpirationTime or (1 / 0)) then
                    v_u_5:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
                    return
                else
                    local v32 = v_u_4:GetRecoverStreakCost(v_u_27.ConsecutiveRecoveries)
                    if v_u_7:Get("WeaponKeys") < v32 then
                        v_u_9.PageSystem:OpenPage("Shop")
                        v_u_9.PageSystem:WaitForPage("Shop"):SetPage("Currency")
                        v_u_6:PromptCurrencyBundlePurchase(v32, "WeaponKeys")
                        p_u_24:CloseRequest()
                        return
                    elseif v_u_30.Text == "Are you sure?" then
                        v_u_5:CreateSound("rbxassetid://18228252652", 1, 1, script, true, 5)
                        v_u_1.Remotes.Data.RecoverStreak:FireServer(v_u_26)
                        p_u_24:CloseRequest()
                    else
                        v_u_30.Text = "Are you sure?"
                        v_u_31 = v_u_31 + 1
                        local v33 = v_u_31
                        wait(3)
                        if v33 == v_u_31 then
                            v_u_30.Text = "Recover now"
                        end
                    end
                end
            end)
            local v_u_34 = v28.Countdown
            local v_u_35 = v28.Countdown.Icon
            local v_u_36 = v28.Button.Price
            local v_u_37 = v_u_36.Icon
            local function v38()
                v_u_36.Position = UDim2.new(0.5, -v_u_37.AbsoluteSize.X / 2, 0.5, 0)
                v_u_37.Position = UDim2.new(0.5, v_u_36.TextBounds.X / 2, 0.5, 0)
                v_u_34.Position = UDim2.new(0.5, not v_u_35.Visible and 0 or v_u_35.AbsoluteSize.X / 2, 0.1, 0)
                v_u_35.Position = UDim2.new(0.5, -v_u_34.TextBounds.X / 2, 0.5, 0)
            end
            v_u_36:GetPropertyChangedSignal("TextBounds"):Connect(v38)
            v_u_37:GetPropertyChangedSignal("AbsoluteSize"):Connect(v38)
            v_u_34:GetPropertyChangedSignal("TextBounds"):Connect(v38)
            v_u_35:GetPropertyChangedSignal("AbsoluteSize"):Connect(v38)
            v_u_35:GetPropertyChangedSignal("Visible"):Connect(v38)
            v38()
        end
        p_u_24.CloseButton.Position = #p_u_24._slots > 1 and UDim2.new(0.95, 16, 0.0375) or UDim2.new(0.95, 16, 0.2575, 0)
        p_u_24.List.Position = #p_u_24._slots > 1 and UDim2.new(0.5, 9, 0, 0) or UDim2.new(0.5, 9, 0.22, 0)
        p_u_24:_StartCountdownLoop()
    end
end
function v_u_12._Init(p_u_39)
    p_u_39.CloseButton.MouseButton1Click:Connect(function()
        p_u_39:CloseRequest()
    end)
    p_u_39.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_39.List.CanvasSize = UDim2.new(0, 0, 0, p_u_39.Layout.AbsoluteContentSize.Y)
    end)
    v_u_7:GetDataChangedSignal("StoredStreaks"):Connect(function()
        p_u_39:_Generate()
    end)
    p_u_39:_Generate()
    v_u_8:Add(p_u_39.CloseButton)
end
return v_u_12._new()