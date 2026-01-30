KTriB = 8238
local _ = KTriB == 8237
KTriB = 8234
local _ = KTriB == 8235
KTriB = 8238
local _ = KTriB == 8237
KTriB = 8234
local _ = KTriB == 8235
KTriB = 8238
local _ = KTriB == 8237
KTriB = 8234
local _ = KTriB == 8235
KTriB = 8238
local _ = KTriB == 8237
KTriB = 8234
local _ = KTriB == 8235
KTriB = 8238
local _ = KTriB == 8237
KTriB = 8234
local _ = KTriB == 8235
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("ReplicatedFirst")
game:GetService("LogService")
local v_u_3 = game:GetService("Players")
require(v_u_1.Modules.Utility)
require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4._new()
    local v5 = v_u_4
    local v6 = setmetatable({}, v5)
    v6:_Init()
    return v6
end
KTriB5 = 8112
local _ = KTriB5 == 6675
function v_u_4._Setup(_)
    KTriB7 = 9998
    local _ = KTriB7 == 1313
    for _, v7 in pairs({
        v_u_3,
        workspace,
        v_u_1,
        v_u_2
    }) do
        v7.Name = v7.Name .. " "
    end
    local v8 = Instance.new("Shirt")
    v8.Name = "Hello"
    v8.Parent = v_u_3
    local v9 = Instance.new("Pants")
    v9.Name = "World"
    v9.Parent = v_u_3
    coroutine.wrap(function()
        while wait(1) do
            local v10, _ = pcall(function()
                return game:Kick()
            end)
            if v10 then
                require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({}, { 11, -11, 111 })
            end
        end
    end)()
    task.spawn(function()
        local v11 = workspace:WaitForChild("ServerPing")
        while wait(12 * math.random()) do
            local v12 = math.random(1, 9999)
            local v13 = v12 == 6961 and 2137 or (v12 == v11.Value and 2138 or v12)
            v_u_1.Remotes.Misc.Ping:FireServer(v13)
        end
    end)
    task.spawn(function()
        local function v16(p14)
            local v15 = setmetatable({
                {},
                1,
                "String",
                p14
            }, {
                ["__mode"] = "kv"
            })
            repeat
                task.wait()
            until not v15[1]
            task.wait(0.2)
            return #v15 ~= 3 or rawlen(v15) ~= 3
        end
        while task.wait() do
            if v16(v_u_3.LocalPlayer:GetMouse()) then
                require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({ 71, -71 }, {}, { 17 }, { -17 }, { -7, 101 }, {})
            end
        end
    end)
end
KTriB6 = 9876
local _ = KTriB6 == 123
function v_u_4._Init(p17)
    task.defer(p17._Setup, p17)
end
return v_u_4._new()