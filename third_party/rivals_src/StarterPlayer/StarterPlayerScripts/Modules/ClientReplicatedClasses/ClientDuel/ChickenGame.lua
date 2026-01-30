local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Lighting")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.ClientDuel = p6
    v8._cc = Instance.new("ColorCorrectionEffect")
    v8._red_light_hash = 0
    v8._jingle_sfx = nil
    v8:_Init()
    return v8
end
function v_u_5.RedLight(p_u_9, p10, p11)
    p_u_9._red_light_hash = p_u_9._red_light_hash + 1
    local v_u_12 = p_u_9._red_light_hash
    p_u_9._cc.Contrast = 0
    p_u_9._cc.Saturation = 0
    p_u_9._cc.TintColor = Color3.fromRGB(255, 255, 255)
    p_u_9._cc.Parent = v_u_3
    local v13 = tick()
    while tick() < v13 + p10 do
        local v14 = (tick() - v13) / p10
        local v15 = math.clamp(v14, 0, 1) ^ 4
        p_u_9._cc.Contrast = 0
        p_u_9._cc.Saturation = 0
        p_u_9._cc.TintColor = Color3.fromRGB(255, 255, 255):Lerp(Color3.fromRGB(255, 127, 127), v15)
        v_u_2.RenderStepped:Wait()
        if v_u_12 ~= p_u_9._red_light_hash then
            return
        end
    end
    p_u_9._cc.Contrast = 0
    p_u_9._cc.Saturation = 0
    p_u_9._cc.TintColor = Color3.fromRGB(255, 0, 0)
    p_u_9.ClientDuel.DuelInterface:CreateSound("rbxassetid://115599786018668", 0.5, 0.875, script, true, 5)
    local v16 = tick()
    v_u_4:RenderstepForLoop(0, 100, 4, function(p17)
        if v_u_12 ~= p_u_9._red_light_hash then
            return true
        end
        local v18 = (p17 / 100) ^ 2
        p_u_9._cc.Contrast = 1 + -1 * v18
        p_u_9._cc.Saturation = 1 + -1 * v18
        p_u_9._cc.Brightness = 0.25 + -0.25 * v18
    end)
    wait(p11 - (tick() - v16))
    if v_u_12 == p_u_9._red_light_hash then
        p_u_9._cc.Parent = nil
    end
end
function v_u_5.GreenLight(p_u_19, p20, p21, p22)
    p_u_19._red_light_hash = p_u_19._red_light_hash + 1
    local v_u_23 = p_u_19._red_light_hash
    if p20 then
        p_u_19.ClientDuel.DuelInterface:CreateSound("rbxassetid://115599786018668", 0.25, 2, script, true, 5)
        p_u_19._jingle_sfx = p_u_19.ClientDuel.DuelInterface:CreateSound("rbxassetid://81396691367613", 0.25, 5 / p20, script, true, 10)
        p_u_19._cc.Contrast = 1
        p_u_19._cc.Saturation = 0.5
        p_u_19._cc.TintColor = Color3.fromRGB(100, 255, 50)
        local v24 = p_u_19._cc
        local v25
        if p22 then
            v25 = nil
        else
            v25 = v_u_3 or nil
        end
        v24.Parent = v25
        local v26 = tick()
        wait(0.25)
        v_u_4:RenderstepForLoop(0, 100, 4, function(p27)
            if v_u_23 ~= p_u_19._red_light_hash then
                return true
            end
            local v28 = 1 - (1 - p27 / 100) ^ 2
            p_u_19._cc.Contrast = 1 + -1 * v28
            p_u_19._cc.Saturation = 0.5 + -0.5 * v28
            p_u_19._cc.TintColor = Color3.fromRGB(100, 255, 50):Lerp(Color3.fromRGB(255, 255, 255), v28)
        end)
        if v_u_23 == p_u_19._red_light_hash then
            p_u_19._cc.Parent = nil
            p_u_19:RedLight(p20 - (tick() - v26), p21)
        end
    else
        p_u_19._cc.Parent = nil
        return
    end
end
function v_u_5.Stop(p29)
    if p29._jingle_sfx then
        p29._jingle_sfx:Destroy()
        p29._jingle_sfx = nil
    end
end
function v_u_5.Elimination(p30)
    p30.ClientDuel.DuelInterface:CreateSound("rbxassetid://13270206222", 1, 1.25 + 0.5 * math.random(), script, true, 5)
    p30.ClientDuel.DuelInterface:CreateSound("rbxassetid://13270206087", 1, 1.25 + 0.5 * math.random(), script, true, 5)
end
function v_u_5.Destroy(p31)
    p31._red_light_hash = p31._red_light_hash + 1
    p31._cc:Destroy()
end
function v_u_5._Init(p_u_32)
    p_u_32.ClientDuel:GetDataChangedSignal("IsSpectating"):Connect(function()
        if not p_u_32.ClientDuel:Get("IsSpectating") then
            p_u_32._cc.Parent = nil
        end
    end)
end
return v_u_5