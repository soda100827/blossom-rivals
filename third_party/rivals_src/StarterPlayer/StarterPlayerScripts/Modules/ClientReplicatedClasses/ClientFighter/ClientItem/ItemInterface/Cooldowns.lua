local v_u_1 = game:GetService("HttpService")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2.new(p3)
    local v4 = v_u_2
    local v5 = setmetatable({}, v4)
    v5.ItemInterface = p3
    v5._cooldown_slots = {}
    v5:_Init()
    return v5
end
function v_u_2.Create(p_u_6, p7, p8, p_u_9, p10)
    if p_u_6._destroyed then
        return
    else
        p_u_6:Clear(p_u_9)
        local v11 = p_u_6.ItemInterface.Mouse:CooldownEffect(p7, p8, p_u_9, p10)
        local v12
        if p10 or not p_u_6.ItemInterface.ClientItem.ClientFighter.FighterInterface then
            v12 = nil
        else
            v12 = p_u_6.ItemInterface.ClientItem.ClientFighter.FighterInterface.Hotbar:CooldownEffect(p_u_6.ItemInterface.ClientItem, p7, p8, p_u_9, p10)
        end
        if p_u_9 then
            local v_u_13 = v_u_1:GenerateGUID()
            p_u_6._cooldown_slots[p_u_9] = { v_u_13, v11, v12 }
            task.delay(p8, function()
                if p_u_6._cooldown_slots[p_u_9] and p_u_6._cooldown_slots[p_u_9][1] == v_u_13 then
                    p_u_6._cooldown_slots[p_u_9] = nil
                end
            end)
        end
    end
end
function v_u_2.Clear(p14, p15)
    if p14._cooldown_slots[p15] then
        for v16 = 2, #p14._cooldown_slots[p15] do
            p14._cooldown_slots[p15][v16]:Destroy()
        end
        p14._cooldown_slots[p15] = nil
    end
end
function v_u_2.Destroy(_) end
function v_u_2._Init(_) end
return v_u_2