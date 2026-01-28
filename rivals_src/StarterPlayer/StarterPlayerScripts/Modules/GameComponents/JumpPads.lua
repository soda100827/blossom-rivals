local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("RunService")
local v4 = game:GetService("Players")
local v_u_5 = require(v2.Modules.Utility)
local v_u_6 = require(v4.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_7 = require(v4.LocalPlayer.PlayerScripts.Controllers.WrapController)
local v_u_8 = v4.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("JumpPads")
local v_u_9 = {
    ["Default"] = { "rbxassetid://85163949920258", 1 },
    ["Trampoline"] = { "rbxassetid://75001064846226", 1 },
    ["Bounce House"] = { "rbxassetid://139519788113881", 1 },
    ["Shady Chicken Sandwich"] = { "rbxassetid://99488347318534", 1.25 },
    ["Spider Web"] = { "rbxassetid://88449856112147", 1.25 },
    ["Jolly Man"] = { "rbxassetid://111488886881644", 1.5 }
}
local v_u_10 = {
    ["Default"] = { "rbxassetid://17835965985", 1 },
    ["Trampoline"] = { "rbxassetid://79142560912255", 1 },
    ["Bounce House"] = { "rbxassetid://18963214636", 1 },
    ["Shady Chicken Sandwich"] = { "rbxassetid://138205332923098", 1.25 },
    ["Spider Web"] = { "rbxassetid://128812513158754", 1.25 },
    ["Jolly Man"] = { "rbxassetid://130086876465618", 1 }
}
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11._new()
    local v12 = v_u_11
    local v13 = setmetatable({}, v12)
    v13:_Init()
    return v13
end
function v_u_11.CreateJumpPadVisual(_, p14, p15)
    local v16 = (v_u_8:FindFirstChild(p14 or "Default") or v_u_8.Default):Clone()
    v16:ScaleTo(v16:GetScale() * p15.X / 10)
    for _, v17 in pairs(v16:GetDescendants()) do
        if v17:IsA("BasePart") then
            v17.Anchored = true
            v17.CanCollide = false
            v17.CanTouch = false
            v17.CanQuery = false
            v17.Massless = true
        end
    end
    return v16
end
function v_u_11._GetWrap(_, p18)
    for _, v19 in pairs(v_u_6.Objects) do
        local v20 = v19:GetItem(p18)
        if v20 then
            return v20:GetWrap()
        end
    end
end
function v_u_11._ObjectAdded(p21, p22)
    local v23 = p22:GetAttribute("ViewModelName")
    local v24 = p22:GetAttribute("ObjectID")
    local v25 = v_u_10[v23] or v_u_10.Default
    local v26 = v_u_9[v23] or v_u_9.Default
    p22:SetAttribute("SoundID", v25[1])
    p22:SetAttribute("SoundVolume", v25[2])
    v_u_5:CreateSound(v26[1], v26[2], 1.25, p22, true, 5)
    local v27 = p21:CreateJumpPadVisual(v23, p22.Size)
    v27.Parent = p22
    local v28 = p21:_GetWrap(v24)
    if v28 then
        v_u_7:ApplyWrap(v_u_7:RecordOriginalWrapProperties(v27), v28, true)
    end
    local v29 = v27:GetScale() * 1.25
    local v30 = v27:GetScale()
    local v31 = CFrame.Angles(0, 0, 0.17453292519943295 * (math.random() - 0.5))
    local v32 = tick()
    while tick() < v32 + 0.25 do
        local v33 = 1 - (1 - (tick() - v32) / 0.25) ^ 3
        v27:ScaleTo(v29 + (v30 - v29) * v33)
        v27:PivotTo(p22:GetPivot() * CFrame.new(0, 0, p22.Size.Z / 2) * v31:Lerp(CFrame.identity, v33))
        v_u_3.RenderStepped:Wait()
    end
    v27:ScaleTo(v30)
    v27:PivotTo(p22:GetPivot() * CFrame.new(0, 0, p22.Size.Z / 2))
    for _, v34 in pairs(v27:GetDescendants()) do
        if v34:IsA("BasePart") then
            local v35 = Instance.new("WeldConstraint")
            v35.Part0 = p22
            v35.Part1 = v34
            v35.Parent = v34
            v34.Anchored = false
        end
    end
end
function v_u_11._Init(p_u_36)
    v_u_1:GetInstanceAddedSignal("JumpPadHitbox"):Connect(function(p37)
        p_u_36:_ObjectAdded(p37)
    end)
    for _, v38 in pairs(v_u_1:GetTagged("JumpPadHitbox")) do
        task.defer(p_u_36._ObjectAdded, p_u_36, v38)
    end
end
return v_u_11._new()