--!strict

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Dependencies (require)

--// Constants

--// Types
export type PlayerUtils = {
  getLocalPlayer: () -> Player?,
  getCamera: () -> Camera,
}

--// Private state
local PlayerUtils = {}
PlayerUtils.__index = PlayerUtils

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers

--// Public API
function PlayerUtils.getLocalPlayer(): Player?
  return Players.LocalPlayer
end

function PlayerUtils.getCamera(): Camera
  local camera = Workspace.CurrentCamera
  if not camera then
    camera = Workspace:WaitForChild("Camera") :: Camera
  end
  return camera
end

return PlayerUtils
