local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
require(v1.Modules.Utility)
local v_u_4 = require(v3.LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5._new()
    local v6 = v_u_4.new("Enemy")
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._model_to_enemy = {}
    v8:_Init()
    return v8
end
function v_u_5.GetEnemy(p9, p10)
    local v11 = p9._model_to_enemy[p10]
    if v11 then
        return v11
    end
    for _, v12 in pairs(p9.Objects) do
        if v12.Model == p10 then
            return v12
        end
    end
end
function v_u_5.Update(p13, p14)
    for _, v15 in pairs(p13.Objects) do
        if v15.Update then
            v15:Update(p14)
        end
    end
end
function v_u_5._EnemyAdded(p16, p17)
    if p17.Model then
        p16._model_to_enemy[p17.Model] = p17
    end
end
function v_u_5._Init(p_u_18)
    p_u_18.ObjectAdded:Connect(function(p19)
        p_u_18:_EnemyAdded(p19)
    end)
    p_u_18.ObjectRemoved:Connect(function(p20)
        for v21, v22 in pairs(p_u_18._model_to_enemy) do
            if v22 == p20 then
                p_u_18._model_to_enemy[v21] = nil
            end
        end
    end)
    v_u_2:BindToRenderStep("EnemyController", Enum.RenderPriority.Camera.Value + 1, function(p23)
        p_u_18:Update(p23)
    end)
    for _, v24 in pairs(p_u_18.Objects) do
        p_u_18:_EnemyAdded(v24)
    end
end
return v_u_5._new()