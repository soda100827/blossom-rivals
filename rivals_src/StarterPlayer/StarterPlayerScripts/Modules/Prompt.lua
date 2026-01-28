local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Signal)
local v_u_4 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Prompts")
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = typeof(p6) == "string"
    local v8 = "Argument 1 invalid, expected a string, got " .. tostring(p6)
    assert(v7, v8)
    local v9 = v_u_5
    local v10 = setmetatable({}, v9)
    v10.Closed = v_u_3.new()
    v10.OpenPrompt = v_u_3.new()
    v10.PromptFrame = v_u_4:WaitForChild(p6):Clone()
    v10._destroyed = false
    v10._connections = {}
    v10._destroy_these = {}
    v10:_Init()
    return v10
end
function v_u_5.GetDefaultElement(p11)
    return p11.CloseButton or nil
end
function v_u_5.CloseRequest(p12)
    p12.Closed:Fire()
end
function v_u_5.Open(p13, p14)
    local v15 = typeof(p14) == "Instance"
    local v16 = "Argument 1 invalid, expected an Instance, got " .. tostring(p14)
    assert(v15, v16)
    p13.PromptFrame.Parent = p14
    p13.PromptFrame.Position = UDim2.new(0.5, 0, 0.625, 0)
    p13.PromptFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Back", 0.25, true)
end
function v_u_5.Destroy(p17)
    if not p17._destroyed then
        p17._destroyed = true
        for _, v18 in pairs(p17._destroy_these) do
            v18:Destroy()
        end
        p17._destroy_these = {}
        for _, v19 in pairs(p17._connections) do
            v19:Disconnect()
        end
        p17._connections = {}
        p17.PromptFrame:Destroy()
        p17.Closed:Destroy()
        p17.OpenPrompt:Destroy()
    end
end
function v_u_5._Init(_) end
return v_u_5