local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.BetterDebris)
require(v1.Modules.Spring)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.ItemTypes.Throwable)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6._Init(p_u_10)
    p_u_10.ProjectileThrown:Connect(function(p11, p12)
        local v13 = Instance.new("Highlight")
        v13.FillColor = Color3.fromRGB(255, 0, 0)
        v13.OutlineTransparency = 1
        v13.FillTransparency = 0
        v13.DepthMode = Enum.HighlightDepthMode.Occluded
        v13.Adornee = p12
        v13.Parent = p12
        v_u_4:AddItem(v13, 10)
        local v14 = Random.new()
        local v15 = tick()
        while p11:IsDescendantOf(workspace) do
            local v16 = (tick() - v15) / p_u_10.Info.DetonateDelay
            local v17 = math.min(1, v16)
            local v18 = v14:NextUnitVector() * 0.25 * v17 ^ 4
            p12.WorldPivot = p12.Primary.CFrame + v18
            v13.FillTransparency = 1 - v17 ^ 4 / 2
            v_u_2.RenderStepped:Wait()
        end
        v13:Destroy()
    end)
end
return v_u_6