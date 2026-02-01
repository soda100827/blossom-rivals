--!strict

-- Services

-- Dependencies (require)
local ExecutorUtils = require("src/shared/ExecutorUtils")

-- Constants

-- Types
type HookFunction = (target: (...unknown) -> ...unknown, hook: (...unknown) -> ...unknown) -> (...unknown) -> ...unknown
type NewCClosure = (func: (...unknown) -> ...unknown) -> (...unknown) -> ...unknown

type LoggerInstance = {
  warn: (self: LoggerInstance, ...unknown) -> (),
  warnUnsupported: ((self: LoggerInstance, name: string) -> ())?,
}

type Maid = {
  GiveTask: (self: Maid, task: unknown) -> (),
}

export type HookUtils = {
  safeHook: (
    targetTable: { [string]: unknown },
    targetKey: string,
    replacement: (...unknown) -> ...unknown,
    logger: LoggerInstance?,
    maid: Maid?
  ) -> (...unknown) -> ...unknown,
}

-- Private state
local Module = {}
Module.__index = Module

local _maid: Maid? = nil
local _state: { [string]: unknown } = {}
local _signals: { [string]: unknown } = {}

-- Private helpers

-- Public API
function Module.safeHook(
  targetTable: { [string]: unknown },
  targetKey: string,
  replacement: (...unknown) -> ...unknown,
  _logger: LoggerInstance?,
  maid: Maid?
): (...unknown) -> ...unknown
  local targetFunc = targetTable[targetKey] :: (...unknown) -> ...unknown
  local hookfunction = (ExecutorUtils.getGlobal("hookfunction") or ExecutorUtils.getGlobal("replaceclosure")) :: HookFunction
  local newcclosure = ExecutorUtils.getGlobal("newcclosure") :: NewCClosure
  local wrapped = newcclosure(replacement)
  local old = hookfunction(targetFunc, wrapped)
  if maid then
    maid:GiveTask(function()
      hookfunction(targetFunc, old)
    end)
  end
  return old
end

return Module
