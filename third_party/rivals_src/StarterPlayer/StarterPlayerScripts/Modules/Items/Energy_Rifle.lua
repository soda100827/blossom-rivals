local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5._ImpactMarker(p9, p10)
    local v11 = {
        ["Color"] = Color3.fromRGB(0, 0, 0),
        ["NoTween"] = true
    }
    return v_u_4._ImpactMarker(p9, p10, v11)
end
function v_u_5._Tracers(p12, p13)
    local v_u_14 = {}
    local v29 = {
        ["MaxLength"] = (1 / 0),
        ["MaxLengthFirstPerson"] = (1 / 0),
        ["NoDistanceDelay"] = true,
        ["PlayFlyBySound"] = function(p15, p16, p17)
            v_u_3:CreateSound("rbxassetid://14767954026", 1 * p16, 1.4 + 0.2 * math.random(), p15, true, 10, p17, p17)
            v_u_3:CreateSound("rbxassetid://17640978498", 0.15 * p16, 1.25 + 0.25 * math.random(), p15, true, 10, p17, p17)
        end,
        ["Template"] = p12.ViewModel:GetTracerTemplate(),
        ["InitCallback"] = function(p18, p19)
            for _, v20 in pairs(p18:GetDescendants()) do
                if v20:IsA("Beam") then
                    v20.Width1 = p19 == 1 and 0 or v20.Width1
                    v_u_14[v20] = {
                        ["IsBeam"] = true,
                        ["Width0"] = v20.Width0,
                        ["Width1"] = v20.Width1
                    }
                elseif v20:IsA("Light") then
                    v_u_14[v20] = {
                        ["IsLight"] = true,
                        ["Brightness"] = v20.Brightness
                    }
                end
            end
        end,
        ["CustomUpdate"] = function(_, p21, p22, p23, p24, p25)
            p22.WorldPosition = p24
            p21.WorldPosition = p25
            local v26 = 1 - p23 ^ 3
            for v27, v28 in pairs(v_u_14) do
                if v28.IsBeam then
                    v27.Width0 = v28.Width0 * v26
                    v27.Width1 = v28.Width1 * v26
                elseif v28.IsLight then
                    v27.Brightness = v28.Brightness * v26
                end
            end
        end,
        ["UpdateSpeed"] = 5
    }
    return v_u_4._Tracers(p12, p13, v29)
end
function v_u_5._Init(_) end
return v_u_5