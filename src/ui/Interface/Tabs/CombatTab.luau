--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type BuildContext = {
  client: any,
  updateControlBindings: () -> (),
}

--// Private state
local CombatTab = {}
CombatTab.__index = CombatTab

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers

--// Public API
function CombatTab.Build(tabs: any, context: BuildContext): ()
  local client = context.client
  local updateControlBindings = context.updateControlBindings

  local combatGroup = tabs.combat:AddLeftGroupbox("Combat")

  -- Silent Aim Section
  local silentAimToggle = combatGroup:AddToggle("SilentAimEnabled", {
    Text = "Silent Aim",
    Default = false,
    Tooltip = "Redirects shots toward the closest valid target within your silent FOV.",
    Callback = function()
      updateControlBindings()
    end,
  })
  silentAimToggle:AddKeyPicker("SilentAimKeybind", {
    Default = "MouseButton2",
    NoUI = false,
    Text = "Silent Aim",
    SyncToggleState = false,
    Callback = function()
      updateControlBindings()
    end,
  })
  silentAimToggle:AddColorPicker("SilentAimFovColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Title = "Silent FOV Color",
    Tooltip = "Color of the Silent Aim FOV circle.",
    Callback = function(color, transparency)
      local mod = client.Modules.Combat
      if mod and mod.setSilentAimFovColor then
        mod:setSilentAimFovColor(color)
      end
      if mod and mod.setSilentAimFovTransparency then
        mod:setSilentAimFovTransparency(transparency or 0)
      end
    end,
  })

  combatGroup:AddSlider("SilentHitChance", {
    Text = "Silent Hit Chance",
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Tooltip = "Chance for Silent Aim to redirect a shot.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Combat
      if mod and mod.setSilentHitChance then
        mod:setSilentHitChance(value)
      end
    end,
  })

  combatGroup:AddSlider("SilentAimFovRadius", {
    Text = "Silent Aim Radius",
    Default = 100,
    Min = 10,
    Max = 800,
    Rounding = 0,
    Suffix = "px",
    Tooltip = "Silent Aim activation radius in pixels.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Combat
      if mod and mod.setSilentAimFovRadius then
        mod:setSilentAimFovRadius(value)
      end
    end,
  })

  -- Aimbot Section
  local combatAimbotToggle = combatGroup:AddToggle("CombatAimbotEnabled", {
    Text = "Aimbot",
    Default = false,
    Tooltip = "Automatically aims at the best target.",
    Callback = function()
      updateControlBindings()
    end,
  })
  combatAimbotToggle:AddKeyPicker("CombatAimbotKeybind", {
    Default = "MouseButton2",
    NoUI = false,
    Text = "Aimbot",
    SyncToggleState = false,
    Callback = function()
      updateControlBindings()
    end,
  })
  combatAimbotToggle:AddColorPicker("CombatFovColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Title = "Aimbot FOV Color",
    Tooltip = "Color of the Aimbot FOV circle.",
    Callback = function(color, transparency)
      local mod = client.Modules.Combat
      if mod and mod.setFovColor then
        mod:setFovColor(color)
      end
      if mod and mod.setFovTransparency then
        mod:setFovTransparency(transparency or 0)
      end
    end,
  })

  combatGroup:AddSlider("CombatSmoothness", {
    Text = "Aimbot Smoothing",
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = "%", -- Matches image style
    Tooltip = "Higher values feel smoother but slower to lock.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Combat
      if mod and mod.setSmoothness then
        mod:setSmoothness((value :: number) / 100) -- Convert to 0-1 for back-end
      end
    end,
  })

  combatGroup:AddSlider("CombatFovRadius", {
    Text = "Aimbot Radius",
    Default = 100,
    Min = 10,
    Max = 800,
    Rounding = 0,
    Suffix = "px",
    Tooltip = "Aimbot activation radius in pixels.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Combat
      if mod and mod.setFovRadius then
        mod:setFovRadius(value)
      end
    end,
  })

  -- Other Settings
  combatGroup:AddToggle("CombatManipulation", {
    Text = "Manipulation",
    Default = false,
    Tooltip = "Enables manipulation-related combat features.",
    Callback = function(state)
      local mod = client.Modules.Combat
      if mod and mod.setManipulationEnabled then
        mod:setManipulationEnabled(state)
      end
    end,
  })

  combatGroup:AddToggle("CombatWallCheck", {
    Text = "Visible Only",
    Default = false,
    Tooltip = "Only target enemies you can see (raycast).",
    Callback = function(state)
      local mod = client.Modules.Combat
      if mod and mod.setWallCheckEnabled then
        mod:setWallCheckEnabled(state)
      end
    end,
  })

  combatGroup:AddToggle("CombatAntiKatana", {
    Text = "Anti Katana",
    Default = false,
    Tooltip = "Mitigates katana-related attacks.",
    Callback = function(state)
      local mod = client.Modules.Combat
      if mod and mod.setAntiKatanaEnabled then
        mod:setAntiKatanaEnabled(state)
      end
    end,
  })

  combatGroup:AddToggle("CombatClosestPosition", {
    Text = "Closest Position",
    Default = true,
    Tooltip = "Choose the closest body part in the whitelist.",
    Callback = function(state)
      local mod = client.Modules.Combat
      if mod and mod.setClosestPositionEnabled then
        mod:setClosestPositionEnabled(state)
      end
    end,
  })

  combatGroup:AddDropdown("CombatClosestWhitelist", {
    Values = {
      "Head",
      "UpperTorso",
      "LowerTorso",
      "LeftUpperArm",
      "RightUpperArm",
      "LeftUpperLeg",
      "RightUpperLeg",
    },
    Default = {
      "Head",
      "UpperTorso",
      "LowerTorso",
      "LeftUpperArm",
      "RightUpperArm",
      "LeftUpperLeg",
      "RightUpperLeg",
    },
    Multi = true,
    Text = "Closest Position Whitelist",
    Tooltip = "Parts to consider for Closest Position",
    Callback = function(value)
      local mod = client.Modules.Combat
      if mod and mod.setClosestPositionWhitelist then
        local selectedNames = {}
        for name, enabled in pairs(value) do
          if enabled then
            table.insert(selectedNames, name)
          end
        end
        mod:setClosestPositionWhitelist(selectedNames)
      end
    end,
  })

  combatGroup:AddDropdown("CombatTargetPart", {
    Values = {
      "Head",
      "UpperTorso",
      "LowerTorso",
      "LeftUpperArm",
      "RightUpperArm",
      "LeftUpperLeg",
      "RightUpperLeg",
    },
    Default = 1,
    Multi = false,
    Text = "Target Part",
    Tooltip = "Static target part when Closest Position is off",
    Callback = function(value)
      local mod = client.Modules.Combat
      if mod and mod.setTargetPart then
        mod:setTargetPart(value)
      end
    end,
  })

  local ragebotGroup = tabs.combat:AddRightGroupbox("Ragebot")
  local ragebotToggle = ragebotGroup:AddToggle("CombatRagebotEnabled", {
    Text = "Ragebot",
    Default = false,
    Tooltip = "Teleports to a duel target and auto fires on round start.",
    Callback = function()
      updateControlBindings()
    end,
  })
  ragebotToggle:AddKeyPicker("CombatRagebotKeybind", {
    Default = "X",
    NoUI = false,
    Text = "Ragebot",
    SyncToggleState = false,
    Callback = function()
      updateControlBindings()
    end,
  })

  local gunModsGroup = tabs.combat:AddRightGroupbox("Gun Mods")

  gunModsGroup:AddToggle("GunModsNoRecoil", {
    Text = "No Recoil",
    Default = false,
    Tooltip = "Eliminates weapon recoil.",
    Callback = function(state)
      local mod = client.Modules.Combat
      if mod and mod.setNoRecoilEnabled then
        mod:setNoRecoilEnabled(state)
      end
    end,
  })

  gunModsGroup:AddToggle("GunModsNoSpread", {
    Text = "No Spread",
    Default = false,
    Tooltip = "Eliminates weapon bullet spread.",
    Callback = function(state)
      local mod = client.Modules.Combat
      if mod and mod.setNoSpreadEnabled then
        mod:setNoSpreadEnabled(state)
      end
    end,
  })

  gunModsGroup:AddToggle("GunModsNoMuzzleFlash", {
    Text = "No Muzzle Flash",
    Default = false,
    Tooltip = "Removes the muzzle flash effect when shooting.",
    Callback = function(state)
      local mod = client.Modules.Combat
      if mod and mod.setNoMuzzleFlashEnabled then
        mod:setNoMuzzleFlashEnabled(state)
      end
    end,
  })

  gunModsGroup:AddSlider("GunModsCooldown", {
    Text = "Attack Cooldown",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Tooltip = "Weapon fire rate cooldown. 1% is near-instant fire rate.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Combat
      if mod and mod.setAttackCooldownMultiplier then
        mod:setAttackCooldownMultiplier(value)
      end
    end,
  })

  local meleeModsGroup = tabs.combat:AddRightGroupbox("Melee Mods")

  meleeModsGroup:AddToggle("MeleeModsAura", {
    Text = "Melee Aura",
    Default = false,
    Tooltip = "Automatically attacks nearby enemies.",
    Callback = function(state)
      local mod = client.Modules.Combat
      if mod and mod.setMeleeAuraEnabled then
        mod:setMeleeAuraEnabled(state)
      end
    end,
  })

  meleeModsGroup:AddSlider("MeleeModsCooldown", {
    Text = "Attack Cooldown",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Tooltip = "Weapon fire rate cooldown. 1% is near-instant fire rate.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Combat
      if mod and mod.setMeleeAttackCooldownMultiplier then
        mod:setMeleeAttackCooldownMultiplier(value)
      end
    end,
  })

  meleeModsGroup:AddSlider("MeleeModsSkillCooldown", {
    Text = "Skill Cooldown",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Tooltip = "Skill cooldown multiplier. Lower values reduce skill cooldowns.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Combat
      if mod and mod.setMeleeSkillCooldownMultiplier then
        mod:setMeleeSkillCooldownMultiplier(value)
      end
    end,
  })
end

return CombatTab
