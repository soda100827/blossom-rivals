local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.ItemLibrary)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_9 = v_u_3.LocalPlayer.PlayerScripts.UserInterface.DropdownButton
local v_u_10 = v_u_3.LocalPlayer.PlayerScripts.UserInterface.DropdownSlot;
({}).ReleaseRatio = 1.025
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new(p12, p13, p14)
    local v15 = typeof(p12) == "Instance"
    assert(v15, "Argument 1 invalid, expected a valid UI element")
    local v16 = typeof(p13) == "table"
    assert(v16, "Argument 2 invalid, expected a table")
    local v17 = v_u_11
    local v18 = setmetatable({}, v17)
    v18.Selected = v_u_5.new()
    v18.Frame = v_u_10:Clone()
    v18.Background = v18.Frame:WaitForChild("Background")
    v18.List = v18.Frame:WaitForChild("List")
    v18.Container = v18.List:WaitForChild("Container")
    v18.Layout = v18.Container:WaitForChild("Layout")
    v18._destroyed = false
    v18._reference = p12
    v18._options = p13
    v18._max_options = p14 or 5
    v18._connections = {}
    v18._selected = false
    v18:_Init()
    return v18
end
function v_u_11.Cancel(p19)
    p19:_Select(nil)
end
function v_u_11.Destroy(p20)
    if not p20._destroyed then
        p20._destroyed = true
        for _, v21 in pairs(p20._connections) do
            v21:Disconnect()
        end
        p20.Selected:Destroy()
        pcall(p20.Frame.Destroy, p20.Frame)
    end
end
function v_u_11._Select(p22, ...)
    if not p22._selected then
        p22._selected = true
        p22.Selected:Fire(...)
    end
end
function v_u_11._Update(p23)
    local v24 = v_u_8:ScreenPointToPosition(p23._reference.AbsolutePosition)
    local v25 = p23._reference.AbsoluteSize
    local v26 = v25.Y / v25.X
    p23.Frame.Position = UDim2.new(0, v24.X, 0, v24.Y)
    p23.Frame.Size = UDim2.new(0, v25.X, 0, v25.Y)
    p23.Container.Size = UDim2.new(1, 0, v26, 0)
end
function v_u_11._Setup(p_u_27)
    local v28 = p_u_27.Background
    local v29 = UDim2.new
    local v30 = p_u_27._max_options
    local v31 = #p_u_27._options
    v28.Size = v29(1, 10, math.min(v30, v31), 10)
    p_u_27.List.Size = UDim2.new(1, 0, p_u_27._max_options, 0)
    p_u_27.Layout.CellSize = UDim2.new(1, 0, 1, 0)
    for _, v_u_32 in pairs(p_u_27._options) do
        local v33 = tostring(v_u_32)
        local v_u_34 = v_u_9:Clone()
        v_u_34.Button.Title.Text = v33
        v_u_34.Parent = p_u_27.Container
        v_u_7:Add(v_u_34.Button, nil, {
            ["ReleaseRatio"] = UDim2.new(0, -3, 0, -3),
            ["HoverRatio"] = UDim2.new(0, -3, 0, -3),
            ["PressRatio"] = UDim2.new(0, -10, 0, -10)
        })
        local v35 = v_u_6
        local v36 = v_u_34.Button.Title
        local v37 = v_u_4.Items[v33]
        if v37 then
            v37 = v_u_4.Items[v33].Status
        end
        v35:ApplyItemStatusToText(v36, v37)
        v_u_34.Button.MouseButton1Click:Connect(function()
            p_u_27:_Select(v_u_32)
        end)
        v_u_34.MouseEnter:Connect(function()
            v_u_34.Button.Hovering.Visible = true
            v_u_34.Button.Title.TextColor3 = Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        end)
        v_u_34.MouseLeave:Connect(function()
            v_u_34.Button.Hovering.Visible = false
            v_u_34.Button.Title.TextColor3 = Color3.fromRGB(0, 0, 0)
        end)
        v_u_34.Button.Hovering.Visible = false
        v_u_34.Button.Title.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
    p_u_27.Frame.Parent = v_u_8.MainGui
end
function v_u_11._Init(p_u_38)
    p_u_38.Selected:Connect(function()
        task.defer(p_u_38.Destroy, p_u_38)
    end)
    p_u_38.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_38.List.CanvasSize = UDim2.new(0, 0, 0, p_u_38.Layout.AbsoluteContentSize.Y)
    end)
    local v39 = p_u_38._connections
    local v40 = p_u_38._reference.AncestryChanged
    local function v41()
        if not p_u_38._reference:IsDescendantOf(v_u_3.LocalPlayer.PlayerGui) then
            p_u_38.Selected:Fire(nil)
        end
    end
    table.insert(v39, v40:Connect(v41))
    local v42 = p_u_38._connections
    local v43 = p_u_38._reference:GetPropertyChangedSignal("AbsolutePosition")
    table.insert(v42, v43:Connect(function()
        p_u_38:_Update()
    end))
    local v44 = p_u_38._connections
    local v45 = p_u_38._reference:GetPropertyChangedSignal("AbsoluteSize")
    table.insert(v44, v45:Connect(function()
        p_u_38:_Update()
    end))
    local v46 = p_u_38._connections
    local v47 = v_u_2.InputBegan
    local function v49(p48, _)
        if p48.UserInputType == Enum.UserInputType.MouseButton1 or (p48.UserInputType == Enum.UserInputType.Touch or p48.KeyCode == Enum.KeyCode.ButtonA) then
            if not v_u_8:IsMouseWithinBounds(p_u_38.Background.AbsolutePosition, p_u_38.Background.AbsoluteSize) then
                p_u_38.Selected:Fire(nil)
            end
        end
    end
    table.insert(v46, v47:Connect(v49))
    p_u_38:_Setup()
    p_u_38:_Update()
end
return v_u_11