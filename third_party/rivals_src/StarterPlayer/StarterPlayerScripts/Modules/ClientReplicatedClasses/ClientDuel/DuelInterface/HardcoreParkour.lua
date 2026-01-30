local v1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.DuelLibrary)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_6 = v2.LocalPlayer.PlayerScripts.UserInterface.ParkourPlayerSlot
local v_u_7 = v1.Assets.Misc.ObbyGradient
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.DuelInterface = p9
    v11.Frame = v11.DuelInterface.Frame:WaitForChild("HardcoreParkour")
    v11.Container = v11.Frame:WaitForChild("Container")
    v11.ProgressFrame = v11.Container:WaitForChild("Progress")
    v11.ProgressContainer = v11.ProgressFrame:WaitForChild("Container")
    v11.BarFrame = v11.ProgressContainer:WaitForChild("Bar")
    v11.BarStroke = v11.BarFrame:WaitForChild("UIStroke")
    v11.DuelersFrame = v11.ProgressContainer:WaitForChild("Duelers")
    v11._destroyed = false
    v11._tasks = {}
    v11._connections = {}
    v11._slots = {}
    v11:_Init()
    return v11
end
function v_u_8.Update(p_u_12)
    local v13 = not p_u_12._destroyed and p_u_12.DuelInterface:IsActive() and not (p_u_12.DuelInterface.Scoreboard:IsOpen() or p_u_12.DuelInterface.Voting:IsOpen() or (v_u_5.PageSystem.CurrentPage or p_u_12.DuelInterface.RoundResult.Frame.Visible))
    if v13 then
        v13 = p_u_12.DuelInterface.ClientDuel:Get("Status") ~= "GameOver"
    end
    local v14 = p_u_12.DuelInterface.ClientDuel.Map
    if v14 then
        v14 = p_u_12.DuelInterface.ClientDuel.Map:Get("ObbyStartPosition")
    end
    local v15 = p_u_12.DuelInterface.ClientDuel.Map
    if v15 then
        v15 = p_u_12.DuelInterface.ClientDuel.Map:Get("ObbyFinishPosition")
    end
    if v14 then
        local v16
        if v15 then
            v16 = v13 and true or v13
        else
            v16 = v15
        end
    end
    if v16 == p_u_12.Frame.Visible then
        return
    else
        p_u_12:_Cleanup()
        p_u_12.Frame.Visible = v16
        if v16 then
            local v_u_17 = v14 * Vector3.new(1, 0, 1)
            local v_u_18 = (v_u_17 - v15 * Vector3.new(1, 0, 1)).Magnitude
            local function v_u_34(p19)
                local v20 = {}
                for _, v21 in pairs(p_u_12._slots) do
                    local v22 = v21.ClientDueler.ClientFighter and (v21.ClientDueler.ClientFighter.Entity and v21.ClientDueler.ClientFighter.Entity.RootPart)
                    if v22 then
                        v22 = v21.ClientDueler.ClientFighter.Entity.RootPart.Position
                    end
                    local v23
                    if v22 then
                        v23 = p_u_12.DuelInterface.ClientDuel:Get("Status") == "RoundStarting" and 0 or (v22 * Vector3.new(1, 0, 1) - v_u_17).Magnitude
                    else
                        v23 = nil
                    end
                    table.insert(v20, { v21, v23 })
                end
                table.sort(v20, function(p24, p25)
                    return (p24[2] or 0) < (p25[2] or 0)
                end)
                for v26, v27 in pairs(v20) do
                    local v28, v29 = table.unpack(v27)
                    v28.Slot.ZIndex = v26
                    if v29 then
                        local v30 = UDim2.new
                        local v31 = v29 / v_u_18
                        local v32 = v30(math.clamp(v31, 0, 1), 0, 0.5, 0)
                        local v33 = p19 == v28.ClientDueler and true or v32.X.Scale < v28.Slot.Position.X.Scale
                        if v33 then
                            v28.Slot.Position = v32
                        end
                        v28.Slot:TweenPosition(v32, "Out", "Linear", v33 and 0 or 1, true)
                    end
                end
            end
            local v35 = p_u_12._tasks
            local v36 = task.spawn
            table.insert(v35, v36(function()
                while true do
                    v_u_34()
                    wait(1)
                end
            end))
            local v37 = p_u_12._connections
            local v38 = p_u_12.DuelInterface.ClientDuel.DuelerRemoved
            table.insert(v37, v38:Connect(function(p39)
                if p_u_12._slots[p39.Player] then
                    p_u_12._slots[p39.Player].Slot:Destroy()
                    p_u_12._slots[p39.Player] = nil
                end
                v_u_34()
            end))
            local function v43(p40)
                if p_u_12._slots[p40.Player] then
                    p_u_12._slots[p40.Player].Slot:Destroy()
                    p_u_12._slots[p40.Player] = nil
                end
                v_u_34()
                local v41 = v_u_4:GetTeamColor(p40:Get("TeamID"))
                local v42 = v_u_6:Clone()
                v42.Container.Arrow.ImageColor3 = v41
                v42.Container.Background.ImageColor3 = v41
                v42.Size = p40.IsLocalDueler and UDim2.new(1, 0, 1, 0) or UDim2.new(0.75, 0, 0.75, 0)
                v42.Container.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, p40.Player.UserId)
                v42.Position = UDim2.new(0, 0, 0.5, 0)
                v42.Parent = p_u_12.DuelersFrame
                p_u_12._slots[p40.Player] = {
                    ["Slot"] = v42,
                    ["ClientDueler"] = p40
                }
                v_u_34(p40)
            end
            local v44 = p_u_12._connections
            local v45 = p_u_12.DuelInterface.ClientDuel.DuelerAdded
            table.insert(v44, v45:Connect(v43))
            for _, v46 in pairs(p_u_12.DuelInterface.ClientDuel.Duelers) do
                task.spawn(v43, v46)
            end
        end
    end
end
function v_u_8.Destroy(p47)
    p47._destroyed = true
    p47:_Cleanup()
end
function v_u_8._Cleanup(p48)
    for _, v49 in pairs(p48._tasks) do
        task.cancel(v49)
    end
    for _, v50 in pairs(p48._connections) do
        v50:Disconnect()
    end
    for _, v51 in pairs(p48._slots) do
        v51.Slot:Destroy()
    end
    p48._tasks = {}
    p48._connections = {}
    p48._slots = {}
end
function v_u_8._Setup(p52)
    v_u_7:Clone().Parent = p52.BarFrame
    v_u_7:Clone().Parent = p52.BarStroke
end
function v_u_8._Init(p_u_53)
    p_u_53.DuelInterface.RoundResult.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_53:Update()
    end)
    p_u_53.DuelInterface.Scoreboard.VisibilityChanged:Connect(function()
        p_u_53:Update()
    end)
    p_u_53.DuelInterface.Voting.VisibilityChanged:Connect(function()
        p_u_53:Update()
    end)
    p_u_53:_Setup()
end
return v_u_8