local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.BetterDebris)
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild("Riot Shield"))
local v_u_4 = {
    { "rbxassetid://105059726931047", "rbxassetid://79914271483818" },
    { "rbxassetid://77461546699017", "rbxassetid://76552313877907" }
}
local v_u_5 = setmetatable({}, v_u_3)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_3.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._painting_data = v_u_4[math.random(#v_u_4)]
    v8:_Init()
    return v8
end
function v_u_5.GetImage(p9)
    return p9._painting_data[2]
end
function v_u_5.AbsorbedHit(p10)
    p10:CreateSound("rbxassetid://134671375134755", 1, 0.9 + 0.2 * math.random(), true, 5)
end
function v_u_5._Setup(p11)
    p11.ItemModel:WaitForChild("Body"):WaitForChild("Canvas"):WaitForChild("Decal").Texture = p11._painting_data[1]
end
function v_u_5._Init(p12)
    p12:_Setup()
end
return v_u_5