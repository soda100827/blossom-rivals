--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type BuildContext = {
  library: any,
  themeManager: any,
  saveManager: any,
  unloadAll: () -> (),
  setKeybindListVisible: (boolean) -> (),
  setWatermarkVisible: (boolean) -> (),
  updateKeybindList: () -> (),
}

--// Private state
local UiSettingsTab = {}
UiSettingsTab.__index = UiSettingsTab

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers

--// Public API
function UiSettingsTab.Build(tabs: any, context: BuildContext): ()
  local library = context.library
  local themeManager = context.themeManager
  local saveManager = context.saveManager
  local unloadAll = context.unloadAll
  local setKeybindListVisible = context.setKeybindListVisible
  local setWatermarkVisible = context.setWatermarkVisible
  local updateKeybindList = context.updateKeybindList

  local menuGroup = tabs.uiSettings:AddLeftGroupbox("Menu")
  menuGroup:AddButton("Unload", function()
    unloadAll()
  end)
  menuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "End",
    NoUI = true,
    Text = "Menu keybind",
  })
  menuGroup:AddDivider()

  menuGroup:AddToggle("UIShowKeybindList", {
    Text = "Keybind List",
    Default = true,
    Tooltip = "Shows the keybind list panel.",
    Callback = function(isVisible)
      setKeybindListVisible(isVisible)
    end,
  })
  menuGroup:AddToggle("UIShowWatermark", {
    Text = "Watermark",
    Default = true,
    Tooltip = "Shows the watermark display.",
    Callback = function(isVisible)
      setWatermarkVisible(isVisible)
    end,
  })
  menuGroup:AddDropdown("UIKeybindListMode", {
    Values = { "Active", "Toggle", "All" },
    Default = "Active",
    Multi = false,
    Text = "Keybind Mode",
    Tooltip = "Filter for the keybind list.",
    Callback = function()
      updateKeybindList()
    end,
  })

  -- LinoriaLib exports Options to the global environment
  local getfenvAny = getfenv :: any
  local env = getfenvAny(0) :: any
  local getgenvFunc = env.getgenv
  local GlobalOptions = (getgenvFunc and getgenvFunc().Options) or _G.Options
  if GlobalOptions and GlobalOptions.MenuKeybind then
    library.ToggleKeybind = GlobalOptions.MenuKeybind
  end

  themeManager:SetLibrary(library)
  saveManager:SetLibrary(library)
  saveManager:IgnoreThemeSettings()
  themeManager:SetFolder("Blossom")
  saveManager:SetFolder("Blossom")
  saveManager:BuildConfigSection(tabs.uiSettings)
  themeManager:ApplyToTab(tabs.uiSettings)
end

return UiSettingsTab
