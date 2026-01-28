local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BanLogSlot")
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_5.new(script.Name)
    local v10 = v_u_7
    local v11 = setmetatable(v9, v10)
    v11.CloseButton = v11.PromptFrame:WaitForChild("Close")
    v11.EmptyText = v11.PromptFrame:WaitForChild("Empty")
    v11.List = v11.PromptFrame:WaitForChild("List")
    v11.Container = v11.List:WaitForChild("Container")
    v11.Layout = v11.Container:WaitForChild("Layout")
    v11._ban_data = p8
    v11:_Init()
    return v11
end
function v_u_7._Setup(p12)
    p12.EmptyText.Visible = #p12._ban_data.BanHistory == 0
    p12.List.Visible = not p12.EmptyText.Visible
    for _, v_u_13 in pairs(p12._ban_data.BanHistory) do
        local v14 = v_u_13.Reason ~= "Unbanned"
        local v_u_15 = v_u_6:Clone()
        local v16 = v_u_15.Picture
        local v17 = string.format
        local v18 = v_u_3.HEADSHOT_IMAGE
        local v19 = v_u_13.Moderator
        v16.Image = v17(v18, (tostring(v19)))
        v_u_15.Date.Text = v_u_13.Date
        v_u_15.Duration.Text = not v14 and "" or (v_u_13.Duration == 999999999 and "\226\136\158" or v_u_13.Duration .. "d")
        v_u_15.Moderator.Text = "\226\128\162 \226\128\162 \226\128\162"
        v_u_15.Reason.Text = v_u_13.Reason
        v_u_15.Reason.TextColor3 = not v14 and Color3.fromRGB(100, 255, 50) or (v_u_13.Reason == "CLEAR_TRADE_BAN" and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 50, 50))
        v_u_15.Parent = p12.Container
        task.spawn(function()
            local v20 = v_u_15.Moderator
            local v21, v22 = pcall(v_u_2.GetNameFromUserIdAsync, v_u_2, v_u_13.Moderator)
            if v21 then
                v20.Text = v22
            end
        end)
    end
end
function v_u_7._Init(p_u_23)
    p_u_23.CloseButton.MouseButton1Click:Connect(function()
        p_u_23:CloseRequest()
    end)
    p_u_23.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_23.List.CanvasSize = UDim2.new(0, 0, 0, p_u_23.Layout.AbsoluteContentSize.Y)
    end)
    p_u_23:_Setup()
    v_u_4:Add(p_u_23.CloseButton)
end
return v_u_7