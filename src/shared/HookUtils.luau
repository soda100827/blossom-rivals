--!strict

--// Services

--// Dependencies (require)
local ExecutorUtils = require("./ExecutorUtils")

--// Constants

--// Types
export type HookUtils = {
  safeHook: (targetTable: any, targetKey: string, replacement: any, logger: any, maid: any) -> any,
}

--// Private state
local HookUtils = {}
HookUtils.__index = HookUtils

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers

--// Public API
function HookUtils.safeHook(targetTable: any, targetKey: string, replacement: any, logger: any, maid: any): any
  local targetFunc = targetTable[targetKey]
  if not targetFunc or type(targetFunc) ~= "function" then
    return nil
  end

  local hookfunction = ExecutorUtils.getGlobal("hookfunction") or ExecutorUtils.getGlobal("replaceclosure")
  local newcclosure = ExecutorUtils.getGlobal("newcclosure") or function(f)
    return f
  end

  -- Ensure replacement is wrapped
  local wrapped = newcclosure(replacement)

  if hookfunction then
    local success, old = pcall(function()
      return hookfunction(targetFunc, wrapped)
    end)
    if success then
      if maid then
        maid:GiveTask(function()
          local restoreHook = ExecutorUtils.getGlobal("hookfunction")
            or ExecutorUtils.getGlobal("replaceclosure")
          if restoreHook then
            pcall(function()
              restoreHook(targetFunc, old)
            end)
          else
            targetTable[targetKey] = old
          end
        end)
      end
      return old
    end
    if logger and logger.warnUnsupported then
      logger:warnUnsupported("hookfunction")
    elseif logger then
      logger:warn("This executor does not support 'hookfunction'. Some features may not work as expected.")
    end
  else
    if logger and logger.warnUnsupported then
      logger:warnUnsupported("hookfunction")
    elseif logger then
      logger:warn("This executor does not support 'hookfunction'. Some features may not work as expected.")
    end
  end

  -- Fallback
  targetTable[targetKey] = wrapped
  if maid then
    maid:GiveTask(function()
      if targetTable[targetKey] == wrapped then
        targetTable[targetKey] = targetFunc
      end
    end)
  end
  return targetFunc
end

return HookUtils
