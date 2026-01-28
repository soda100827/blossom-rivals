local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.ClientQueuePad = p6
    v8._model = v8.ClientQueuePad:Get("Model"):WaitForChild("Visuals"):WaitForChild("Terminal")
    v8._proximity_prompt = v8._model:WaitForChild("Prompt"):WaitForChild("ProximityPrompt")
    v8:_Init()
    return v8
end
function v_u_5.Destroy(_) end
function v_u_5._Setup(p9)
    p9._proximity_prompt.ObjectText = p9.ClientQueuePad:Get("Model").Name
    p9._proximity_prompt.MaxActivationDistance = 8
    if not v_u_3.IS_PRIVATE_SERVER_OWNER(v_u_2.LocalPlayer.UserId) then
        task.defer(p9._model.Destroy, p9._model)
    end
end
function v_u_5._Init(p_u_10)
    p_u_10._proximity_prompt.Triggered:Connect(function()
        v_u_4.PageSystem:OpenPage("EditQueuePad", true)
        v_u_4.PageSystem:WaitForPage("EditQueuePad"):SetQueuePad(p_u_10.ClientQueuePad)
    end)
    p_u_10:_Setup()
end
return v_u_5