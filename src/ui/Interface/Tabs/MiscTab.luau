--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type ControlBinding = {
  toggleId: string,
  keybindId: string,
  last: boolean?,
  setter: (boolean) -> (),
}

export type BuildContext = {
  client: any,
  library: any,
  updateControlBindings: () -> (),
  setNotifyMuted: (any, boolean) -> (),
  setKeybindToggleMap: ({ [string]: string }) -> (),
  setControlBindings: ({ ControlBinding }) -> (),
}

--// Private state
local MiscTab = {}
MiscTab.__index = MiscTab

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers

--// Public API
function MiscTab.Build(tabs: any, context: BuildContext): ()
  local client = context.client
  local library = context.library
  local updateControlBindings = context.updateControlBindings
  local setNotifyMuted = context.setNotifyMuted

  local playerGroup = tabs.misc:AddLeftGroupbox("Player")
  local exploitsGroup = tabs.misc:AddRightGroupbox("Exploits")

  local playerFlyToggle = playerGroup:AddToggle("PlayerFly", {
    Text = "Fly",
    Default = false,
    Tooltip = "Toggle flight mode.",
    Callback = function(state)
      updateControlBindings()
    end,
  })
  playerFlyToggle:AddKeyPicker("PlayerFlyKeybind", {
    Default = "F",
    NoUI = false,
    Text = "Fly",
    SyncToggleState = false,
    Callback = function()
      updateControlBindings()
    end,
  })

  playerGroup:AddSlider("PlayerFlySpeed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 5,
    Max = 200,
    Rounding = 0,
    Tooltip = "Movement speed while flying.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Player
      if mod and mod.setFlySpeed then
        mod:setFlySpeed(value)
      end
    end,
  })

  local playerNoclipToggle = playerGroup:AddToggle("PlayerNoclip", {
    Text = "Noclip",
    Default = false,
    Tooltip = "Disable collisions for your character.",
    Callback = function(state)
      updateControlBindings()
    end,
  })
  playerNoclipToggle:AddKeyPicker("PlayerNoclipKeybind", {
    Default = "N",
    NoUI = false,
    Text = "Noclip",
    SyncToggleState = false,
    Callback = function()
      updateControlBindings()
    end,
  })

  local playerWalkSpeedToggle = playerGroup:AddToggle("PlayerWalkSpeedEnabled", {
    Text = "Walk Speed",
    Default = false,
    Tooltip = "Toggle custom walk speed.",
    Callback = function(state)
      updateControlBindings()
    end,
  })
  playerWalkSpeedToggle:AddKeyPicker("PlayerWalkSpeedKeybind", {
    Default = "T",
    NoUI = false,
    Text = "Walk Speed",
    SyncToggleState = false,
    Callback = function()
      updateControlBindings()
    end,
  })

  playerGroup:AddSlider("PlayerWalkSpeed", {
    Text = "Walk Speed",
    Default = 16,
    Min = 0,
    Max = 200,
    Rounding = 0,
    Tooltip = "Your character walk speed.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Player
      if mod and mod.setWalkSpeed then
        mod:setWalkSpeed(value)
      end
    end,
  })

  local playerJumpPowerToggle = playerGroup:AddToggle("PlayerJumpPowerEnabled", {
    Text = "Jump Power",
    Default = false,
    Tooltip = "Toggle custom jump power.",
    Callback = function(state)
      updateControlBindings()
    end,
  })
  playerJumpPowerToggle:AddKeyPicker("PlayerJumpPowerKeybind", {
    Default = "Y",
    NoUI = false,
    Text = "Jump Power",
    SyncToggleState = false,
    Callback = function()
      updateControlBindings()
    end,
  })

  playerGroup:AddSlider("PlayerJumpPower", {
    Text = "Jump Power",
    Default = 50,
    Min = 0,
    Max = 200,
    Rounding = 0,
    Tooltip = "Your character jump power.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Player
      if mod and mod.setJumpPower then
        mod:setJumpPower(value)
      end
    end,
  })

  playerGroup:AddToggle("PlayerSlideBoost", {
    Text = "Slide Boost",
    Default = false,
    Tooltip = "Boosts your sliding speed.",
    Callback = function(state)
      local mod = client.Modules.Player
      if mod and mod.setSlideBoostEnabled then
        mod:setSlideBoostEnabled(state)
      end
    end,
  })

  playerGroup:AddSlider("PlayerSlideBoostMultiplier", {
    Text = "Slide Boost Multiplier",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Suffix = "x",
    Tooltip = "Multiplier for sliding speed.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Player
      if mod and mod.setSlideBoostMultiplier then
        mod:setSlideBoostMultiplier(value)
      end
    end,
  })

  -- Exploits Group
  exploitsGroup:AddToggle("PlayerAntiFlash", {
    Text = "Anti Flashbang",
    Default = false,
    Tooltip = "Prevents you from being blinded by flashbangs.",
    Callback = function(state)
      local mod = client.Modules.Player
      if mod and mod.setAntiFlashEnabled then
        mod:setAntiFlashEnabled(state)
      end
    end,
  })

  exploitsGroup:AddToggle("PlayerSpoofDeviceEnabled", {
    Text = "Spoof Device",
    Default = false,
    Tooltip = "Toggle device spoofing.",
    Callback = function(state)
      local mod = client.Modules.Player
      if mod and mod.setSpoofDeviceEnabled then
        mod:setSpoofDeviceEnabled(state)
      end
    end,
  })

  exploitsGroup:AddDropdown("PlayerSpoofDevice", {
    Values = { "None", "Touch", "Gamepad", "VR", "MouseKeyboard" },
    Default = 1,
    Multi = false,
    Text = "Device",
    Tooltip = "The device to spoof as.",
    Callback = function(value)
      local mod = client.Modules.Player
      if mod and mod.setSpoofDevice then
        mod:setSpoofDevice(value)
      end
    end,
  })

  exploitsGroup:AddToggle("PlayerSoundSpammer", {
    Text = "Sound Spammer",
    Default = false,
    Tooltip = "Spams mechanics sounds to other players.",
    Callback = function(state)
      local mod = client.Modules.Player
      if mod and mod.setSoundSpammerEnabled then
        mod:setSoundSpammerEnabled(state)
      end
    end,
  })

  exploitsGroup:AddDropdown("PlayerSoundSpammerType", {
    Values = { "DoubleJump", "Slide" },
    Default = 1,
    Multi = false,
    Text = "Sound",
    Tooltip = "The sound to spam.",
    Callback = function(value)
      local mod = client.Modules.Player
      if mod and mod.setSoundSpammerType then
        mod:setSoundSpammerType(value)
      end
    end,
  })

  context.setKeybindToggleMap({
    ["Silent Aim"] = "SilentAimEnabled",
    ["Aimbot"] = "CombatAimbotEnabled",
    ["Fly"] = "PlayerFly",
    ["Noclip"] = "PlayerNoclip",
    ["Walk Speed"] = "PlayerWalkSpeedEnabled",
    ["Jump Power"] = "PlayerJumpPowerEnabled",
  })

  context.setControlBindings({
    {
      toggleId = "CombatAimbotEnabled",
      keybindId = "CombatAimbotKeybind",
      last = nil,
      setter = function(active)
        local mod = client.Modules.Combat
        if mod and mod.setAimbotEnabled then
          mod:setAimbotEnabled(active)
        end
      end,
    },
    {
      toggleId = "PlayerFly",
      keybindId = "PlayerFlyKeybind",
      last = nil,
      setter = function(active)
        local mod = client.Modules.Player
        if mod and mod.setFlyEnabled then
          mod:setFlyEnabled(active)
        end
      end,
    },
    {
      toggleId = "PlayerNoclip",
      keybindId = "PlayerNoclipKeybind",
      last = nil,
      setter = function(active)
        local mod = client.Modules.Player
        if mod and mod.setNoclipEnabled then
          mod:setNoclipEnabled(active)
        end
      end,
    },
    {
      toggleId = "PlayerWalkSpeedEnabled",
      keybindId = "PlayerWalkSpeedKeybind",
      last = nil,
      setter = function(active)
        local mod = client.Modules.Player
        if mod and mod.setWalkSpeedEnabled then
          mod:setWalkSpeedEnabled(active)
        end
      end,
    },
    {
      toggleId = "PlayerJumpPowerEnabled",
      keybindId = "PlayerJumpPowerKeybind",
      last = nil,
      setter = function(active)
        local mod = client.Modules.Player
        if mod and mod.setJumpPowerEnabled then
          mod:setJumpPowerEnabled(active)
        end
      end,
    },
    {
      toggleId = "SilentAimEnabled",
      keybindId = "SilentAimKeybind",
      last = nil,
      setter = function(active)
        local mod = client.Modules.Combat
        if mod and mod.setSilentAimEnabled then
          mod:setSilentAimEnabled(active)
        end
      end,
    },
  })

  local miscGroup = tabs.misc:AddLeftGroupbox("Auto Load")
  miscGroup:AddToggle("TeleportQueue", {
    Text = "Auto Load",
    Default = false,
    Tooltip = "Auto-load Blossom after teleport.",
    Callback = function(enabled)
      client:setTeleportQueue(enabled)
    end,
  })

  miscGroup:AddToggle("SilentMode", {
    Text = "Silent Mode",
    Default = false,
    Tooltip = "Mutes UI notifications and auto-opens silently.",
    Callback = function(enabled)
      setNotifyMuted(library, enabled)
      client:setSilent(enabled)
    end,
  })
end

return MiscTab
