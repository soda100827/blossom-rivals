local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("Lighting")
local v_u_5 = game:GetService("Players")
local v_u_6 = require(v_u_1:WaitForChild("Modules"):WaitForChild("BetterDebris"))
local v_u_7 = require(v_u_1:WaitForChild("Modules"):WaitForChild("EventLibrary"))
local v_u_8 = require(v_u_1:WaitForChild("Modules"):WaitForChild("FunFacts"))
local v_u_9 = require(v_u_1:WaitForChild("Modules"):WaitForChild("Signal"))
local v_u_10 = require(v_u_1.Modules:WaitForChild("Utility"):WaitForChild("RenderstepForLoop"))
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11._new()
    local v12 = v_u_11
    local v13 = setmetatable({}, v12)
    v13.DeviceSelected = v_u_9.new()
    v13.LoadingScreen = script:WaitForChild("LoadingScreen")
    v13.MainFrame = v13.LoadingScreen:WaitForChild("MainFrame")
    v13.Background = v13.MainFrame:WaitForChild("Background")
    v13.Device = v13.MainFrame:WaitForChild("Device")
    v13.DeviceTitle = v13.Device:WaitForChild("Title")
    v13.ConfirmDeviceButton = v13.Device:WaitForChild("Confirm")
    v13.Controls = v13.Device:WaitForChild("Controls")
    v13.DesktopButton = v13.Controls:WaitForChild("Desktop")
    v13.ConsoleButton = v13.Controls:WaitForChild("Console")
    v13.MobileButton = v13.Controls:WaitForChild("Mobile")
    v13.FunFactText = v13.MainFrame:WaitForChild("FunFact")
    v13.FunFactButton = v13.FunFactText:WaitForChild("Button")
    v13.TimerText = v13.MainFrame:WaitForChild("Timer")
    v13.GameLogo = v13.MainFrame:WaitForChild("GameLogo")
    v13.Logo = v13.MainFrame:WaitForChild("Logo")
    v13.LogoN = v13.Logo:WaitForChild("N")
    v13.ContainerN = v13.LogoN:WaitForChild("Container")
    v13.WhiteN = v13.ContainerN:WaitForChild("White")
    v13.BlackN = v13.ContainerN:WaitForChild("Black")
    v13.LogoG = v13.Logo:WaitForChild("G")
    v13.ContainerG = v13.LogoG:WaitForChild("Container")
    v13.WhiteG = v13.ContainerG:WaitForChild("White")
    v13.BlackG = v13.ContainerG:WaitForChild("Black")
    v13._next_timer_increase = 0
    v13._timer = 0
    v13._blur = Instance.new("BlurEffect")
    v13._connection = nil
    v13._chosen_device = nil
    v13:_Init()
    return v13
end
function v_u_11.Activate(p14)
    p14.LoadingScreen.Parent = v_u_5.LocalPlayer:WaitForChild("PlayerGui")
    p14._blur.Parent = v_u_4
end
function v_u_11.PlayLogoAnimation(p15, p16)
    local v17 = typeof(p16) == "number"
    local v18 = "Argument 1 invalid, expected a number, got " .. tostring(p16)
    assert(v17, v18)
    p15:_ResetLogo()
    p15.Logo.Visible = true
    local v19 = Instance.new("Sound")
    v19.SoundId = "rbxassetid://6384899588"
    v19.Volume = 1
    v19.Parent = script
    v19:Play()
    v_u_6:AddItem(v19, 20)
    p15:_SpiralAnimation(p16)
end
function v_u_11.SplitLogo(p_u_20)
    p_u_20.Logo:TweenPosition(UDim2.new(0.5, 0, 1, 0), "In", "Back", 0.75, true)
    p_u_20.LogoN:TweenPosition(UDim2.new(-0.5, 0, 0.5, 0), "InOut", "Sine", 1.5, true)
    p_u_20.LogoG:TweenPosition(UDim2.new(1.5, 0, 0.5, 0), "InOut", "Sine", 1.5, true)
    local v_u_21 = p_u_20.FunFactText.TextTransparency
    local v_u_22 = p_u_20.TimerText.TextTransparency
    v_u_10(0, 100, 2, function(p23)
        local v24 = (p23 / 100) ^ 2
        local v25 = (0 + 720 * v24) % 360
        p_u_20.LogoN.Rotation = -v25
        p_u_20.LogoG.Rotation = v25
        p_u_20.FunFactText.TextTransparency = v_u_21 + (1 - v_u_21) * v24
        p_u_20.TimerText.TextTransparency = v_u_22 + (1 - v_u_22) * v24
    end)
end
function v_u_11.SetProgress(p26, p27, p28)
    local v29 = typeof(p27) == "number"
    local v30 = "Argument 1 invalid, expected a number, got " .. tostring(p27)
    assert(v29, v30)
    local v31 = typeof(p28) == "number"
    local v32 = "Argument 2 invalid, expected a number, got " .. tostring(p28)
    assert(v31, v32)
    local v33 = UDim2.new(1, 0, p27, 0)
    local v34 = UDim2.new(1, 0, 1 - p27, 0)
    p26.WhiteN:TweenSize(v33, "Out", "Quint", p28, true)
    p26.BlackN:TweenSize(v34, "Out", "Quint", p28, true)
    p26.WhiteG:TweenSize(v33, "Out", "Quint", p28, true)
    p26.BlackG:TweenSize(v34, "Out", "Quint", p28, true)
end
function v_u_11.PickDevice(p35, p36)
    local v37 = typeof(p36) == "table"
    local v38 = "Argument 1 invalid, expected a table, got " .. tostring(p36)
    assert(v37, v38)
    p35.Device.Position = UDim2.new(0.5, 0, -0.5, 0)
    p35.Device:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 1, true)
    p35.Device.Visible = true
    p35.DesktopButton.Visible = table.find(p36, "Desktop")
    p35.ConsoleButton.Visible = table.find(p36, "Console")
    p35.MobileButton.Visible = table.find(p36, "Mobile")
    local v39 = v_u_2
    local v40
    if p35.ConsoleButton.Visible then
        v40 = p35.ConsoleButton or nil
    else
        v40 = nil
    end
    v39.SelectedObject = v40
    local v41 = p35.DeviceSelected:Wait()
    v_u_2.SelectedObject = nil
    p35.Device.Visible = false
    return v41
end
function v_u_11.PreRequireClient(p42)
    p42.GameLogo.Visible = true
    p42.GameLogo.Size = UDim2.new(1, 0, 1, 0)
    p42.GameLogo:TweenSize(UDim2.new(0.6, 0, 0.6, 0), "Out", "Back", 0.5, true)
    local v43 = Instance.new("Sound")
    v43.SoundId = "rbxassetid://8483887957"
    v43.Volume = 1
    v43.Parent = script
    v43:Play()
    v_u_6:AddItem(v43, 20)
    wait(0.5)
end
function v_u_11.Close(p_u_44)
    p_u_44._connection:Disconnect()
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    p_u_44.MainFrame.Active = false
    p_u_44.GameLogo:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 1.5, true)
    p_u_44.GameLogo:TweenPosition(UDim2.new(0.5, 0, 1, 0), "In", "Quint", 1.5, true)
    v_u_1.Remotes.Data.LoadingScreenDone:FireServer()
    wait(0.5)
    v_u_10(0, 100, 2, function(p45)
        local v46 = 1 - (1 - p45 / 100) ^ 3
        p_u_44.GameLogo.ImageTransparency = (p45 / 100) ^ 3
        p_u_44._blur.Size = 56 * (1 - v46)
        p_u_44.Background.BackgroundTransparency = 0.5 + 0.5 * (p45 / 100)
    end)
    p_u_44:Destroy()
end
function v_u_11.Update(p47, _)
    local v48 = tick() * 2 % 6.283185307179586
    local v49 = math.sin(v48) * 0.05
    local v50 = v48 - 0.7853981633974483
    local v51 = math.sin(v50) * 0.05
    p47.ContainerN.Position = UDim2.new(0.5, 0, v49 + 0.5, 0)
    p47.ContainerG.Position = UDim2.new(0.5, 0, v51 + 0.5, 0)
    if tick() > p47._next_timer_increase then
        p47._next_timer_increase = tick() + 1
        p47._timer = p47._timer + 1
        p47.TimerText.Text = p47._timer
    end
end
function v_u_11.Destroy(p52)
    p52._blur:Destroy()
    p52.LoadingScreen:Destroy()
    p52.DeviceSelected:Destroy()
end
function v_u_11._ClientAlert(_)
    v_u_5.LocalPlayer:WaitForChild("ClientAlert"):FireServer()
end
function v_u_11._ChooseDevice(p53, p54)
    p53._chosen_device = p54
    for _, v55 in pairs({ "Desktop", "Mobile", "Console" }) do
        p53[v55 .. "Button"].Chosen.Visible = v55 == p53._chosen_device
        p53[v55 .. "Button"].Icon.ImageColor3 = v55 == p53._chosen_device and Color3.fromRGB(60, 226, 31) or Color3.fromRGB(255, 255, 255)
    end
    p53.ConfirmDeviceButton.Visible = true
end
function v_u_11._SpiralAnimation(p_u_56, p57)
    local v58 = typeof(p57) == "number"
    local v59 = "Argument 1 invalid, expected a number, got " .. tostring(p57)
    assert(v58, v59)
    p_u_56.LogoN:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", p57 * 1.5, true)
    p_u_56.LogoG:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", p57 * 1.5, true)
    v_u_10(0, 100, 1.667 / p57, function(p60)
        local v61 = 1 - (p60 / 100 - 1) ^ 2
        local v62 = (math.sqrt(v61) * 540 + 180) % 360
        p_u_56.Logo.Rotation = v62
        p_u_56.LogoN.Rotation = -v62
        p_u_56.LogoG.Rotation = -v62
    end)
end
function v_u_11._ResetLogo(p63)
    p63.LogoN.Position = UDim2.new(-1, 0, 0.5, 0)
    p63.LogoG.Position = UDim2.new(2, 0, 0.5, 0)
    p63.WhiteN.Size = UDim2.new(1, 0, 0, 0)
    p63.BlackN.Size = UDim2.new(1, 0, 1, 0)
    p63.WhiteG.Size = UDim2.new(1, 0, 0, 0)
    p63.BlackG.Size = UDim2.new(1, 0, 1, 0)
end
function v_u_11._Setup(p64)
    p64._blur.Name = "LoadingScreen"
    p64._blur.Size = 56
    p64.GameLogo.Image = v_u_7.IS_ACTIVE and v_u_7.EVENT_DETAILS.LOADING_SCREEN_LOGO or p64.GameLogo.Image
    p64.FunFactText.Text = v_u_8()
end
function v_u_11._Init(p_u_65)
    p_u_65.DesktopButton.MouseButton1Click:Connect(function()
        p_u_65:_ChooseDevice("Desktop")
    end)
    p_u_65.MobileButton.MouseButton1Click:Connect(function()
        p_u_65:_ChooseDevice("Mobile")
    end)
    p_u_65.ConsoleButton.MouseButton1Click:Connect(function()
        p_u_65:_ChooseDevice("Console")
    end)
    p_u_65.ConfirmDeviceButton.MouseButton1Click:Connect(function()
        p_u_65.DeviceSelected:Fire(p_u_65._chosen_device)
    end)
    p_u_65.FunFactButton.MouseButton1Click:Connect(function()
        p_u_65.FunFactText.Text = v_u_8()
    end)
    p_u_65._connection = v_u_3.RenderStepped:Connect(function()
        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    end)
    p_u_65:_Setup()
    p_u_65:_ResetLogo()
    task.defer(p_u_65._ClientAlert, p_u_65)
end
return v_u_11._new()