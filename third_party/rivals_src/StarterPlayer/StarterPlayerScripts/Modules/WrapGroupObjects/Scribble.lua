local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = { "rbxassetid://112448109089773", "rbxassetid://85215887790060" }
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._textures1 = {}
    v7._textures2 = {}
    v7._texture_index = 0
    v7._next_tick = 0
    v7:_Init()
    return v7
end
function v_u_4.Update(p8, _)
    local v9 = workspace:GetServerTimeNow()
    if v9 >= p8._next_tick then
        p8._next_tick = v9 + 0.15
        p8._texture_index = p8._texture_index + 1
        local v10 = p8._texture_index % 2 + 1
        local v11 = 3 - v10
        for _, v12 in pairs(p8._textures1) do
            v12.Texture = v_u_3[v10]
        end
        for _, v13 in pairs(p8._textures2) do
            v13.Texture = v_u_3[v11]
        end
    end
end
function v_u_4._Setup(p14)
    for _, v15 in pairs(p14.ExtraObjects) do
        if v15.Name == "Scribbles" then
            local v16 = p14._textures1
            table.insert(v16, v15)
        elseif v15.Name == "Scribbles2" then
            local v17 = p14._textures2
            table.insert(v17, v15)
        end
    end
end
function v_u_4._Init(p18)
    p18:_Setup()
end
return v_u_4