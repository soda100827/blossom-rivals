--!strict

--// Services

--// Dependencies (require)
local Constants = require("./Constants")
local Types = require("./Types")

--// Constants

--// Types

--// Private state
local _maid = nil :: any
local _signals = {}
local _state: Types.VisualsState = {
  client = nil :: any,
  logger = nil :: any,
  isEnabled = false,
  drawings = {},
  highlights = {},
  smoothCache = {},
  settings = table.clone(Constants.DEFAULT_SETTINGS),
  overrideCheck = nil,
  isEspPreviouslyEnabled = false,
  lastSkeletonUpdate = 0,
  lastTextUpdate = 0,
}

--// Private helpers

--// Public API
return _state
