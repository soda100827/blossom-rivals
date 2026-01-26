# AGENTS.md — Roblox (Luau) Non-Negotiable Style Rules

> Below rules are mandatory. No exceptions.  
> Regardless of file/module size or how code is split, **structure, naming, and patterns must remain identical**.

## 0) Mandatory Baseline
- Every Luau file **must** start with `--!strict`
- Every file **must** follow the exact section order described in **File Template**.
- If anything changes (team member, module split, feature scope), **style does not change**.

---

## 1) File Template — Fixed Order, No Missing Sections
All files must keep the following order **exactly**.  
Even if a section is empty, keep the header comment for consistency.

1. `--!strict`
2. `--// Services`
3. `--// Dependencies (require)`
4. `--// Constants`
5. `--// Types`
6. `--// Private state`
7. `--// Private helpers`
8. `--// Public API`
9. `return <Module>`

---

## 2) Naming — No Exceptions
- **PascalCase**: modules, class-like tables, types, components  
  - `InventoryService`, `PlayerProfile`, `FastSignal`
- **camelCase**: functions, methods, locals  
  - `getProfile`, `playerProfile`
- **UPPER_SNAKE_CASE**: constants  
  - `MAX_SPEED`, `DEFAULT_COOLDOWN`
- **Booleans** must start with: `is/has/can/should`  
  - `isReady`, `hasLoaded`, `canOpen`, `shouldRespawn`
- **Private fields/functions** must start with `_`  
  - `_maid`, `_signals`, `_state`, `_connect()`

---

## 3) Formatting — Must Look Automatic
- Indentation: **2 spaces** (project-wide fixed)
- Space after operators/commas: `a + b`, `f(x, y)`
- Strings use `""` by default
- Tables may use trailing commas (keep consistent)
- If a line gets too long, wrap by meaning (no arbitrary wrapping)

---

## 4) Services & require — Top Only, One Way Only
- Services **must** use: `game:GetService("ServiceName")`
- `require()` must use the project’s agreed root paths only (no ad-hoc paths)
- Services section always comes before Dependencies section (never mixed)

---

## 5) Types — Public API Always Typed
- Exported types: `export type X = ...`
- Public functions **must** type all params and returns
- Avoid `any`. If absolutely unavoidable, add a short “why” comment.

---

## 6) Event Connections — **MUST use Maid**
- Every `:Connect()` **must** be registered to Maid immediately.
- No exceptions like “just once” or “temporary listener”.
- Allowed patterns (choose one and keep it project-wide):
  - `_maid:GiveTask(connection)`
  - `_maid:GiveTask(function() connection:Disconnect() end)` (only if that is the single chosen pattern)

Additional hard rules:
- All connection wiring must live inside a private `_connect()` function.
- `Init/Start` entrypoints only call `_connect()` (do not mix logic + wiring).

---

## 7) Signals — **MUST use FastSignal**
- Custom signals/events **must** use **FastSignal**.
- Do not emulate signals using `BindableEvent`.
- Signals must be stored in `_signals` and created with `FastSignal.new()`.

Storage rule (hard):
- Maintain a `_signals` table and store all signals there.

Exposure rule (pick one approach and never mix in the project):
- Option A: expose via getters `Get<SignalName>()`
- Option B: expose via module properties `<SignalName>`

Do not mix A and B in the same codebase.

---

## 8) State & Resource Management — Structured Always
Every module/controller must use these private fields by convention:
- `_maid` (required)
- `_state` (table for state)
- `_signals` (table of FastSignal instances)
- `_connections` (optional only if truly needed beyond Maid; prefer Maid)

Cleanup rule:
- Provide a single lifecycle cleanup function project-wide: either `Destroy()` **or** `Shutdown()` (choose one).
- Cleanup must call `_maid:DoCleaning()` (or equivalent Maid cleanup method).

---

## 9) Control Flow — Guard First, No Deep Nesting
- Prefer early returns: `if not condition then return end`
- If nesting reaches 3+ levels, split into helpers.

---

## 10) Comments — “Why” Only, Fixed TODO Format
- Comments should explain **why**, not what.
- TODO format is fixed:
  - `-- TODO(PREMIUMISME): ...`

---

# Standard Module Skeleton (Copy/Paste Start Point)

Keep section headers and order unchanged.

```lua
--!strict

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Dependencies (require)
-- local Maid = require(...)
-- local FastSignal = require(...)

--// Constants
local DEFAULT_COOLDOWN = 1

--// Types
export type Example = {
	id: string,
}

--// Private state
local Module = {}
Module.__index = Module

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers
local function _initSignals()
	-- _signals.SomeEvent = FastSignal.new()
end

local function _connect()
	-- local conn = SomeInstance.Event:Connect(function() end)
	-- _maid:GiveTask(conn)
end

--// Public API
function Module.Init()
	_initSignals()
	_connect()
end

function Module.Destroy()
	-- _maid:DoCleaning()
end

return Module
```
