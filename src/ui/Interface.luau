--!strict

--// Services
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any
local CombatTab = require("./Interface/Tabs/CombatTab")
local VisualsTab = require("./Interface/Tabs/VisualsTab")
local UiSettingsTab = require("./Interface/Tabs/UiSettingsTab")
local MiscTab = require("./Interface/Tabs/MiscTab")

--// Constants
local REPO_URL = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local WATERMARK_TEMPLATE = "Blossom | %d fps | %d ms"
local WATERMARK_UPDATE_INTERVAL = 1
local KEYBIND_LIST_UPDATE_INTERVAL = 0.2
local CONTROL_BINDINGS_UPDATE_INTERVAL = 0.05

--// Types
export type Interface = {
  init: (self: Interface, client: any) -> (),
  Destroy: (self: Interface) -> (),
}

--// Private state
local Interface = {}
Interface.__index = Interface

local _maid = nil :: any
local _state = {
  client = nil :: any,
  logger = nil :: any,
  library = nil :: any,
  themeManager = nil :: any,
  saveManager = nil :: any,
  isMounted = false,
  controlBindings = nil :: any,
  cachedToggles = nil :: any,
  cachedOptions = nil :: any,
  keybindListMode = "Active",
  watermark = {
    lastSample = 0,
    frameCount = 0,
  },
  lastKeybindListUpdate = 0,
  lastControlBindingsUpdate = 0,
  keybindToggleMap = {},
}
local _signals = {}
local _env = (getfenv :: any)(0) :: any
local _writefile = _env.writefile
local _readfile = _env.readfile
local _isfile = _env.isfile
local _delfile = _env.delfile

--// Private helpers
local function _getLinoriaGlobals(): (any, any)
  local getfenvAny = getfenv :: any
  local env = getfenvAny(0) :: any
  local getgenvFunc = env.getgenv
  local toggles = (getgenvFunc and getgenvFunc().Toggles) or _G.Toggles
  local options = (getgenvFunc and getgenvFunc().Options) or _G.Options
  if toggles then
    _state.cachedToggles = toggles
  end
  if options then
    _state.cachedOptions = options
  end
  return _state.cachedToggles, _state.cachedOptions
end

local function _getPingMs(): number
  local pingMs = 0
  local pcallAny = pcall :: any
  local success, value = pcallAny(function()
    local statsService = Stats :: any
    local stat = statsService.Network.ServerStatsItem["Data Ping"]
    return stat:GetValue()
  end)
  if success and type(value) == "number" then
    pingMs = math.floor(value + 0.5)
  end
  return pingMs
end

local function _setKeybindListVisible(isVisible: boolean)
  local library = _state.library
  if not library then
    return
  end
  local keybindFrame = library.KeybindFrame
  if keybindFrame then
    keybindFrame.Visible = isVisible
  end
end

local function _setWatermarkVisible(isVisible: boolean)
  local library = _state.library
  if not library or not library.SetWatermarkVisibility then
    return
  end
  library:SetWatermarkVisibility(isVisible)
end

local function _syncUiVisibility()
  local toggles = _getLinoriaGlobals()
  if not toggles then
    return
  end
  local keybindsToggle = toggles.UIShowKeybindList
  if keybindsToggle then
    _setKeybindListVisible(keybindsToggle.Value == true)
  end
  local watermarkToggle = toggles.UIShowWatermark
  if watermarkToggle then
    _setWatermarkVisible(watermarkToggle.Value == true)
  end
end

local function _updateWatermark()
  local library = _state.library
  if not library or not library.SetWatermark then
    return
  end

  local toggles = _getLinoriaGlobals()
  local isVisible = true
  if toggles and toggles.UIShowWatermark then
    isVisible = toggles.UIShowWatermark.Value == true
  end
  if not isVisible then
    return
  end

  local watermark = _state.watermark
  watermark.frameCount += 1

  local now = os.clock()
  if watermark.lastSample <= 0 then
    watermark.lastSample = now
    return
  end
  if (now - watermark.lastSample) < WATERMARK_UPDATE_INTERVAL then
    return
  end

  local fps = math.floor(watermark.frameCount / (now - watermark.lastSample))
  watermark.frameCount = 0
  watermark.lastSample = now

  library:SetWatermark(string.format(WATERMARK_TEMPLATE, fps, _getPingMs()))
end

local function _extractKeybindParts(text: string): (string?, string?, string?)
  local key, name, mode = text:match("^%[([^%]]+)%]%s*(.-)%s*%(([^%)]*)%)$")
  if key and name and mode then
    return key, name, mode
  end
  return nil, nil, nil
end

local function _getKeybindListMode(): string
  local _, options = _getLinoriaGlobals()
  if options then
    local option = options.UIKeybindListMode
    if option and option.Value then
      _state.keybindListMode = option.Value
    end
  end
  return _state.keybindListMode
end

local function _updateKeybindList()
  local library = _state.library
  if not library or not library.KeybindContainer or not library.KeybindFrame then
    return
  end

  local toggles = _getLinoriaGlobals()
  local mode = _getKeybindListMode()
  local ySize = 0
  local xSize = 0

  for _, label in next, library.KeybindContainer:GetChildren() do
    if label:IsA("TextLabel") then
      local key, name, modeText = _extractKeybindParts(label.Text)
      if key and name and modeText then
        label.Text = string.format("[%s] %s (%s)", key, name, modeText)
      end

      local isVisible = true
      if mode == "Active" then
        isVisible = label.TextColor3 == library.AccentColor
      elseif mode == "Toggle" then
        if modeText then
          isVisible = modeText == "Toggle"
        else
          local mapName = name or label.Text
          local toggleId = _state.keybindToggleMap[mapName]
          local toggle = toggles and toggleId and toggles[toggleId]
          isVisible = toggle and toggle.Value == true or false
        end
      end

      label.Visible = isVisible

      if isVisible then
        ySize += 18
        if label.TextBounds.X > xSize then
          xSize = label.TextBounds.X
        end
      end
    end
  end

  library.KeybindFrame.Size = UDim2.new(0, math.max(xSize + 10, 210), 0, ySize + 23)
end

local function _updateControlBindings()
  if not _state.controlBindings then
    return
  end
  local toggles, options = _getLinoriaGlobals()
  if not toggles or not options then
  end
  for _, control in ipairs(_state.controlBindings) do
    local toggle = toggles and toggles[control.toggleId]
    local gate = toggle and toggle.Value == true
    local isActive = false
    if gate then
      local keybind = options and options[control.keybindId]
      if keybind and keybind.GetState then
        isActive = keybind:GetState()
      else
        isActive = false
      end
    end
    if control.last ~= isActive then
      control.last = isActive
      control.setter(isActive)
    end
  end
end

local function _installSaveManagerExtensions(saveManager: any)
  if saveManager._blossomBuildConfigSection then
    return
  end

  saveManager._blossomBuildConfigSection = saveManager.BuildConfigSection
  saveManager.BuildConfigSection = function(self: any, tab: any)
    assert(self.Library, "Must set SaveManager.Library")

    local section = tab:AddRightGroupbox("Configuration")

    section:AddInput("SaveManager_ConfigName", { Text = "Config name" })
    section:AddDropdown("SaveManager_ConfigList", {
      Text = "Config list",
      Values = self:RefreshConfigList(),
      AllowNull = true,
    })

    section:AddDivider()

    local _, options = _getLinoriaGlobals()

    section
      :AddButton("Create config", function()
        if not options then
          return
        end
        local name = options.SaveManager_ConfigName.Value

        if name:gsub(" ", "") == "" then
          return self.Library:Notify("Invalid config name (empty)", 2)
        end

        local success, err = (self :: any):Save(name)
        if not success then
          return self.Library:Notify("Failed to save config: " .. err, 2)
        end

        self.Library:Notify(string.format("Created config %q", name), 2)

        options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
        options.SaveManager_ConfigList:SetValue(nil)
      end)
      :AddButton("Load config", function()
        if not options then
          return
        end
        local name = options.SaveManager_ConfigList.Value

        local success, err = (self :: any):Load(name)
        if not success then
          return self.Library:Notify("Failed to load config: " .. err, 2)
        end

        self.Library:Notify(string.format("Loaded config %q", name), 2)
      end)

    section:AddButton("Overwrite config", function()
      if not options then
        return
      end
      local name = options.SaveManager_ConfigList.Value

      local success, err = (self :: any):Save(name)
      if not success then
        return self.Library:Notify("Failed to overwrite config: " .. err, 2)
      end

      self.Library:Notify(string.format("Overwrote config %q", name), 2)
    end)

    section:AddButton("Refresh list", function()
      if not options then
        return
      end
      options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
      options.SaveManager_ConfigList:SetValue(nil)
    end)

    section
      :AddButton("Set as autoload", function()
        if not options then
          return
        end
        local name = options.SaveManager_ConfigList.Value
        if not _writefile then
          self.Library:Notify("Executor missing writefile; cannot set autoload.", 2)
          return
        end
        _writefile(self.Folder .. "/settings/autoload.txt", name)
        self.AutoloadLabel:SetText("Current autoload config: " .. name)
        self.Library:Notify(string.format("Set %q to auto load", name), 2)
      end)
      :AddButton("Remove autoload", function()
        local path = self.Folder .. "/settings/autoload.txt"
        if _isfile and _isfile(path) then
          if _delfile then
            pcall(_delfile, path)
          end
        end
        self.AutoloadLabel:SetText("Current autoload config: none")
        self.Library:Notify("Cleared autoload config", 2)
      end)

    self.AutoloadLabel = section:AddLabel("Current autoload config: none", true)

    if _isfile and _isfile(self.Folder .. "/settings/autoload.txt") and _readfile then
      local name = _readfile(self.Folder .. "/settings/autoload.txt")
      self.AutoloadLabel:SetText("Current autoload config: " .. name)
    end

    self:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
  end
end

local function _httpGet(url: string): string
  return (game :: any):HttpGet(url)
end

local function _loadRemote(path: string, logger: any): any
  local source = _httpGet(REPO_URL .. path)
  local loadstringAny = loadstring :: any
  local chunk, err = loadstringAny(source)
  if not chunk then
    if logger then
      logger:error("UI load failed:", err)
    end
    error("UI load failed: " .. tostring(err))
  end
  return chunk()
end

local function _setNotifyMuted(library: any, shouldMute: boolean)
  if shouldMute then
    library.Notify = library.Notify or function() end
    library._blossomNotify = library._blossomNotify or library.Notify
    library.Notify = function() end
    return
  end
  if library._blossomNotify then
    library.Notify = library._blossomNotify
  end
end

local function _getLibraryVisible(library: any): boolean
  if type(library.Opened) == "boolean" then
    return library.Opened
  end
  if type(library.Visible) == "boolean" then
    return library.Visible
  end
  if type(library.IsOpen) == "boolean" then
    return library.IsOpen
  end
  return true
end

local function _runAutoload(library: any, saveManager: any, isSilent: boolean)
  local wasVisible = _getLibraryVisible(library)
  if isSilent then
    _setNotifyMuted(library, true)
    if wasVisible then
      pcall(function()
        library:Toggle()
      end)
    end
  end

  pcall(function()
    saveManager:LoadAutoloadConfig()
  end)

  if isSilent then
    if wasVisible then
      pcall(function()
        library:Toggle()
      end)
    end
    _setNotifyMuted(library, false)
  end
end

local function _unloadAll()
  local client = _state.client
  if client and client.destroy then
    client:destroy()
    return
  end

  _maid:DoCleaning()
  if _state.library then
    _state.library:Unload()
  end
  _state.isMounted = false
end

local function _connect()
  _maid:DoCleaning()

  local updateConn = RunService.RenderStepped:Connect(function()
    local now = os.clock()
    if now - _state.lastControlBindingsUpdate >= CONTROL_BINDINGS_UPDATE_INTERVAL then
      _state.lastControlBindingsUpdate = now
      _updateControlBindings()
    end
    _updateWatermark()
    if now - _state.lastKeybindListUpdate >= KEYBIND_LIST_UPDATE_INTERVAL then
      _state.lastKeybindListUpdate = now
      _updateKeybindList()
    end
  end)
  _maid:GiveTask(updateConn)
end

local function _mount()
  if _state.isMounted then
    return
  end
  _state.isMounted = true

  local logger = _state.logger
  local library = _loadRemote("Library.lua", logger)
  local themeManager = _loadRemote("addons/ThemeManager.lua", logger)
  local saveManager = _loadRemote("addons/SaveManager.lua", logger)

  _state.library = library
  _state.themeManager = themeManager
  _state.saveManager = saveManager

  _installSaveManagerExtensions(saveManager)

  local window = library:CreateWindow({
    Title = "Blossom " .. _state.client.Version,
    Center = true,
    AutoShow = not _state.client.IsSilent,
    TabPadding = 8,
    MenuFadeTime = 0.2,
  })

  local tabs = {
    combat = window:AddTab("Combat"),
    visuals = window:AddTab("Visuals"),
    misc = window:AddTab("Misc"),
    uiSettings = window:AddTab("UI Settings"),
  }

  CombatTab.Build(tabs, {
    client = _state.client,
    updateControlBindings = _updateControlBindings,
  })
  VisualsTab.Build(tabs, {
    client = _state.client,
  })
  UiSettingsTab.Build(tabs, {
    library = library,
    themeManager = themeManager,
    saveManager = saveManager,
    unloadAll = _unloadAll,
    setKeybindListVisible = _setKeybindListVisible,
    setWatermarkVisible = _setWatermarkVisible,
    updateKeybindList = _updateKeybindList,
  })
  MiscTab.Build(tabs, {
    client = _state.client,
    library = library,
    updateControlBindings = _updateControlBindings,
    setNotifyMuted = _setNotifyMuted,
    setKeybindToggleMap = function(map)
      _state.keybindToggleMap = map
    end,
    setControlBindings = function(bindings)
      _state.controlBindings = bindings
    end,
  })

  _updateControlBindings()
  _runAutoload(library, saveManager, false)
  _syncUiVisibility()
end

--// Public API
function Interface.init(self: Interface, client: any): ()
  _state.client = client
  _state.logger = client.Logger
  _maid = Maid.new()
  _connect()
  _mount()
end

function Interface.Destroy(self: Interface): ()
  _maid:DoCleaning()
  if _state.library then
    _state.library:Unload()
  end
  _state.isMounted = false
end

return Interface
