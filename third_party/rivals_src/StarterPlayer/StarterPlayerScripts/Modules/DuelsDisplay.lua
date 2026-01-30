local v_u_1 = game:GetService("Players")
local v_u_2 = require(v_u_1.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_3 = require(script:WaitForChild("DuelDisplay"))
local v_u_4 = v_u_1.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelsBoardGui")
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.Part = p6
    v8.SurfaceGui = v_u_4:Clone()
    v8._duel_displays = {}
    v8._connections = {}
    v8._enabled_hash = 0
    v8._is_enabled = nil
    v8:_Init()
    return v8
end
function v_u_5.SetEnabled(p9, p10)
    if p9._is_enabled ~= p10 then
        p9._is_enabled = p10
        p9:_Clear()
        if p10 then
            task.spawn(p9._Generate, p9)
        end
    end
end
function v_u_5._UpdateEmpty(p11)
    p11.SurfaceGui.Empty.Visible = not next(p11._duel_displays)
end
function v_u_5._Generate(p_u_12)
    p_u_12._enabled_hash = p_u_12._enabled_hash + 1
    local v_u_13 = p_u_12._enabled_hash
    task.spawn(function()
        while true do
            p_u_12.SurfaceGui.Live.Text = "\226\128\162 LIVE"
            wait(1)
            if v_u_13 ~= p_u_12._enabled_hash then
                break
            end
            p_u_12.SurfaceGui.Live.Text = "LIVE"
            wait(0.25)
            if v_u_13 ~= p_u_12._enabled_hash then
                return
            end
        end
    end)
    local v14 = p_u_12._connections
    local v15 = v_u_2.ObjectAdded
    table.insert(v14, v15:Connect(function(p16)
        p_u_12:_DuelAdded(p16)
    end))
    local v17 = p_u_12._connections
    local v18 = v_u_2.ObjectRemoved
    table.insert(v17, v18:Connect(function(p19)
        p_u_12:_DuelRemoved(p19)
    end))
    for _, v20 in pairs(v_u_2.Objects) do
        task.defer(p_u_12._DuelAdded, p_u_12, v20)
    end
end
function v_u_5._Clear(p21)
    for _, v22 in pairs(p21._duel_displays) do
        v22:Destroy()
    end
    for _, v23 in pairs(p21._connections) do
        v23:Disconnect()
    end
    p21._connections = {}
    p21._duel_displays = {}
    p21._enabled_hash = p21._enabled_hash + 1
end
function v_u_5._DuelAdded(p_u_24, p_u_25)
    p_u_24:_DuelRemoved(p_u_25)
    if p_u_25:Get("Status") ~= "GameOver" then
        local v26 = v_u_3.new(p_u_25)
        v26.Frame.Parent = p_u_24.SurfaceGui.List.Container
        p_u_24._duel_displays[p_u_25] = v26
        v26.GameOver:Connect(function()
            p_u_24:_DuelRemoved(p_u_25)
        end)
        p_u_24:_UpdateEmpty()
    end
end
function v_u_5._DuelRemoved(p27, p28)
    if p27._duel_displays[p28] then
        p27._duel_displays[p28]:Destroy()
        p27._duel_displays[p28] = nil
    end
    p27:_UpdateEmpty()
end
function v_u_5._Setup(p29)
    p29.SurfaceGui.Adornee = p29.Part
    p29.SurfaceGui.Parent = v_u_1.LocalPlayer.PlayerGui
end
function v_u_5._Init(p_u_30)
    p_u_30.SurfaceGui.List.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_30.SurfaceGui.List.CanvasSize = UDim2.new(0, 0, 0, p_u_30.SurfaceGui.List.Container.Layout.AbsoluteContentSize.Y)
    end)
    p_u_30:_Setup()
    p_u_30:_UpdateEmpty()
    p_u_30:SetEnabled(true)
end
return v_u_5