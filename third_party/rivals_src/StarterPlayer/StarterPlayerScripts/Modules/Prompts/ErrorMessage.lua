local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(p7, p8)
    local v9 = typeof(p7) == "string"
    local v10 = "Argument 1 invalid, expected a string, got " .. tostring(p7)
    assert(v9, v10)
    local v11 = typeof(p8) == "string"
    local v12 = "Argument 2 invalid, expected a string, got " .. tostring(p8)
    assert(v11, v12)
    local v13 = v_u_5.new(script.Name)
    local v14 = v_u_6
    local v15 = setmetatable(v13, v14)
    v15.CloseButton = v15.PromptFrame:WaitForChild("Close")
    v15.TitleText = v15.PromptFrame:WaitForChild("Title")
    v15.DescriptionText = v15.PromptFrame:WaitForChild("Description")
    v15._title = p7
    v15._desc = p8
    v15:_Init()
    return v15
end
function v_u_6._Setup(p16)
    p16.TitleText.Text = p16._title
    p16.DescriptionText.Text = p16._desc
    v_u_3:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
end
function v_u_6._Init(p_u_17)
    p_u_17.CloseButton.MouseButton1Click:Connect(function()
        p_u_17:CloseRequest()
    end)
    p_u_17:_Setup()
    v_u_4:Add(p_u_17.CloseButton)
end
return v_u_6