local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Signal)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EquipmentMetricCard")
local v_u_7 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EquipmentMetricSlot")
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9, p10)
    local v11 = v_u_8
    local v12 = setmetatable({}, v11)
    v12.Clicked = v_u_3.new()
    v12.Opened = v_u_3.new()
    v12.Frame = v_u_6:Clone()
    v12.Container = v12.Frame:WaitForChild("Container")
    v12.Layout = v12.Container:WaitForChild("Layout")
    v12.HeaderFrame = v12.Container:WaitForChild("Header")
    v12.CloseButton = v12.HeaderFrame:WaitForChild("Button")
    v12.Title = v12.HeaderFrame:WaitForChild("Title")
    v12.Icon = v12.HeaderFrame:WaitForChild("Icon")
    v12._title = p9
    v12._icon = p10
    v12._elements = {}
    v12._set_opened_hash = 0
    v12:_Init()
    return v12
end
function v_u_8.GetScrollToElement(p13)
    return p13.Container
end
function v_u_8.SetParent(p14, p15)
    p14.Frame.Parent = p15
end
function v_u_8.SetOpened(p_u_16, p17)
    p_u_16._set_opened_hash = p_u_16._set_opened_hash + 1
    local v_u_18 = p_u_16._set_opened_hash
    p_u_16.Container.Visible = p17
    if p17 then
        p_u_16.Frame.Visible = true
        p_u_16.Opened:Fire()
        return
    elseif p_u_16.Frame:IsDescendantOf(v_u_2.LocalPlayer.PlayerGui) then
        p_u_16.Frame:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quint", 0.25, true, function()
            if v_u_18 == p_u_16._set_opened_hash then
                p_u_16.Frame.Visible = false
            end
        end)
    else
        p_u_16.Frame.Visible = false
    end
end
function v_u_8.Add(p19, p20, p21)
    local v22 = v_u_7:Clone()
    v22.TitleContainer.Title.Text = p20
    v22.Value.RichText = string.find(p21, "<")
    v22.Value.Text = p21
    v22.LayoutOrder = #p19._elements
    v22.Parent = p19.Container
    local v23 = p19._elements
    table.insert(v23, v22)
    v_u_5:ScrollingTextLabel(v22.TitleContainer, v22.TitleContainer.Title, v22.Value)
end
function v_u_8.Clear(p24)
    for _, v25 in pairs(p24._elements) do
        v25:Destroy()
    end
    p24._elements = {}
end
function v_u_8.Destroy(p26)
    p26.Clicked:Destroy()
    p26.Opened:Destroy()
    p26.Frame:Destroy()
end
function v_u_8._Update(p27)
    if p27.Container.Visible then
        p27.Frame.Size = UDim2.new(1, 0, 0, p27.Layout.AbsoluteContentSize.Y + p27.Frame.AbsoluteSize.X * 0.05)
    end
end
function v_u_8._Setup(p28)
    p28.Title.Text = p28._title or ""
    p28.Icon.Image = p28._icon or ""
    p28.Frame.Visible = false
end
function v_u_8._Init(p_u_29)
    p_u_29.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_29:_Update()
    end)
    p_u_29.Container:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_29:_Update()
    end)
    p_u_29.CloseButton.MouseButton1Click:Connect(function()
        p_u_29.Clicked:Fire()
    end)
    p_u_29:_Setup()
    p_u_29:_Update()
    v_u_4:Add(p_u_29.CloseButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
end
return v_u_8