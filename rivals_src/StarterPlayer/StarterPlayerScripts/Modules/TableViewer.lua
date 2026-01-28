local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Utility)
local v_u_3 = script:WaitForChild("Entry")
local v_u_4 = script:WaitForChild("Gui")
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.Root = p6
    v8.ScreenGui = v_u_4:Clone()
    v8._entry_to_children = {}
    v8._entry_to_parent = {}
    v8:_Init()
    return v8
end
function v_u_5.Destroy(p9)
    p9.ScreenGui:Destroy()
    p9._entry_to_children = nil
    p9._entry_to_parent = nil
    p9.Root = nil
end
function v_u_5._GetTabString(_, p10)
    return string.rep(" <font transparency=\"0.75\">|</font>  ", p10)
end
function v_u_5._ColorBasedOnType(_, p11, p12)
    if typeof(p12) == "string" then
        return "<font color=\"rgb(0,255,0)\">" .. p11 .. "</font>"
    elseif typeof(p12) == "number" then
        return "<font color=\"rgb(255,198,0)\">" .. p11 .. "</font>"
    elseif typeof(p12) == "boolean" then
        return "<font color=\"rgb(8,123,255)\">" .. p11 .. "</font>"
    elseif typeof(p12) == "Instance" then
        return p12.ClassName .. ": <font color=\"rgb(0,255,0)\">\"" .. p11 .. "\"</font>"
    else
        return p11
    end
end
function v_u_5._DeleteDescendants(p13, p14)
    for _, v15 in pairs(p13._entry_to_children[p14] or {}) do
        p13:_DeleteDescendants(v15)
        p13._entry_to_children[v15] = nil
        p13._entry_to_parent[v15] = nil
        v15:Destroy()
    end
end
function v_u_5._CreateEntry(p_u_16, p17)
    local v_u_18 = v_u_3:Clone()
    p_u_16._entry_to_children[v_u_18] = {}
    p_u_16._entry_to_parent[v_u_18] = p17
    if p17 then
        local v19 = p_u_16._entry_to_children[p17]
        table.insert(v19, v_u_18)
    end
    v_u_18.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        local v20 = v_u_18
        local v21 = UDim2.new
        local v22 = v_u_18.Title.TextBounds.X
        local v23 = p_u_16.ScreenGui.MainFrame.List.AbsoluteCanvasSize.X
        v20.Size = v21(0, math.max(v22, v23), v_u_18.Size.Y.Scale, v_u_18.Size.Y.Offset)
    end)
    local v24 = UDim2.new
    local v25 = v_u_18.Title.TextBounds.X
    local v26 = p_u_16.ScreenGui.MainFrame.List.AbsoluteCanvasSize.X
    v_u_18.Size = v24(0, math.max(v25, v26), v_u_18.Size.Y.Scale, v_u_18.Size.Y.Offset)
    return v_u_18
end
function v_u_5._Generate(p_u_27, p28, p_u_29, p30)
    local v31 = {}
    for v32 in pairs(p28) do
        table.insert(v31, v32)
    end
    table.sort(v31, function(p33, p34)
        return v_u_2:StringLessThan(tostring(p33), (tostring(p34)))
    end)
    local v35 = p30 and (p30.LayoutOrder or 0) or 0
    for v36 in pairs(p_u_27._entry_to_children) do
        if v35 < v36.LayoutOrder then
            v36.LayoutOrder = v36.LayoutOrder + (#v31 + (p30 and 1 or 0))
        end
    end
    for v37, v38 in pairs(v31) do
        local v_u_39 = p28[v38]
        local v40 = typeof(v_u_39) == "table"
        local v41
        if v40 then
            v41 = next(v_u_39) ~= nil
        else
            v41 = v40
        end
        local v_u_42 = p_u_27:_GetTabString(p_u_29)
        local v43
        if typeof(v38) == "string" then
            v43 = "\"" .. v38 .. "\""
        else
            v43 = tostring(v38)
        end
        local v_u_44 = p_u_27:_ColorBasedOnType(v43, v38)
        local v45
        if typeof(v_u_39) == "string" then
            v45 = "\"" .. v_u_39 .. "\""
        else
            v45 = tostring(v_u_39)
        end
        local v46 = p_u_27:_ColorBasedOnType(v45, v_u_39)
        local v_u_47 = p_u_27:_CreateEntry(p30)
        v_u_47.Title.Text = string.format("%s[%s] = %s;", v_u_42, v_u_44, v40 and "{}" or v46)
        v_u_47.LayoutOrder = v35 + v37
        v_u_47.Parent = p_u_27.ScreenGui.MainFrame.List.Container
        if v41 then
            local v_u_48 = false
            v_u_47.Title.Text = string.format("%s[%s] = %s", v_u_42, v_u_44, v_u_48 and "{" or "{...};")
            v_u_47.Button.MouseButton1Click:Connect(function()
                v_u_48 = not v_u_48
                v_u_47.Title.Text = string.format("%s[%s] = %s", v_u_42, v_u_44, v_u_48 and "{" or "{...};")
                if v_u_48 then
                    p_u_27:_Generate(v_u_39, p_u_29 + 1, v_u_47)
                else
                    p_u_27:_DeleteDescendants(v_u_47)
                end
            end)
        end
    end
    if p30 then
        local v49 = p_u_27:_CreateEntry(p30)
        v49.Title.Text = p_u_27:_GetTabString(p_u_29 - 1) .. "};"
        v49.LayoutOrder = v35 + #v31 + 1
        v49.Parent = p_u_27.ScreenGui.MainFrame.List.Container
    end
end
function v_u_5._UpdateList(p50)
    p50.ScreenGui.MainFrame.List.CanvasSize = UDim2.new(0, p50.ScreenGui.MainFrame.List.Container.Layout.AbsoluteContentSize.X, 0, p50.ScreenGui.MainFrame.List.Container.Layout.AbsoluteContentSize.Y)
end
function v_u_5._UpdateSize(p51)
    p51.ScreenGui.MainFrame.List.Container.Size = UDim2.new(0, p51.ScreenGui.MainFrame.AbsoluteSize.X, 0, p51.ScreenGui.MainFrame.AbsoluteSize.Y)
end
function v_u_5._Init(p_u_52)
    p_u_52.ScreenGui.MainFrame.Top.Button.MouseButton1Click:Connect(function()
        p_u_52:Destroy()
    end)
    p_u_52.ScreenGui.MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_52:_UpdateSize()
    end)
    p_u_52.ScreenGui.MainFrame.List.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_52:_UpdateList()
    end)
    p_u_52:_Generate(p_u_52.Root, 0, nil)
    p_u_52:_UpdateSize()
    p_u_52:_UpdateList()
end
return v_u_5