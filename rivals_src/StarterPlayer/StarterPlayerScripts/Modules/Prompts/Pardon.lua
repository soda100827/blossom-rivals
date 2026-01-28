local v_u_1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
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
    v9._ban_data = p6
    v9:_Init()
    return v9
end
function v_u_5.Confirm(p10)
    local v11, v12 = pcall(v_u_1.Remotes.Moderator.PardonRedFlags.InvokeServer, v_u_1.Remotes.Moderator.PardonRedFlags, p10._ban_data.Name)
    local v13 = ""
    for v14, v15 in pairs(v11 and v12 and v12 or {}) do
        v13 = v13 .. v15 .. (v14 < #v12 and "\n" or "")
    end
    p10.OpenPrompt:Fire("ErrorMessage", v11 and v13 ~= "" and "Success!" or "Woops!", v11 and v13 ~= "" and "Successfully pardoned this player\'s red flags:\n" .. v13 or (v11 and v13 == "" and "This player has no red flags!" or "Failed to pardon this player\'s red flags, please try again!"))
end
function v_u_5._Setup(p16)
    p16.TitleText.Text = "Pardon " .. p16._ban_data.Name
end
function v_u_5._Init(p_u_17)
    p_u_17.CloseButton.MouseButton1Click:Connect(function()
        p_u_17:CloseRequest()
    end)
    p_u_17.ConfirmButton.MouseButton1Click:Connect(function()
        p_u_17:Confirm()
    end)
    p_u_17:_Setup()
    v_u_3:Add(p_u_17.CloseButton)
    v_u_3:Add(p_u_17.ConfirmButton)
end
return v_u_5