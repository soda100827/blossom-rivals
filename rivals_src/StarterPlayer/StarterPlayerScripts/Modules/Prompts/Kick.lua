local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_4.new(script.Name)
    local v8 = v_u_5
    local v9 = setmetatable(v7, v8)
    v9.CloseButton = v9.PromptFrame:WaitForChild("Close")
    v9.ConfirmButton = v9.PromptFrame:WaitForChild("Confirm")
    v9.TitleText = v9.PromptFrame:WaitForChild("Title")
    v9.DetailsFrame = v9.PromptFrame:WaitForChild("Details")
    v9.ReasonCustomBox = v9.DetailsFrame:WaitForChild("ReasonCustom"):WaitForChild("Input"):WaitForChild("Box")
    v9._ban_data = p6
    v9:_Init()
    return v9
end
function v_u_5.Confirm(p10)
    local v11 = p10.ReasonCustomBox.Text
    if #v11 >= 5 and #v11 <= 100 then
        v_u_1.Remotes.Moderator.Kick:FireServer(p10._ban_data.Name, v11)
        task.defer(p10.CloseRequest, p10)
    end
end
function v_u_5._Setup(p12)
    p12.TitleText.Text = "@" .. p12._ban_data.Name
end
function v_u_5._Init(p_u_13)
    p_u_13.CloseButton.MouseButton1Click:Connect(function()
        p_u_13:CloseRequest()
    end)
    p_u_13.ConfirmButton.MouseButton1Click:Connect(function()
        p_u_13:Confirm()
    end)
    p_u_13:_Setup()
    v_u_3:Add(p_u_13.CloseButton)
    v_u_3:Add(p_u_13.ConfirmButton)
end
return v_u_5