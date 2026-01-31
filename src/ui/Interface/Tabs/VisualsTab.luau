--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type BuildContext = {
  client: any,
}

--// Private state
local VisualsTab = {}
VisualsTab.__index = VisualsTab

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers

--// Public API
function VisualsTab.Build(tabs: any, context: BuildContext): ()
  local client = context.client

  local espGroup = tabs.visuals:AddLeftGroupbox("ESP")
  espGroup:AddToggle("VisualsToggle", {
    Text = "Visuals (ESP)",
    Default = false,
    Tooltip = "Master toggle for all ESP visuals.",
    Callback = function(state)
      local mod = client.Modules.Visuals
      if mod and mod.toggle then
        mod:toggle(state)
      end
      if mod and mod.setEspEnabled then
        mod:setEspEnabled(state)
      end
    end,
  })

  espGroup
    :AddToggle("ESPNames", {
      Text = "Name",
      Default = true,
      Tooltip = "Show player names.",
      Callback = function(state)
        local mod = client.Modules.Visuals
        if mod and mod.setShowNames then
          mod:setShowNames(state)
        end
      end,
    })
    :AddColorPicker("ESPTextColor", {
      Default = Color3.new(1, 1, 1),
      Title = "Text Color",
      Tooltip = "Color for ESP name text.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setTextColor then
          mod:setTextColor(value)
        end
      end,
    })
    :AddColorPicker("ESPNameOutlineColor", {
      Default = Color3.new(0, 0, 0),
      Title = "Name Outline",
      Tooltip = "Outline color for ESP names.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setNameOutlineColor then
          mod:setNameOutlineColor(value)
        end
      end,
    })

  espGroup
    :AddToggle("ESPWeapon", {
      Text = "Weapon",
      Default = false,
      Tooltip = "Show equipped weapon name.",
      Callback = function(state)
        local mod = client.Modules.Visuals
        if mod and mod.setShowWeapon then
          mod:setShowWeapon(state)
        end
      end,
    })
    :AddColorPicker("ESPWeaponColor", {
      Default = Color3.new(1, 1, 1),
      Title = "Weapon Color",
      Tooltip = "Color for weapon text.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setWeaponColor then
          mod:setWeaponColor(value)
        end
      end,
    })
    :AddColorPicker("ESPWeaponOutlineColor", {
      Default = Color3.new(0, 0, 0),
      Title = "Weapon Outline",
      Tooltip = "Outline color for weapon text.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setWeaponOutlineColor then
          mod:setWeaponOutlineColor(value)
        end
      end,
    })

  espGroup
    :AddToggle("ESPDistance", {
      Text = "Distance",
      Default = false,
      Tooltip = "Show distance to target.",
      Callback = function(state)
        local mod = client.Modules.Visuals
        if mod and mod.setShowDistance then
          mod:setShowDistance(state)
        end
      end,
    })
    :AddColorPicker("ESPDistanceColor", {
      Default = Color3.new(1, 1, 1),
      Title = "Distance Color",
      Tooltip = "Color for distance text.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setDistanceColor then
          mod:setDistanceColor(value)
        end
      end,
    })
    :AddColorPicker("ESPDistanceOutlineColor", {
      Default = Color3.new(0, 0, 0),
      Title = "Distance Outline",
      Tooltip = "Outline color for distance text.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setDistanceOutlineColor then
          mod:setDistanceOutlineColor(value)
        end
      end,
    })

  espGroup
    :AddToggle("ESPBoxes", {
      Text = "Box",
      Default = true,
      Tooltip = "Draw a box around targets.",
      Callback = function(state)
        local mod = client.Modules.Visuals
        if mod and mod.setShowBoxes then
          mod:setShowBoxes(state)
        end
      end,
    })
    :AddColorPicker("ESPBoxColor", {
      Default = Color3.new(1, 1, 1),
      Title = "Box Color",
      Tooltip = "Color of the ESP box.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setBoxColor then
          mod:setBoxColor(value)
        end
      end,
    })
    :AddColorPicker("ESPBoxOutlineColor", {
      Default = Color3.new(0, 0, 0),
      Title = "Box Outline",
      Tooltip = "Outline color of the ESP box.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setBoxOutlineColor then
          mod:setBoxOutlineColor(value)
        end
      end,
    })

  espGroup
    :AddToggle("ESPSkeleton", {
      Text = "Skeleton",
      Default = false,
      Tooltip = "Draw a skeleton over targets.",
      Callback = function(state)
        local mod = client.Modules.Visuals
        if mod and mod.setShowSkeleton then
          mod:setShowSkeleton(state)
        end
      end,
    })
    :AddColorPicker("ESPSkeletonColor", {
      Default = Color3.new(1, 1, 1),
      Title = "Skeleton Color",
      Tooltip = "Color of skeleton lines.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setSkeletonColor then
          mod:setSkeletonColor(value)
        end
      end,
    })
    :AddColorPicker("ESPSkeletonOutlineColor", {
      Default = Color3.new(0, 0, 0),
      Title = "Skeleton Outline",
      Tooltip = "Outline color for skeleton lines.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setSkeletonOutlineColor then
          mod:setSkeletonOutlineColor(value)
        end
      end,
    })

  espGroup
    :AddToggle("ESPHealthbar", {
      Text = "Healthbar",
      Default = false,
      Tooltip = "Show target healthbar.",
      Callback = function(state)
        local mod = client.Modules.Visuals
        if mod and mod.setShowHealthbar then
          mod:setShowHealthbar(state)
        end
      end,
    })
    :AddColorPicker("ESPHealthbarColor", {
      Default = Color3.new(0, 1, 0),
      Title = "Health Color",
      Tooltip = "Color of health fill.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setHealthbarColor then
          mod:setHealthbarColor(value)
        end
      end,
    })
    :AddColorPicker("ESPHealthbarOutlineColor", {
      Default = Color3.new(0, 0, 0),
      Title = "Outline Color",
      Tooltip = "Outline color for the healthbar.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setHealthbarOutlineColor then
          mod:setHealthbarOutlineColor(value)
        end
      end,
    })

  espGroup
    :AddToggle("ESPHighlight", {
      Text = "Highlight",
      Default = false,
      Tooltip = "Add a Highlight instance to targets.",
      Callback = function(state)
        local mod = client.Modules.Visuals
        if mod and mod.setShowHighlight then
          mod:setShowHighlight(state)
        end
      end,
    })
    :AddColorPicker("ESPHighlightFill", {
      Default = Color3.new(1, 0, 0),
      Title = "Fill Color",
      Tooltip = "Fill color for Highlight.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setHighlightFill then
          mod:setHighlightFill(value)
        end
      end,
    })
    :AddColorPicker("ESPHighlightOutline", {
      Default = Color3.new(1, 1, 1),
      Title = "Outline Color",
      Tooltip = "Outline color for Highlight.",
      Callback = function(value)
        local mod = client.Modules.Visuals
        if mod and mod.setHighlightOutline then
          mod:setHighlightOutline(value)
        end
      end,
    })

  espGroup:AddToggle("ESPBetterBounds", {
    Text = "Better Bounds",
    Default = false,
    Tooltip = "Reserved for future bounds improvements.",
    Callback = function(_stateValue) end,
  })

  espGroup:AddToggle("ESPShowTeammates", {
    Text = "Show Teammates",
    Default = true,
    Tooltip = "Show ESP on teammates.",
    Callback = function(state)
      local mod = client.Modules.Visuals
      if mod and mod.setShowTeammates then
        mod:setShowTeammates(state)
      end
    end,
  })

  espGroup:AddSlider("ESPSkeletonThickness", {
    Text = "Skeleton Thickness",
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Tooltip = "Thickness of skeleton lines.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Visuals
      if mod and mod.setSkeletonThickness then
        mod:setSkeletonThickness(value)
      end
    end,
  })

  espGroup:AddSlider("ESPTextSize", {
    Text = "Text Size",
    Default = 12,
    Min = 10,
    Max = 24,
    Rounding = 0,
    Tooltip = "Size of ESP text.",
    Compact = true,
    Callback = function(value)
      local mod = client.Modules.Visuals
      if mod and mod.setTextSize then
        mod:setTextSize(value)
      end
    end,
  })
end

return VisualsTab
