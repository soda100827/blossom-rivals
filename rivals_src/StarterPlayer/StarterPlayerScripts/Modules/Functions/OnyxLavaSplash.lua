local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("OnyxLavaSplash")
return function(p6, p7, p8)
    local v9 = v_u_4:Raycast(p7, p7 - Vector3.new(0, 1, 0), 500, { p6 }, Enum.RaycastFilterType.Include)
    if v9.Instance then
        p7 = v9.Position
    end
    local v10 = v_u_5:Clone()
    v10.Size = Vector3.new(1, 1, 1)
    v10.CanCollide = true
    v10.CollisionGroup = "IgnoreEntities"
    v10.CFrame = CFrame.new(p7)
    v10.Parent = workspace
    v10.Attachment.LavaDroplets.Color = ColorSequence.new(p6.Color)
    v10.Attachment.LavaDroplets:Emit(25)
    v_u_3:AddItem(v10, 5)
    v_u_4:CreateSound(p8 or "rbxassetid://12100798607", 1, 1 + 0.25 * math.random(), v10, true, 5)
end