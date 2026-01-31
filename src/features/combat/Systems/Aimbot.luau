--!strict

--// Services

--// Dependencies (require)
local PlayerUtils = require("../../../shared/PlayerUtils")
local State = require("../State")
local Constants = require("../Constants")
local Helpers = require("../Utils/Helpers")

--// Constants

--// Types

--// Private state
local Aimbot = {}
Aimbot.__index = Aimbot

local _maid = nil :: any
local _signals = {}
local _state = {}

--// Private helpers

--// Public API
function Aimbot.aimAt(target: Player, bestPart: BasePart, deltaTime: number): ()
  if not target.Character then
    return
  end
  local targetPos = (bestPart :: BasePart).Position

  local camera = PlayerUtils.getCamera()
  -- Calculate LookVector needed
  local currentCFrame = camera.CFrame
  local lookAtCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)

  if not State.cameraController or not State.cameraController.SetRotation then
    local alpha = 1
    if not Helpers.isMaxSmoothness() then
      local speed = Constants.MIN_AIM_SPEED
        + (1 - State.smoothness) * (Constants.MAX_AIM_SPEED - Constants.MIN_AIM_SPEED)
      alpha = 1 - math.exp(-speed * deltaTime)
    end
    camera.CFrame = currentCFrame:Lerp(lookAtCFrame, alpha)
    return
  end

  local x, y, _ = lookAtCFrame:ToOrientation()
  local targetRotation = Vector2.new(x, y)

  -- Smoothness
  if Helpers.isMaxSmoothness() then
    State.cameraController:SetRotation(targetRotation)
  elseif State.smoothness > 0 then
    local currentRot = State.cameraController.Rotation :: Vector2
    local speed = Constants.MIN_AIM_SPEED
      + (1 - State.smoothness) * (Constants.MAX_AIM_SPEED - Constants.MIN_AIM_SPEED)
    local alpha = 1 - math.exp(-speed * deltaTime)
    local newRot = currentRot:Lerp(targetRotation, alpha)
    State.cameraController:SetRotation(newRot)
  else
    State.cameraController:SetRotation(targetRotation)
  end
end

return Aimbot
