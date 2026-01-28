local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_6 = v3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Temp"):WaitForChild("Pages")
local v_u_7 = Color3.fromRGB(220, 220, 220)
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = typeof(p9) == "string"
    local v11 = "Argument 1 invalid, expected a string, got " .. tostring(p9)
    assert(v10, v11)
    local v12 = v_u_8
    local v13 = setmetatable({}, v12)
    v13.Name = p9
    v13.PageFrame = v_u_5:GetPage(p9)
    v13.CantBeClosedFromInputs = false
    v13.OpenChanged = v_u_4.new()
    v13.Closed = v_u_4.new()
    v13.OpenPage = v_u_4.new()
    v13._default_size = v13.PageFrame.Size
    v13._is_open = false
    v13._is_open_hash = 0
    v13._open_connections = {}
    v13._open_threads = {}
    v13._temp_folder = v_u_6
    v13._redirect_to = nil
    v13._open_animation_disabled = false
    v13:_Init()
    return v13
end
function v_u_8.GetDefaultElement(p14)
    return p14.PromptSystem and p14.PromptSystem:GetDefaultElement() or p14.PageFrame
end
function v_u_8.CloseRequest(p15)
    if p15.PromptSystem and p15.PromptSystem.CurrentPrompt then
        p15.PromptSystem.CurrentPrompt:CloseRequest()
        return
    elseif p15._redirect_to then
        p15.OpenPage:Fire(p15._redirect_to)
        p15._redirect_to = nil
    else
        p15.Closed:Fire()
    end
end
function v_u_8.GetLightingTintColor(_)
    return v_u_7
end
function v_u_8.GetLightingBrightness(_)
    return -0.1
end
function v_u_8.GetLightingContrast(_)
    return 0
end
function v_u_8.GetLightingBlur(_)
    return 24
end
function v_u_8.IsOpen(p16)
    return p16._is_open
end
function v_u_8.Open(p17, p18)
    local v19 = typeof(p18) == "Instance"
    local v20 = "Argument 1 invalid, expected an Instance, got " .. tostring(p18)
    assert(v19, v20)
    p17.PageFrame.Parent = p18
    p17.PageFrame.Visible = true
    if p17._open_animation_disabled or v_u_2.ReducedMotionEnabled then
        p17.PageFrame.Size = p17._default_size
        p17.PageFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    else
        p17.PageFrame.Size = UDim2.new(p17._default_size.X.Scale * 0.75, p17._default_size.X.Offset * 0.75, p17._default_size.Y.Scale * 0.75, p17._default_size.Y.Offset * 0.75)
        p17.PageFrame:TweenSize(p17._default_size, "Out", "Back", 0.25, true)
        p17.PageFrame.Position = UDim2.new(0.5, 0, 0.6, 0)
        p17.PageFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Back", 0.25, true)
    end
    p17:_CleanupOnOpenChanged()
    p17._is_open = true
    p17._is_open_hash = p17._is_open_hash + 1
    p17.OpenChanged:Fire()
end
function v_u_8.Close(p21)
    p21:_CleanupOnOpenChanged()
    p21._is_open = false
    p21._is_open_hash = p21._is_open_hash + 1
    p21.OpenChanged:Fire()
    if p21.PromptSystem then
        p21.PromptSystem:Close()
    end
    p21.PageFrame.Visible = false
    p21.PageFrame.Parent = v_u_6
end
function v_u_8.RedirectTo(p22, p23)
    p22._redirect_to = p23
end
function v_u_8._CleanupOnOpenChanged(p24)
    for _, v25 in pairs(p24._open_connections) do
        v25:Disconnect()
    end
    for _, v26 in pairs(p24._open_threads) do
        task.cancel(v26)
    end
    p24._open_connections = {}
    p24._open_threads = {}
end
function v_u_8._Init(_) end
return v_u_8