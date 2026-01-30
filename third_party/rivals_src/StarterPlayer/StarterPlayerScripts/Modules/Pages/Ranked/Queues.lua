local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.BaseMatchmakingQueueSlot.MatchmakingQueueSlot)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Page = p7
    v9.Frame = v9.Page.Container:WaitForChild("Queues")
    v9:_Init()
    return v9
end
function v_u_6.Open(_) end
function v_u_6.Close(_) end
function v_u_6._Generate(p_u_10, p11)
    local v12 = v_u_4:WaitForChildRecursive(p_u_10.Frame, p11, 3)
    if v12 then
        v_u_5.new(p11, v12).QueueStatus:Connect(function(p13)
            if p13 == "Success" then
                p_u_10.Page.Closed:Fire()
            else
                p_u_10.Page.PromptSystem:Open("ErrorMessage", "Woops!", p13 or "Server failed to respond, please try again")
            end
        end)
    end
end
function v_u_6._Setup(p14)
    for _, v15 in pairs(v_u_3.CurrentSeason.RankedQueues) do
        task.defer(p14._Generate, p14, v15[1])
    end
end
function v_u_6._Init(p16)
    p16:_Setup()
end
return v_u_6