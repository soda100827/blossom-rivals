--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types

--// Private state
local Constants = {
  DEFAULT_FLY_SPEED = 50,
  INPUT_MAP = {
    [Enum.KeyCode.W] = "forward",
    [Enum.KeyCode.S] = "back",
    [Enum.KeyCode.A] = "left",
    [Enum.KeyCode.D] = "right",
    [Enum.KeyCode.Space] = "up",
    [Enum.KeyCode.LeftControl] = "down",
  },
}

--// Private helpers

--// Public API
return Constants
