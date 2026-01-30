local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finisher)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayServer(p8)
    p8:_AnchorModel(0)
end
function v_u_4.PlayClient(p_u_9, ...)
    local v_u_10 = p_u_9._is_humanoid and p_u_9._subject.RootPart or p_u_9._subject
    local v_u_11 = script.Model:Clone()
    v_u_11.Parent = workspace
    local v12 = p_u_9._destroy_these
    table.insert(v12, v_u_11)
    p_u_9:CreateSound("rbxassetid://91581971640099", 1.5, 1, nil, true, 5)
    p_u_9:CreateSound("rbxassetid://17812496122", 0.5, 1.25 + 0.25 * math.random(), nil, true, 5)
    p_u_9:CreateSound("rbxassetid://17812566721", 2, 1 + 0.2 * math.random(), nil, true, 5)
    p_u_9:_InternalThread(task.spawn, function()
        wait(0.25)
        p_u_9:CreateSound("rbxassetid://18128895977", 2, 1, nil, true, 5)
        wait(0.25)
        local v13 = p_u_9._is_humanoid and p_u_9._subject.Parent or p_u_9._subject
        for _, v14 in pairs(v13:GetDescendants()) do
            if v14:IsA("BasePart") then
                v14.Transparency = 1
            elseif v14:IsA("ParticleEmitter") or (v14:IsA("Beam") or (v14:IsA("Trail") or v14:IsA("Decal"))) then
                v14:Destroy()
            end
        end
    end)
    local v_u_15 = (Random.new():NextUnitVector() * Vector3.new(1, 0, 1)).Unit * 30
    local v_u_16 = nil
    v_u_3:RenderstepForLoop(0, 100, 2, function(p17)
        local v18 = p17 / 100
        local v19 = 3.141592653589793 * v18
        local v20 = math.sin(v19)
        local v21
        if v18 < 0.5 then
            v21 = v_u_15:Lerp(Vector3.new(0, 0, 0), v18 * 2)
        else
            v21 = (Vector3.new(0, 0, 0)):Lerp(-v_u_15, v18 * 2 - 1)
        end
        local v22 = CFrame.new(v_u_10.Position) + (Vector3.new(0, -30, 0)):Lerp(Vector3.new(0, 0, 0), v20) + v21
        if v_u_16 and not v_u_16:FuzzyEq(v22.Position) then
            v22 = CFrame.new(v22.Position, v_u_16) * CFrame.Angles(1.5707963267948966, 0, 0)
        end
        v_u_11:PivotTo(v22)
        v_u_16 = v22.Position
    end)
    v_u_11:Destroy()
end
function v_u_4._Init(_) end
return v_u_4