local v_u_1 = game:GetService("CollectionService")
game:GetService("RunService")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2._new()
    local v3 = v_u_2
    local v4 = setmetatable({}, v3)
    v4._is_playing = false
    v4._next_flicker = {}
    v4:_Init()
    return v4
end
function v_u_2._Play(p5)
    if not p5._is_playing then
        p5._is_playing = true
        while true do
            local v6 = v_u_1:GetTagged("FlickeringLight")
            if #v6 == 0 then
                break
            end
            for _, v_u_7 in pairs(v6) do
                if tick() >= (p5._next_flicker[v_u_7] or 0) then
                    p5._next_flicker[v_u_7] = tick() + 1 + 4 * math.random()
                    task.spawn(function()
                        for _ = 1, math.random(1, 3) do
                            local v8 = v_u_7:FindFirstChildOfClass("SurfaceLight")
                            v_u_7.Material = Enum.Material.Neon
                            if v8 then
                                v8.Enabled = true
                            end
                            wait(0.1)
                            v_u_7.Material = Enum.Material.SmoothPlastic
                            if v8 then
                                v8.Enabled = false
                            end
                            wait(0.1)
                        end
                    end)
                end
            end
            wait(0.1)
        end
        p5._is_playing = false
    end
end
function v_u_2._Init(p_u_9)
    v_u_1:GetInstanceAddedSignal("FlickeringLight"):Connect(function(p10)
        p_u_9._next_flicker[p10] = tick() + 1
        p_u_9:_Play()
    end)
    v_u_1:GetInstanceRemovedSignal("FlickeringLight"):Connect(function(p11)
        p_u_9._next_flicker[p11] = nil
    end)
    task.spawn(p_u_9._Play, p_u_9)
end
return v_u_2._new()