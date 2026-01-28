local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ItemLibrary)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local v_u_5 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EliminationBoardSlot")
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EliminationBoardGui")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.Part = p8
    v10.SurfaceGui = v_u_6:Clone()
    v10._slots = {}
    v10._layout_order = 0
    v10:_Init()
    return v10
end
function v_u_7.NewElimination(p11, p12, p13, p14, _, p15)
    p11._layout_order = p11._layout_order - 1
    local v16 = v_u_5:Clone()
    v16.Weapon.Image = v_u_3.Items[p15] and v_u_3.Items[p15].Image or ""
    v16.LayoutOrder = p11._layout_order
    local v17 = p12.Character
    if v17 then
        v17 = p12.Character:FindFirstChild("Humanoid")
    end
    v_u_4.new(p12.UserId, p13, not v17 and 0 or v17.Health / v17.MaxHealth).SlotFrame.Parent = v16.Eliminator
    local v18 = p14.Character
    if v18 then
        v18 = p14.Character:FindFirstChild("Humanoid")
    end
    v_u_4.new(p14.UserId, p13, not v18 and 0 or v18.Health / v18.MaxHealth).SlotFrame.Parent = v16.Victim
    v16.Parent = p11.SurfaceGui.List.Container
    local v19 = p11._slots
    table.insert(v19, 1, v16)
    local v20 = table.remove(p11._slots, 31)
    if v20 then
        v20:Destroy()
    end
end
function v_u_7._Setup(p21)
    p21.SurfaceGui.Adornee = p21.Part
    p21.SurfaceGui.Parent = v_u_2.LocalPlayer.PlayerGui
end
function v_u_7._Init(p_u_22)
    p_u_22.SurfaceGui.List.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_22.SurfaceGui.List.CanvasSize = UDim2.new(0, 0, 0, p_u_22.SurfaceGui.List.Container.Layout.AbsoluteContentSize.Y)
    end)
    p_u_22:_Setup()
end
return v_u_7