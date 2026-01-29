--!strict

--// Services

--// Dependencies (require)
local Constants = require("./Constants")
local Types = require("./Types")

--// Constants

--// Types

--// Private state
local State: Types.VisualsState = {
  client = nil :: any,
  logger = nil :: any,
  isEnabled = false,
  drawings = {},
  highlights = {},
  settings = table.clone(Constants.DEFAULT_SETTINGS),
  overrideCheck = nil,
}

--// Private helpers

--// Public API
return State
