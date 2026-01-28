local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("HttpService")
local v3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Modules.Utility)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7.new()
    local v8 = v_u_6.new(script.Name)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10.CloseButton = v10.PromptFrame:WaitForChild("Close")
    v10.ConfirmButton = v10.PromptFrame:WaitForChild("Confirm")
    v10.List = v10.PromptFrame:WaitForChild("List")
    v10.Container = v10.List:WaitForChild("Container")
    v10.Layout = v10.Container:WaitForChild("Layout")
    v10.RecipientValueBox = v10.Container:WaitForChild("RecipientValue"):WaitForChild("Input"):WaitForChild("Box")
    v10.RecipientAddFrame = v10.Container:WaitForChild("RewardAdd")
    v10.RecipientAddInputFrame = v10.RecipientAddFrame:WaitForChild("Input")
    v10.RecipientAddInputAddButton = v10.RecipientAddInputFrame:WaitForChild("Add")
    v10.RecipientAddInputAddNetButton = v10.RecipientAddInputFrame:WaitForChild("AddNet")
    v10.RecipientAddInputAddBugNetButton = v10.RecipientAddInputFrame:WaitForChild("AddBugNet")
    v10._reward_value_template = v10.Container:WaitForChild("RewardValue")
    v10._reward_value_frames = {}
    v10:_Init()
    return v10
end
function v_u_7.Confirm(p11)
    if #p11._reward_value_frames == 0 then
        return
    else
        local v12 = p11.RecipientValueBox.Text
        if v12 == "" then
            v_u_4:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
            return
        else
            local v13 = {}
            for _, v14 in pairs(p11._reward_value_frames) do
                local v15 = v14.Input.Box.Text
                if v15 ~= "" then
                    if not p11:_IsValidJSON(v15) then
                        v_u_4:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
                        return
                    end
                    local v16 = v_u_2
                    table.insert(v13, v16:JSONDecode(v15))
                end
            end
            local v17, v18 = pcall(v_u_2.JSONEncode, v_u_2, v13)
            if v17 then
                local v19, v20 = pcall(v_u_1.Remotes.Debug.Command.InvokeServer, v_u_1.Remotes.Debug.Command, "SendOfflineGiftRewards", { v12, v18 })
                if v19 and v20 then
                    p11:CloseRequest()
                else
                    warn("Failed to send rewards:", v20)
                    v_u_4:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
                end
            else
                warn("Failed to encode reward_datas:", v18)
                v_u_4:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
                return
            end
        end
    end
end
function v_u_7._IsValidJSON(_, p21)
    return pcall(v_u_2.JSONDecode, v_u_2, p21)
end
function v_u_7._AddRewardValueFrame(p_u_22, p23)
    local v_u_24 = p_u_22._reward_value_template:Clone()
    v_u_24.LayoutOrder = p_u_22._reward_value_template.LayoutOrder + #p_u_22._reward_value_frames
    v_u_24.Input.Box.Text = not p23 and "" or v_u_2:JSONEncode(p23)
    v_u_24.Parent = p_u_22.Container
    local v25 = p_u_22._reward_value_frames
    table.insert(v25, v_u_24)
    v_u_24.Input.Close.MouseButton1Click:Connect(function()
        v_u_24:Destroy()
        local v26 = table.find(p_u_22._reward_value_frames, v_u_24)
        if v26 then
            table.remove(p_u_22._reward_value_frames, v26)
        end
    end)
    v_u_24.Input.Box:GetPropertyChangedSignal("Text"):Connect(function()
        local v27 = v_u_24.Input.Background
        local v28
        if v_u_24.Input.Box.Text == "" or p_u_22:_IsValidJSON(v_u_24.Input.Box.Text) then
            v28 = Color3.fromRGB(255, 255, 255)
        else
            v28 = Color3.fromRGB(255, 50, 50)
        end
        v27.ImageColor3 = v28
    end)
    v_u_5:Add(v_u_24.Input.Close)
end
function v_u_7._Setup(p29)
    p29._reward_value_template.Parent = nil
end
function v_u_7._Init(p_u_30)
    p_u_30.CloseButton.MouseButton1Click:Connect(function()
        p_u_30:CloseRequest()
    end)
    p_u_30.ConfirmButton.MouseButton1Click:Connect(function()
        p_u_30:Confirm()
    end)
    p_u_30.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_30.List.CanvasSize = UDim2.new(0, 0, 0, p_u_30.Layout.AbsoluteContentSize.Y)
    end)
    p_u_30.RecipientAddInputAddButton.MouseButton1Click:Connect(function()
        p_u_30:_AddRewardValueFrame(nil)
    end)
    p_u_30.RecipientAddInputAddNetButton.MouseButton1Click:Connect(function()
        p_u_30:_AddRewardValueFrame({
            ["Name"] = "Net",
            ["Quantity"] = 1,
            ["Weapon"] = "IsRandom"
        })
    end)
    p_u_30.RecipientAddInputAddBugNetButton.MouseButton1Click:Connect(function()
        p_u_30:_AddRewardValueFrame({
            ["Name"] = "Bug Net",
            ["Quantity"] = 1,
            ["Weapon"] = "Scythe"
        })
    end)
    p_u_30:_Setup()
    v_u_5:Add(p_u_30.CloseButton)
    v_u_5:Add(p_u_30.ConfirmButton)
    v_u_5:Add(p_u_30.RecipientAddInputAddButton)
    v_u_5:Add(p_u_30.RecipientAddInputAddNetButton)
    v_u_5:Add(p_u_30.RecipientAddInputAddBugNetButton)
end
return v_u_7