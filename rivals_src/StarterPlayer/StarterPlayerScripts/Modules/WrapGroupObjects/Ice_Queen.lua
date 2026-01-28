local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_3 = {
    "rbxassetid://138393431257124",
    "rbxassetid://107051054528784",
    "rbxassetid://125054446055112",
    "rbxassetid://110582063087757",
    "rbxassetid://119507229017142",
    "rbxassetid://97696327350095",
    "rbxassetid://108305398626234",
    "rbxassetid://107586098443052",
    "rbxassetid://102752148910886",
    "rbxassetid://96190250840477",
    "rbxassetid://83191963862467",
    "rbxassetid://101078325262094"
}
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._arrows1 = {}
    v7._arrows2 = {}
    v7._snowflakes = {}
    v7._frame = 0
    v7._next_update = 0
    v7:_Init()
    return v7
end
function v_u_4.Update(p8, _)
    local v9 = workspace:GetServerTimeNow()
    for _, v10 in pairs(p8._arrows1) do
        v10.OffsetStudsU = -(v9 * 2 % v10.StudsPerTileU)
    end
    for _, v11 in pairs(p8._arrows2) do
        v11.OffsetStudsU = v9 * 2 % v11.StudsPerTileU
    end
    if tick() >= p8._next_update then
        p8._next_update = tick() + 0.03
        p8._frame = p8._frame % #v_u_3 + 1
        for _, v12 in pairs(p8._snowflakes) do
            v12.Texture = v_u_3[p8._frame]
        end
    end
end
function v_u_4._Setup(p13)
    for _, v14 in pairs(p13.ExtraObjects) do
        if v14.Name == "TopArrows" then
            local v15 = p13._arrows1
            table.insert(v15, v14)
        elseif v14.Name == "BottomArrows" then
            local v16 = p13._arrows2
            table.insert(v16, v14)
        elseif v14.Name == "Snowflake" then
            local v17 = p13._snowflakes
            table.insert(v17, v14)
        end
    end
end
function v_u_4._Init(p18)
    p18:_Setup()
end
return v_u_4