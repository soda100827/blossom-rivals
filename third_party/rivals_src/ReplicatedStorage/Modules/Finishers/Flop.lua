local v1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
require(v1.Modules.BetterDebris)
local v_u_2 = require(v1.Modules.Finishers.Ragdoll)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = { "rbxassetid://88375867455898", "rbxassetid://79484939092852", "rbxassetid://107671189154511" }
local v_u_5 = setmetatable({}, v_u_2)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_2.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayServer(p_u_9, ...)
    v_u_2.PlayServer(p_u_9, ...)
    if p_u_9._is_humanoid then
        p_u_9:_InternalThread(task.spawn, function()
            while true do
                wait(0.25)
                if p_u_9._destroyed then
                    break
                end
                v_u_3:Knockback(p_u_9._subject.RootPart, Vector3.new(0, 20, 0))
                p_u_9:CreateSound(v_u_4[math.random(#v_u_4)], 1.25, 1 + 0.1 * math.random(), nil, true, 5)
                wait(0.5)
                if p_u_9._destroyed then
                    return
                end
            end
        end)
    end
end
function v_u_5._Init(_) end
return v_u_5