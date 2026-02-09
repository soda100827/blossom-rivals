local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Gun = require("@modules/gun")
local LocalPlayer = require("@core/player")

local Interface = {
    _started = false,
    _autoShootTask = nil,
    _watermarkConnection = nil,
}

local function clampValue(value, minimum, maximum)
    if value < minimum then
        return minimum
    elseif value > maximum then
        return maximum
    end

    return value
end

function Interface:_startWatermark()
    if self._watermarkConnection then
        return
    end

    local frameTimer = tick()
    local frameCounter = 0
    local fps = 60
    local pingStat = Stats.Network.ServerStatsItem["Data Ping"]

    self._watermarkConnection = RunService.RenderStepped:Connect(function()
        frameCounter += 1

        if (tick() - frameTimer) >= 1 then
            fps = frameCounter
            frameCounter = 0
            frameTimer = tick()
        end

        Library:SetWatermark(("Blossom Rivals | %s fps | %s ms"):format(
            math.floor(fps),
            math.floor(pingStat:GetValue())
        ))
    end)
end

function Interface:_stopWatermark()
    if self._watermarkConnection then
        self._watermarkConnection:Disconnect()
        self._watermarkConnection = nil
    end
end

function Interface:_startAutoShoot()
    if self._autoShootTask or not Toggles.AutoShootToggle.Value or Library.Unloaded then
        return
    end

    self._autoShootTask = task.spawn(function()
        while Toggles.AutoShootToggle.Value and not Library.Unloaded do
            local interval = clampValue(Options.AutoShootInterval.Value or 0.5, 0.05, 2)
            self._gun:shoot()
            task.wait(interval)
        end

        self._autoShootTask = nil
    end)
end

function Interface:_createMenu()
    Library:SetWatermarkVisibility(true)
    Library.KeybindFrame.Visible = true

    local Window = Library:CreateWindow({
        Title = "Blossom Rivals",
        Center = true,
        AutoShow = true,
        TabPadding = 8,
        MenuFadeTime = 0.2,
    })

    local Tabs = {
        Main = Window:AddTab("Main"),
        ["UI Settings"] = Window:AddTab("UI Settings"),
    }

    local CombatGroup = Tabs.Main:AddLeftGroupbox("Combat")

    CombatGroup:AddSlider("AutoShootInterval", {
        Text = "Shoot interval",
        Default = 0.5,
        Min = 0.1,
        Max = 2,
        Rounding = 2,
        Compact = false,

        Callback = function(Value)
            print("[cb] Shoot interval updated:", Value)
        end,
    })

    CombatGroup:AddToggle("AutoShootToggle", {
        Text = "Auto shoot gun",
        Default = false,
        Tooltip = "Keeps firing the built-in gun at the interval below",
        Callback = function()
            if Toggles.AutoShootToggle.Value then
                self:_startAutoShoot()
            end
        end,
    })

    CombatGroup:AddButton({
        Text = "Restore ammo",
        Func = function()
            self._gun.ammo = 30
            print("Ammo has been restored.")
        end,
        Tooltip = "Reloads the gun instantly",
    })

    CombatGroup:AddLabel("This menu demonstrates how dropdowns, sliders, and keybinds work.")
    CombatGroup:AddDivider()

    CombatGroup:AddInput("PlayerNote", {
        Default = "Leave a note!",
        Numeric = false,
        Finished = false,
        Text = "Player note",
        Tooltip = "Typing here does not affect the gun directly.",
        Placeholder = "Message to yourself",
        Callback = function(Value)
            print("[cb] Player note changed:", Value)
        end,
    })

    CombatGroup:AddDropdown("DamageDropdown", {
        Values = { "Single", "Burst", "FullAuto" },
        Default = 1,
        Multi = false,
        Text = "Fire mode",
        Tooltip = "Switch between fire modes.",
        Callback = function(Value)
            print("[cb] Fire mode set to:", Value)
        end,
    })

    CombatGroup:AddDropdown("UtilityMultiDropdown", {
        Values = { "This", "is", "a", "dropdown" },
        Default = 1,
        Multi = true,
        Text = "Utility perks",
        Tooltip = "Pick multiple perks to simulate.",
        Callback = function(Value)
            print("[cb] Multi dropdown changed:", Value)
        end,
    })

    CombatGroup:AddDropdown("PlayerDropdown", {
        SpecialType = "Player",
        Text = "Target player",
        Tooltip = "Pick a shape of player.",
        Callback = function(Value)
            print("[cb] Player dropdown changed:", Value)
        end,
    })

    CombatGroup:AddLabel("Color"):AddColorPicker("ColorPicker", {
        Default = Color3.new(0, 1, 0),
        Title = "Accent color",
        Transparency = 0,
        Callback = function(Value)
            print("[cb] Color changed!", Value)
        end,
    })

    CombatGroup:AddLabel("Keybind"):AddKeyPicker("KeyPicker", {
        Default = "MB2",
        SyncToggleState = false,
        Mode = "Toggle",
        Text = "Primary keybind",
        NoUI = false,
        Callback = function(Value)
            print("[cb] Keybind clicked!", Value)
        end,
        ChangedCallback = function(New)
            print("[cb] Keybind changed!", New)
        end,
    })

    local TabBox = Tabs.Main:AddRightTabbox()
    local TabOne = TabBox:AddTab("Tab 1")
    TabOne:AddToggle("Tab1Toggle", { Text = "Tab1 Toggle" })

    local TabTwo = TabBox:AddTab("Tab 2")
    TabTwo:AddToggle("Tab2Toggle", { Text = "Tab2 Toggle" })

    local SecondaryGroup = Tabs.Main:AddLeftGroupbox("Groupbox #2")
    SecondaryGroup:AddLabel([[
Oh no...
This label spans multiple lines!

We're gonna run out of UI space...
Just kidding! Scroll down!


Hello from below!
]], true)

    local RightGroupbox = Tabs.Main:AddRightGroupbox("Groupbox #3")
    RightGroupbox:AddToggle("ControlToggle", { Text = "Dependency box toggle" })

    local Depbox = RightGroupbox:AddDependencyBox()
    Depbox:AddToggle("DepboxToggle", { Text = "Sub-dependency box toggle" })

    local SubDepbox = Depbox:AddDependencyBox()
    SubDepbox:AddSlider("DepboxSlider", {
        Text = "Extra slider",
        Default = 50,
        Min = 0,
        Max = 100,
        Rounding = 0,
    })
    SubDepbox:AddDropdown("DepboxDropdown", { Text = "Dropdown", Default = 1, Values = { "a", "b", "c" } })

    Depbox:SetupDependencies({
        { Toggles.ControlToggle, true },
    })

    SubDepbox:SetupDependencies({
        { Toggles.DepboxToggle, true },
    })

    local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
    MenuGroup:AddButton("Unload", function()
        Library:Unload()
    end)

    MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
        Default = "End",
        NoUI = true,
        Text = "Menu keybind",
    })

    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
    ThemeManager:SetFolder("BlossomRivals")
    SaveManager:SetFolder("BlossomRivals/interface")
    SaveManager:BuildConfigSection(Tabs["UI Settings"])
    ThemeManager:ApplyToTab(Tabs["UI Settings"])
    SaveManager:LoadAutoloadConfig()

    Library.ToggleKeybind = Options.MenuKeybind

    Library:OnUnload(function()
        self:_stopWatermark()
        Toggles.AutoShootToggle:SetValue(false)
        Library.Unloaded = true
    end)

    self:_startWatermark()

    Toggles.AutoShootToggle:OnChanged(function()
        if Toggles.AutoShootToggle.Value then
            self:_startAutoShoot()
        end
    end)

    Options.UtilityMultiDropdown:OnChanged(function()
        for key, value in next, Options.UtilityMultiDropdown.Value do
            print(key, value)
        end
    end)

    Options.PlayerDropdown:SetValue(LocalPlayer)
    Options.UtilityMultiDropdown:SetValue({
        ["This"] = true,
        ["is"] = true,
    })

    Options.ColorPicker:OnChanged(function()
        print("Color changed!", Options.ColorPicker.Value)
        print("Transparency changed!", Options.ColorPicker.Transparency)
    end)

    Options.ColorPicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

    Options.KeyPicker:OnClick(function()
        print("Keybind clicked!", Options.KeyPicker:GetState())
    end)

    Options.KeyPicker:OnChanged(function()
        print("Keybind changed!", Options.KeyPicker.Value)
    end)

    task.spawn(function()
        while not Library.Unloaded do
            task.wait(1)
            local state = Options.KeyPicker:GetState()
            if state then
                print("KeyPicker is being held down")
            end
        end
    end)

end

function Interface:start()
    if self._started then
        return
    end

    self._started = true
    self._gun = Gun.new()
    self:_createMenu()
end

return Interface
