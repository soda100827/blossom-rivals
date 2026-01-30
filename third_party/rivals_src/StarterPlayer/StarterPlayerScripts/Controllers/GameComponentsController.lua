game:GetService("ReplicatedStorage")
local v_u_1 = game:GetService("RunService")
local v_u_2 = game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("GameComponents")
local v_u_3 = {
    "FlickeringLights",
    "SmokeClouds",
    "FireHitboxes",
    "CustomKnockbackParts",
    "UISparkleEffects",
    "UILoadingDots",
    "UIBackgrounds",
    "UIInputFrames",
    "UIKeybinds",
    "OpenPagePrompts",
    "SnowballPrompts",
    "OutOfBoundsParts",
    "UserIDsFilter",
    "JumpPads",
    "SubspaceTripmines",
    "UIShinyTexts",
    "UIGlitchEffects",
    "PortalModels",
    "Vortexes",
    "OneWayFloors"
}
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4._new()
    local v5 = v_u_4
    local v6 = setmetatable({}, v5)
    v6.Components = {}
    v6:_Init()
    return v6
end
function v_u_4._Setup(p_u_7)
    for _, v_u_8 in pairs(v_u_3) do
        task.spawn(function()
            p_u_7.Components[v_u_8] = require(v_u_2:WaitForChild(v_u_8))
        end)
    end
end
function v_u_4._Init(p_u_9)
    v_u_1:BindToRenderStep("GameComponentsController", 1, function(p10)
        for _, v11 in pairs(p_u_9.Components) do
            if v11.Update then
                v11:Update(p10)
            end
        end
    end)
    p_u_9:_Setup()
end
return v_u_4._new()