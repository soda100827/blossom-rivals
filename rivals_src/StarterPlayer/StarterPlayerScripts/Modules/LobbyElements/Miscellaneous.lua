local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4._new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.Update(p8, _)
    local v9 = tick() * 0.25
    local v10 = math.sin(v9) ^ 30 * 1
    local v11 = tick() * 0.1 % 6.283185307179586
    local v12 = Vector3.new(0, v10, 0)
    local v13 = CFrame.Angles(0, v11, 0)
    for _, v14 in pairs(v_u_1:GetTagged("LobbyFloatingDisplay")) do
        if v14:IsDescendantOf(workspace) then
            local v15 = p8:_GetOriginalPivot(v14)
            local v16
            if v14:GetAttribute("NoSpin") then
                v16 = CFrame.identity or v13
            else
                v16 = v13
            end
            v14:PivotTo(v15 * v16 + v12)
        end
    end
    for _, v17 in pairs(v_u_1:GetTagged("LobbyRing")) do
        local v18 = v17:GetAttribute("Multiplier") or 1
        local v19 = v17:GetAttribute("IsGlobalSpace") or false
        local v20 = p8:_GetOriginalPivot(v17)
        local v21 = CFrame.Angles(0, tick() * 0.1 * v18 % 6.283185307179586, 0)
        if v19 then
            v17:PivotTo(CFrame.new(v20.Position) * v21 * v20.Rotation)
        else
            v17:PivotTo(v20 * v21)
        end
    end
    for _, v22 in pairs(v_u_1:GetTagged("LobbyHologramGift")) do
        local v23 = tick() * 0.75
        local v24 = math.sin(v23) ^ 30 * 1
        local v25 = tick() * -0.2 % 6.283185307179586
        v22:PivotTo(p8:_GetOriginalPivot(v22) * CFrame.new(0, v24, 0) * CFrame.Angles(0, v25, 0))
    end
    for _, v26 in pairs(v_u_1:GetTagged("LobbyHologramMobile")) do
        v26.Earth:PivotTo(p8:_GetOriginalPivot(v26.Earth) * CFrame.Angles(0, tick() * 0.35 % 6.283185307179586, 0))
        local v27 = v26.Phone
        local v28 = p8:_GetOriginalPivot(v26.Phone)
        local v29 = tick() * 0.75
        local v30 = math.sin(v29) * 0.75
        v27:PivotTo(v28 + Vector3.new(0, v30, 0))
        local v31 = v26.Tablet
        local v32 = p8:_GetOriginalPivot(v26.Tablet)
        local v33 = tick() * 0.375
        local v34 = math.cos(v33)
        v31:PivotTo(v32 + Vector3.new(0, v34, 0))
    end
end
function v_u_4._Init(_) end
return v_u_4._new()