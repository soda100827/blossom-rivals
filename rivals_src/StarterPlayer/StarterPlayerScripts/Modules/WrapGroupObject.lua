local v_u_1 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2.new(p3, p4)
    local v5 = v_u_2
    local v6 = setmetatable({}, v5)
    v6.Object = p3
    v6.ExtraObjects = p4
    v6.IsDestroyed = nil
    v6._cleanup = {}
    v6._connections = {}
    v6:_Init()
    return v6
end
function v_u_2.IsActive(p7)
    return p7.Object:IsDescendantOf(workspace) or p7.Object:IsDescendantOf(v_u_1)
end
function v_u_2.Destroy(p8)
    if not p8.IsDestroyed then
        p8.IsDestroyed = true
        for _, v9 in pairs(p8._connections) do
            v9:Disconnect()
        end
        for _, v10 in pairs(p8._cleanup) do
            v10:Destroy()
        end
        p8._connections = {}
        p8._cleanup = {}
    end
end
function v_u_2._Init(p_u_11)
    p_u_11.Object.Destroying:Connect(function()
        p_u_11:Destroy()
    end)
end
return v_u_2