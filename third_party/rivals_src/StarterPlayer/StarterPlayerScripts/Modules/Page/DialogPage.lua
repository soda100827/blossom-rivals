local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.Utility)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Pages")
local v_u_7 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DialogPage")
local v_u_8 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DialogButton")
local v_u_9 = setmetatable({}, v_u_5)
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_7:Clone()
    v11.Name = p10
    v11.Parent = v_u_6
    local v12 = v_u_5.new(p10)
    local v13 = v_u_9
    local v14 = setmetatable(v12, v13)
    v14.Container = v14.PageFrame:WaitForChild("Container")
    v14.Background = v14.Container:WaitForChild("Background")
    v14.Arrow = v14.Background:WaitForChild("Arrow")
    v14.Message = v14.Container:WaitForChild("Message")
    v14.Picture = v14.Container:WaitForChild("Picture")
    v14.ButtonsFrame = v14.Container:WaitForChild("Buttons")
    v14.HidePartyDisplay = true
    v14._close_callback = nil
    v14._dialog_buttons = {}
    v14._layout_order = 0
    v14._buttons_hash = 0
    v14._play_dialog_hash = 0
    v14._picture_original_size = v14.Picture.Size
    v14._dialog_actions = {}
    v14:_Init()
    return v14
end
function v_u_9.PlayDialog(p_u_15, p_u_16)
    p_u_15._play_dialog_hash = p_u_15._play_dialog_hash + 1
    local _ = p_u_15._play_dialog_hash
    if p_u_16.Message then
        p_u_15:_Message(p_u_16.Message.Picture, p_u_16.Message.Text, p_u_16.Message.SoundID)
    else
        p_u_15:_Clear()
    end
    if p_u_16.Buttons then
        for _, v17 in pairs(p_u_16.Buttons) do
            local v18 = p_u_15:_GetButtonAction(v17.NextDialog, v17.DialogActionKey)
            local v19 = v17.IsCloseButton
            if v19 then
                v19 = Color3.fromRGB(255, 50, 50)
            end
            p_u_15:_CreateButton(v17.Text, v18, v19, p_u_16.ButtonAppearDelay)
        end
    end
    if p_u_16.DelayedContinue then
        task.spawn(function()
            local v20 = p_u_15._play_dialog_hash
            wait(p_u_16.DelayedContinue.Delay)
            if v20 == p_u_15._play_dialog_hash then
                p_u_15:_GetButtonAction(p_u_16.DelayedContinue.NextDialog)()
            end
        end)
    end
end
function v_u_9.HookDialogActionKey(p21, p22, p23)
    p21._dialog_actions[p22] = p23
end
function v_u_9.Open(p24, ...)
    v_u_5.Open(p24, ...)
    p24:_Clear()
end
function v_u_9.Close(p25, ...)
    p25:_Clear()
    v_u_5.Close(p25, ...)
end
function v_u_9._FetchDialog(p26, p27, ...)
    local v28 = p26._is_open_hash
    local v29, v30 = pcall(p27.InvokeServer, p27, ...)
    if v28 == p26._is_open_hash then
        if not v29 then
            warn("Failed to fetch dialog, error:", v30)
        end
        if v29 and v30 then
            p26:PlayDialog(v30)
        else
            p26:CloseRequest()
        end
    else
        return
    end
end
function v_u_9._GetButtonAction(p_u_31, p_u_32, p_u_33)
    return function()
        if p_u_32 then
            p_u_31:PlayDialog(p_u_32)
        else
            p_u_31:CloseRequest()
        end
        if p_u_33 then
            if p_u_31._dialog_actions[p_u_33] then
                p_u_31._dialog_actions[p_u_33]()
                return
            end
            v_u_1.Remotes.Misc.DialogAction:FireServer(p_u_33)
        end
    end
end
function v_u_9._CreateButton(p_u_34, p35, p36, p37, p38)
    p_u_34._layout_order = p_u_34._layout_order + 1
    local v39 = p37 or Color3.fromRGB(84, 212, 42)
    local v_u_40 = p38 or 0
    local v_u_41 = v_u_8:Clone()
    v_u_41.Button.BackgroundColor3 = v39
    v_u_41.Button.Container.Arrow.ImageColor3 = v39
    v_u_41.Button.Container.Title.Text = p35
    v_u_41.LayoutOrder = p_u_34._layout_order
    v_u_41.Parent = p_u_34.ButtonsFrame
    local v42 = p_u_34._dialog_buttons
    table.insert(v42, v_u_41)
    local v_u_43 = v_u_41.Button
    local v_u_44 = v_u_43.Container
    local v_u_45 = v_u_44.Title
    local function v46()
        v_u_41.Size = UDim2.new(0, (v_u_45.TextBounds.X + v_u_44.AbsoluteSize.X) / v_u_43.Size.X.Scale, 1, 0)
        v_u_45.Position = UDim2.new(1, -v_u_41.AbsoluteSize.X / 2 * v_u_43.Size.X.Scale, 0.5, 0)
    end
    v_u_44:GetPropertyChangedSignal("AbsoluteSize"):Connect(v46)
    v_u_43:GetPropertyChangedSignal("AbsoluteSize"):Connect(v46)
    v_u_45:GetPropertyChangedSignal("TextBounds"):Connect(v46)
    v46()
    v_u_43.MouseButton1Click:Connect(p36)
    v_u_4:Add(v_u_43)
    task.spawn(function()
        local v47 = p_u_34._buttons_hash
        v_u_43.Visible = false
        wait(0.1 * (p_u_34._layout_order - 1) + v_u_40)
        if v47 == p_u_34._buttons_hash then
            v_u_43.Visible = true
            v_u_43.Position = UDim2.new(0.75, 0, 0.5, 0)
            v_u_43:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.5, true)
        end
    end)
end
function v_u_9._ClearButtons(p48)
    for _, v49 in pairs(p48._dialog_buttons) do
        v49:Destroy()
    end
    p48._dialog_buttons = {}
    p48._layout_order = 0
    p48._buttons_hash = p48._buttons_hash + 1
end
function v_u_9._Message(p50, p51, p52, p53)
    p50:_ClearButtons()
    local v54 = p51 or ""
    local v55 = p52 or ""
    p50.Message.Text = v55
    p50.Picture.Image = v54
    p50.Background.Visible = v55 ~= "" and true or v54 ~= ""
    p50.Arrow.Visible = v54 ~= ""
    if p50.Picture:IsDescendantOf(v_u_2) then
        p50.Picture.Size = UDim2.new(p50._picture_original_size.X.Scale * 0.8, 0, p50._picture_original_size.Y.Scale * 1.2, 0)
        p50.Picture:TweenSize(p50._picture_original_size, "Out", "Back", 0.5, true)
    else
        p50.Picture.Size = p50._picture_original_size
    end
    if p53 then
        v_u_3:CreateSound(p53, 1, 1, script, true, 10)
    end
end
function v_u_9._Clear(p56)
    p56:_Message(nil, nil, nil)
end
function v_u_9._Setup(p_u_57)
    function p_u_57._close_callback()
        p_u_57:CloseRequest()
    end
end
function v_u_9._Init(p58)
    p58:_Setup()
    p58:_Clear()
end
return v_u_9