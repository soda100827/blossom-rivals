local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.Finisher)
require(v1.Modules.Utility)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayServer(p8)
    p8:_AnchorModel(0, false)
    p8:_Ragdoll()
    local v9 = {}
    for _, v10 in pairs(p8:_GetObjects()) do
        if v10:IsA("BasePart") and (v10.Name ~= "Head" and v10.Name ~= "UpperTorso") then
            table.insert(v9, v10)
        end
    end
    local v11 = v9[math.random(#v9)]
    if v11 then
        p8:CreateSound("rbxassetid://130365736768706", 1.25, 1, nil, true, 5)
        p8:CreateSound("rbxassetid://95957584341529", 1.25, 2 + 0.25 * math.random(), nil, true, 5)
        local v12 = Instance.new("Attachment")
        v12.Parent = v11
        local v13 = p8._destroy_these
        table.insert(v13, v12)
        for _ = 1, 3 do
            local v14 = Random.new():NextUnitVector() * Vector3.new(1, 0, 1)
            local v15 = script.Balloon:Clone()
            v15.Color = Color3.fromHSV(math.random(), 1, 1)
            v15.CFrame = v11.CFrame + Vector3.new(0, 4, 0) + v14 * 2
            v15.RopeConstraint.Attachment1 = v12
            v15.Parent = v11
            local v16 = p8._destroy_these
            table.insert(v16, v15)
            if v_u_2.IS_SERVER then
                v15:SetNetworkOwner(nil)
            end
            wait(0.1)
        end
    end
end
function v_u_4._Init(_) end
return v_u_4