local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_5.new(script.Name)
    local v9 = v_u_6
    local v10 = setmetatable(v8, v9)
    v10.CloseButton = v10.PromptFrame:WaitForChild("Close")
    v10.ConfirmButton = v10.PromptFrame:WaitForChild("Confirm")
    v10.TitleText = v10.PromptFrame:WaitForChild("Title")
    v10._ban_data = p7
    v10:_Init()
    return v10
end
function v_u_6._Setup(p11)
    p11.TitleText.Text = "Unban " .. p11._ban_data.Name
end
function v_u_6._Init(p_u_12)
    p_u_12.CloseButton.MouseButton1Click:Connect(function()
        p_u_12:CloseRequest()
    end)
    p_u_12.ConfirmButton.MouseButton1Click:Connect(function()
        v_u_1.Remotes.Moderator.Unban:FireServer(p_u_12._ban_data.Name)
        v_u_2.Heartbeat:Wait()
        p_u_12:CloseRequest()
    end)
    p_u_12:_Setup()
    v_u_4:Add(p_u_12.CloseButton)
    v_u_4:Add(p_u_12.ConfirmButton)
end
return v_u_6