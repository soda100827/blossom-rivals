local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Modules.Utility)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7._new()
    local v8 = v_u_7
    local v9 = setmetatable({}, v8)
    v9._shady_chicken_enabled = false
    v9:_Init()
    return v9
end
function v_u_7._UpdateChickenState(p10, p_u_11)
    if p10._shady_chicken_enabled or not v_u_5:Get("ShadyChickenMissionStarted") then
        return
    else
        local v_u_12 = v_u_2:GetTagged("LobbyShadyChicken")[1]
        if v_u_12 then
            p10._shady_chicken_enabled = true
            task.defer(function()
                v_u_4:RenderstepForLoop(0, 100, p_u_11 and 100 or 1, function(p13)
                    local v14 = p13 / 100
                    for v15 = 1, 3 do
                        v_u_12:WaitForChild("Hologram"):WaitForChild("Neon"):WaitForChild(v15).LocalTransparencyModifier = v14
                    end
                end)
            end)
            if not p_u_11 then
                v_u_4:CreateSound("rbxassetid://92573395473684", 1, 1, script, true, 10)
                for v16 = 1, 14 do
                    local v17 = string.rep("\226\128\162", v16 - 1) .. string.sub("ILOVERIVALS628", v16, v16)
                    v_u_12:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild("LoginScreen"):WaitForChild("LoginWindow"):WaitForChild("Login"):WaitForChild("Title").Text = v17
                    wait(0.1847857142857143)
                end
                v_u_12:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild("LoginScreen"):WaitForChild("LoginWindow").Visible = false
                v_u_12:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild("LoginScreen"):WaitForChild("Dots").Visible = true
                v_u_12:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild("LoginScreen"):WaitForChild("Dots"):AddTag("UILoadingDots")
                wait(4)
                v_u_4:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
                v_u_4:CreateSound("rbxassetid://85855678277731", 1.5, 1, script, true, 5)
            end
            v_u_12:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild("LoginScreen"):WaitForChild("Dots"):RemoveTag("UILoadingDots")
            v_u_12:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild("LoginScreen").Visible = false
            v_u_12:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild("ErrorScreen").Visible = true
            v_u_12:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceLight").Color = Color3.fromRGB(255, 50, 50)
            v_u_12:WaitForChild("Pad"):WaitForChild("Part"):WaitForChild("SurfaceGui"):WaitForChild("ImageLabel").ImageColor3 = Color3.fromRGB(255, 50, 50)
            if not p_u_11 then
                task.spawn(v_u_4.RenderstepForLoop, v_u_4, 0, 100, 2, function(p18)
                    local v19 = 40 * (1 - (p18 / 100) ^ 2)
                    local v20 = UDim2.new(0.5, v19 * (math.random() - 0.5), 0.5, v19 * 0.25 * (math.random() - 0.5))
                    v_u_12:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild("ErrorScreen"):WaitForChild("LoginWindow").Position = v20
                end)
                wait(1.5)
            end
            pcall(function()
                v_u_12:WaitForChild("Rig"):WaitForChild("Humanoid"):LoadAnimation(v_u_6:GetPreloadedAnimation("ShadyChickenIdle")):Play(0)
            end)
            v_u_12:WaitForChild("Vent"):WaitForChild("Broken").Transparency = 0
            v_u_12:WaitForChild("Vent"):WaitForChild("NotBroken"):Destroy()
            if not p_u_11 then
                v_u_4:PlayParticles(v_u_12:WaitForChild("Vent"):WaitForChild("VFX"))
                v_u_4:CreateSound("rbxassetid://73297732048740", 2, 1, script, true, 10)
                v_u_4:CreateSound("rbxassetid://122754850804619", 1, 1, script, true, 10)
                pcall(function()
                    v_u_12:WaitForChild("Rig"):WaitForChild("Humanoid"):LoadAnimation(v_u_6:GetPreloadedAnimation("ShadyChickenAppear")):Play(0)
                end)
                wait(2)
                wait(5)
            end
            v_u_12:WaitForChild("Prompt"):WaitForChild("ProximityPrompt").MaxActivationDistance = 16
        end
    end
end
function v_u_7._ChickenAdded(_, p_u_21)
    pcall(function()
        p_u_21:WaitForChild("Rig"):WaitForChild("Humanoid"):LoadAnimation(v_u_6:GetPreloadedAnimation("ShadyChickenIdleVent")):Play(0)
    end)
end
function v_u_7._UpdateLoginPrompts(_)
    local v22 = v_u_5:Get("ShadyChickenMissionStarted") and 0 or 16
    for _, v23 in pairs(v_u_2:GetTagged("LobbyShadyChickenPrompt")) do
        v23.MaxActivationDistance = v22
    end
end
function v_u_7._LoginPromptAdded(p24, p25)
    p25.Triggered:Connect(function()
        v_u_1.Remotes.Misc.StartShadyChickenMission:FireServer()
    end)
    p24:_UpdateLoginPrompts()
end
function v_u_7._Init(_) end
return v_u_7._new()