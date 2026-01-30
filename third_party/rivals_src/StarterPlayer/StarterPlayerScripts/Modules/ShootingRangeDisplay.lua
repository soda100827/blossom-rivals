local v_u_1 = game:GetService("Players")
local v_u_2 = require(v_u_1.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_3 = require(v_u_1.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local v_u_4 = v_u_1.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ShootingRangeGui")
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.SurfaceGui = v_u_4:Clone()
    v8._part = p6
    v8._connections = {}
    v8._is_enabled = false
    v8._teammate_slots = {}
    v8:_Init()
    return v8
end
function v_u_5.SetEnabled(p_u_9, p10)
    if p10 == p_u_9._is_enabled then
        return
    else
        for _, v11 in pairs(p_u_9._connections) do
            v11:Disconnect()
        end
        p_u_9._connections = {}
        p_u_9._is_enabled = p10
        if p_u_9._is_enabled then
            local v12 = p_u_9._connections
            local v13 = v_u_2.ObjectRemoved
            table.insert(v12, v13:Connect(function()
                p_u_9:_GeneratePlayers()
            end))
            local v14 = p_u_9._connections
            local v15 = v_u_2.ObjectAdded
            table.insert(v14, v15:Connect(function(p16, p17)
                local v18 = p_u_9._connections
                local v19 = p16:GetDataChangedSignal("IsInShootingRange")
                local function v20()
                    p_u_9:_GeneratePlayers()
                end
                table.insert(v18, v19:Connect(v20))
                if not p17 then
                    p_u_9:_GeneratePlayers()
                end
            end))
            for _, v21 in pairs(v_u_2.Objects) do
                local v22 = p_u_9._connections
                local v23 = v21:GetDataChangedSignal("IsInShootingRange")
                table.insert(v22, v23:Connect(function()
                    p_u_9:_GeneratePlayers()
                end))
            end
            p_u_9:_GeneratePlayers()
        else
            p_u_9:_GeneratePlayers()
        end
    end
end
function v_u_5.Destroy(p24)
    p24:SetEnabled(false)
    p24.SurfaceGui:Destroy()
end
function v_u_5._GeneratePlayers(p25)
    for _, v26 in pairs(p25._teammate_slots) do
        v26:Destroy()
    end
    p25._teammate_slots = {}
    p25.SurfaceGui.Title.Position = UDim2.new(0.5, 0, 0.5, 0)
    p25.SurfaceGui.Title.Size = UDim2.new(0.25, 0, 0.4, 0)
    if p25._is_enabled then
        for _, v27 in pairs(v_u_2.Objects) do
            if v27:Get("IsInShootingRange") then
                local v28 = v27.Player:GetAttribute("StatisticDuelsWinStreak") or 0
                local v29 = v_u_3.new(v27.Player.UserId, v27:Get("Controls"), 1, false, false, v28, v27.Player:GetAttribute("Level"))
                v29.SlotFrame.LayoutOrder = -v28
                v29.SlotFrame.Parent = p25.SurfaceGui.Players
                local v30 = p25._teammate_slots
                table.insert(v30, v29)
            end
        end
        if #p25._teammate_slots > 0 then
            p25.SurfaceGui.Title.Position = UDim2.new(0.5, 0, 0.375, 0)
            p25.SurfaceGui.Title.Size = UDim2.new(0.5, 0, 0.1, 0)
        end
    end
end
function v_u_5._Setup(p31)
    p31.SurfaceGui.Adornee = p31._part
    p31.SurfaceGui.Parent = v_u_1.LocalPlayer.PlayerGui
end
function v_u_5._Init(p32)
    p32:_Setup()
end
return v_u_5