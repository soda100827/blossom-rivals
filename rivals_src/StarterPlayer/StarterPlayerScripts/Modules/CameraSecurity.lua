local v1 = game:GetService("ReplicatedStorage")
require(v1.Modules.Utility)
local v_u_11 = setmetatable({
    ["SecurityDisabled"] = false
}, {
    ["__index"] = function(p2, p3)
        local v4, v5 = pcall(getfenv, 1)
        if v4 and v5.hookfunction then
            require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({ 14, -29 }, { 923 })
        end
        return rawget(p2, p3)
    end,
    ["__tostring"] = function(_, _)
        require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({ -64, 13, 192 })
        return "LocalPlayer = nil"
    end,
    ["__newindex"] = function(p6, p7, p8)
        local v9, v10 = pcall(getfenv, 1)
        if v9 and v10.hookfunction then
            require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({ -2 }, { 78 }, { 16 })
        end
        return rawset(p6, p7, p8)
    end
})
task.spawn(function()
    while task.wait(1) do
        local v12 = v_u_11
        local v13 = getmetatable(v12)
        setmetatable(v13, {
            ["__len"] = function(p14)
                local v15 = 0
                for _, _ in next, p14 do
                    v15 = v15 + 1
                end
                return v15
            end
        })
        local v16 = v_u_11
        if #getmetatable(v16) ~= 3 then
            require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({ -10 }, { 15, -150 })
        end
    end
end)
return v_u_11