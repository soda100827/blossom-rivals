local __DARKLUA_BUNDLE_MODULES = { cache = {} }
do
	do
		local function __modImpl()
			local Logger = {}
			Logger.__index = Logger
			function Logger.new(source)
				return setmetatable({
					Source = source or "System",
				}, Logger)
			end
			function Logger:Info(...)
				print(string.format("[\27[34m%s\27[0m] ", self.Source), ...)
			end
			function Logger:Warn(...)
				warn(string.format("[%s] ", self.Source), ...)
			end
			function Logger:Error(...)
				error(string.format("[%s] ", self.Source) .. ..., 0)
			end
			return Logger
		end
		function __DARKLUA_BUNDLE_MODULES.a()
			local v = __DARKLUA_BUNDLE_MODULES.cache.a
			if not v then
				v = { c = __modImpl() }
				__DARKLUA_BUNDLE_MODULES.cache.a = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local ScriptSignal = {}
			ScriptSignal.__index = ScriptSignal
			local ScriptConnection = {}
			ScriptConnection.__index = ScriptConnection
			function ScriptSignal.new()
				return setmetatable({ _active = true, _head = nil }, ScriptSignal)
			end
			function ScriptSignal.Is(object)
				return typeof(object) == "table" and getmetatable(object) == ScriptSignal
			end
			function ScriptSignal:IsActive()
				return self._active == true
			end
			function ScriptSignal:Connect(handler)
				assert(typeof(handler) == "function", "Must be function")
				if self._active ~= true then
					return setmetatable({ Connected = false, _node = nil }, ScriptConnection)
				end
				local _head = self._head
				local node = { _signal = self, _connection = nil, _handler = handler, _next = _head, _prev = nil }
				if _head ~= nil then
					_head._prev = node
				end
				self._head = node
				local connection = setmetatable({ Connected = true, _node = node }, ScriptConnection)
				node._connection = connection
				return connection
			end
			function ScriptSignal:Once(handler)
				assert(typeof(handler) == "function", "Must be function")
				local connection
				connection = self:Connect(function(...)
					if connection == nil then
						return
					end
					connection:Disconnect()
					connection = nil
					handler(...)
				end)
				return connection
			end
			ScriptSignal.ConnectOnce = ScriptSignal.Once
			function ScriptSignal:Wait()
				local thread
				do
					thread = coroutine.running()
					local connection
					connection = self:Connect(function(...)
						if connection == nil then
							return
						end
						connection:Disconnect()
						connection = nil
						if coroutine.status(thread) == "suspended" then
							task.spawn(thread, ...)
						end
					end)
				end
				return coroutine.yield()
			end
			function ScriptSignal:Fire(...)
				local node = self._head
				while node ~= nil do
					task.defer(node._handler, ...)
					node = node._next
				end
			end
			function ScriptSignal:DisconnectAll()
				local node = self._head
				while node ~= nil do
					local _connection = node._connection
					if _connection ~= nil then
						_connection.Connected = false
						_connection._node = nil
						node._connection = nil
					end
					node = node._next
				end
				self._head = nil
			end
			function ScriptSignal:Destroy()
				if self._active ~= true then
					return
				end
				self:DisconnectAll()
				self._active = false
			end
			function ScriptConnection:Disconnect()
				if self.Connected ~= true then
					return
				end
				self.Connected = false
				local _node = self._node
				local _prev = _node._prev
				local _next = _node._next
				if _next ~= nil then
					_next._prev = _prev
				end
				if _prev ~= nil then
					_prev._next = _next
				else
					_node._signal._head = _next
				end
				_node._connection = nil
				self._node = nil
			end
			ScriptConnection.Destroy = ScriptConnection.Disconnect
			return ScriptSignal
		end
		function __DARKLUA_BUNDLE_MODULES.b()
			local v = __DARKLUA_BUNDLE_MODULES.cache.b
			if not v then
				v = { c = __modImpl() }
				__DARKLUA_BUNDLE_MODULES.cache.b = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Movement = { Enabled = false, Connections = {} }
			function Movement:Init(Client)
				self.Client = Client
				self.Logger = Client.Logger
				self.Logger:Info("Movement loaded")
			end
			function Movement:Toggle(state)
				self.Enabled = state
				if state then
					self.Logger:Info("Movement Enabled")
				else
					self.Logger:Info("Movement Disabled")
				end
			end
			function Movement:Cleanup()
				self:Toggle(false)
			end
			return Movement
		end
		function __DARKLUA_BUNDLE_MODULES.c()
			local v = __DARKLUA_BUNDLE_MODULES.cache.c
			if not v then
				v = { c = __modImpl() }
				__DARKLUA_BUNDLE_MODULES.cache.c = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local RunService = game:GetService("RunService")
			local Visuals = { Enabled = false, Connections = {} }
			function Visuals:Init(Client)
				self.Client = Client
				self.Logger = Client.Logger
				self.Logger:Info("Visuals loaded")
			end
			function Visuals:Toggle(state)
				self.Enabled = state
				if state then
					self:Enable()
				else
					self:Disable()
				end
			end
			function Visuals:Enable()
				self.Logger:Info("ESP Enabled")
				table.insert(self.Connections, RunService.RenderStepped:Connect(function() end))
			end
			function Visuals:Disable()
				self.Logger:Info("ESP Disabled")
				for _, conn in ipairs(self.Connections) do
					conn:Disconnect()
				end
				self.Connections = {}
			end
			function Visuals:Cleanup()
				self:Disable()
			end
			return Visuals
		end
		function __DARKLUA_BUNDLE_MODULES.d()
			local v = __DARKLUA_BUNDLE_MODULES.cache.d
			if not v then
				v = { c = __modImpl() }
				__DARKLUA_BUNDLE_MODULES.cache.d = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local task = nil
			local Types = require(script.Types)
			local External = require(script.External)
			do
				local RobloxExternal = require(script.RobloxExternal)
				External.setExternalProvider(RobloxExternal)
			end
			local Fusion = table.freeze({
				version = { major = 0, minor = 3, isRelease = true },
				Contextual = require(script.Utility.Contextual),
				Safe = require(script.Utility.Safe),
				cleanup = require(script.Memory.legacyCleanup),
				deriveScope = require(script.Memory.deriveScope),
				doCleanup = require(script.Memory.doCleanup),
				innerScope = require(script.Memory.innerScope),
				scoped = require(script.Memory.scoped),
				Observer = require(script.Graph.Observer),
				Computed = require(script.State.Computed),
				ForKeys = (require(script.State.ForKeys)),
				ForPairs = (require(script.State.ForPairs)),
				ForValues = (require(script.State.ForValues)),
				peek = require(script.State.peek),
				Value = require(script.State.Value),
				Attribute = require(script.Instances.Attribute),
				AttributeChange = require(script.Instances.AttributeChange),
				AttributeOut = require(script.Instances.AttributeOut),
				Child = require(script.Instances.Child),
				Children = require(script.Instances.Children),
				Hydrate = require(script.Instances.Hydrate),
				New = require(script.Instances.New),
				OnChange = require(script.Instances.OnChange),
				OnEvent = require(script.Instances.OnEvent),
				Out = require(script.Instances.Out),
				Tween = require(script.Animation.Tween),
				Spring = require(script.Animation.Spring),
			})
			return Fusion
		end
		function __DARKLUA_BUNDLE_MODULES.e()
			local v = __DARKLUA_BUNDLE_MODULES.cache.e
			if not v then
				v = { c = __modImpl() }
				__DARKLUA_BUNDLE_MODULES.cache.e = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Theme = {
				Background = Color3.fromRGB(25, 25, 35),
				Header = Color3.fromRGB(30, 30, 45),
				Accent = Color3.fromRGB(100, 150, 255),
				Text = Color3.fromRGB(240, 240, 240),
				TextDim = Color3.fromRGB(150, 150, 150),
				Border = Color3.fromRGB(50, 50, 60),
				ElementBackground = Color3.fromRGB(35, 35, 45),
				ElementHover = Color3.fromRGB(45, 45, 55),
			}
			function Theme:GetColor(key)
				return self[key] or Color3.new(1, 0, 1)
			end
			return Theme
		end
		function __DARKLUA_BUNDLE_MODULES.f()
			local v = __DARKLUA_BUNDLE_MODULES.cache.f
			if not v then
				v = { c = __modImpl() }
				__DARKLUA_BUNDLE_MODULES.cache.f = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local UserInputService = game:GetService("UserInputService")
			local Fusion = __DARKLUA_BUNDLE_MODULES.e()
			local Theme = __DARKLUA_BUNDLE_MODULES.f()
			local New = Fusion.New
			local Children = Fusion.Children
			local OnEvent = Fusion.OnEvent
			local State = Fusion.Value
			local function Window(props)
				local position = State(UDim2.new(0.5, -250, 0.5, -175))
				local isDragging = false
				local dragStart = Vector2.new(0, 0)
				local startPos = UDim2.new(0, 0, 0, 0)
				local function InputBegan(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						isDragging = true
						dragStart = input.Position
						startPos = position:get()
					end
				end
				UserInputService.InputChanged:Connect(function(input)
					if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						local delta = input.Position - dragStart
						local newPos = UDim2.new(
							startPos.X.Scale,
							startPos.X.Offset + delta.X,
							startPos.Y.Scale,
							startPos.Y.Offset + delta.Y
						)
						position:set(newPos)
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						isDragging = false
					end
				end)
				return New("Frame")({
					Name = "MainWindow",
					Size = props.Size or UDim2.new(0, 500, 0, 350),
					Position = position,
					BackgroundColor3 = Theme.Background,
					BorderSizePixel = 0,
					[Children] = {
						New("UICorner")({ CornerRadius = UDim.new(0, 8) }),
						New("UIStroke")({ Color = Theme.Border, Thickness = 1 }),
						New("Frame")({
							Name = "Header",
							Size = UDim2.new(1, 0, 0, 40),
							BackgroundColor3 = Theme.Header,
							[OnEvent("InputBegan")] = InputBegan,
							[Children] = {
								New("UICorner")({ CornerRadius = UDim.new(0, 8) }),
								New("Frame")({
									Size = UDim2.new(1, 0, 0, 10),
									Position = UDim2.new(0, 0, 1, -10),
									BackgroundColor3 = Theme.Header,
									BorderSizePixel = 0,
								}),
								New("TextLabel")({
									Size = UDim2.new(1, -20, 1, 0),
									Position = UDim2.new(0, 20, 0, 0),
									BackgroundTransparency = 1,
									Text = props.Title,
									TextColor3 = Theme.Text,
									Font = Enum.Font.GothamBold,
									TextSize = 16,
									TextXAlignment = Enum.TextXAlignment.Left,
								}),
							},
						}),
						New("ScrollingFrame")({
							Size = UDim2.new(1, -20, 1, -50),
							Position = UDim2.new(0, 10, 0, 45),
							BackgroundTransparency = 1,
							ScrollBarThickness = 2,
							ScrollBarImageColor3 = Theme.Accent,
							AutomaticCanvasSize = Enum.AutomaticSize.Y,
							CanvasSize = UDim2.new(0, 0, 0, 0),
							BorderSizePixel = 0,
							[Children] = {
								New("UIListLayout")({
									Padding = UDim.new(0, 5),
									SortOrder = Enum.SortOrder.LayoutOrder,
								}),
								props[Children],
							},
						}),
					},
				})
			end
			return Window
		end
		function __DARKLUA_BUNDLE_MODULES.g()
			local v = __DARKLUA_BUNDLE_MODULES.cache.g
			if not v then
				v = { c = __modImpl() }
				__DARKLUA_BUNDLE_MODULES.cache.g = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local Fusion = __DARKLUA_BUNDLE_MODULES.e()
			local Theme = __DARKLUA_BUNDLE_MODULES.f()
			local New = Fusion.New
			local Children = Fusion.Children
			local OnEvent = Fusion.OnEvent
			local State = Fusion.Value
			local Spring = Fusion.Spring
			local Computed = Fusion.Computed
			local function Toggle(props)
				local state = props.State or State(false)
				local callback = props.Callback or function() end
				local anim = Spring(
					Computed(function()
						return state:get() and 1 or 0
					end),
					25,
					0.8
				)
				return New("TextButton")({
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = Theme.ElementBackground,
					Text = "",
					AutoButtonColor = false,
					[OnEvent("MouseButton1Click")] = function()
						local newState = not state:get()
						state:set(newState)
						task.spawn(callback, newState)
					end,
					[Children] = {
						New("UICorner")({ CornerRadius = UDim.new(0, 6) }),
						New("TextLabel")({
							Size = UDim2.new(1, -50, 1, 0),
							Position = UDim2.new(0, 10, 0, 0),
							BackgroundTransparency = 1,
							TextColor3 = Theme.Text,
							TextXAlignment = Enum.TextXAlignment.Left,
							Font = Enum.Font.GothamMedium,
							TextSize = 14,
							Text = props.Title,
						}),
						New("Frame")({
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -10, 0.5, 0),
							Size = UDim2.new(0, 40, 0, 20),
							BackgroundColor3 = Computed(function()
								return state:get() and Theme.Accent or Theme.ElementHover
							end),
							[Children] = {
								New("UICorner")({
									CornerRadius = UDim.new(1, 0),
								}),
								New("Frame")({
									AnchorPoint = Vector2.new(0, 0.5),
									Size = UDim2.new(0, 16, 0, 16),
									Position = Computed(function()
										local alpha = anim:get()
										return UDim2.new(0, 2 + (20 * alpha), 0.5, 0)
									end),
									BackgroundColor3 = Theme.Text,
									[Children] = { New("UICorner")({ CornerRadius = UDim.new(1, 0) }) },
								}),
							},
						}),
					},
				})
			end
			return Toggle
		end
		function __DARKLUA_BUNDLE_MODULES.h()
			local v = __DARKLUA_BUNDLE_MODULES.cache.h
			if not v then
				v = { c = __modImpl() }
				__DARKLUA_BUNDLE_MODULES.cache.h = v
			end
			return v.c
		end
	end
	do
		local function __modImpl()
			local RunService = game:GetService("RunService")
			local Fusion = __DARKLUA_BUNDLE_MODULES.e()
			local Window = __DARKLUA_BUNDLE_MODULES.g()
			local Toggle = __DARKLUA_BUNDLE_MODULES.h()
			local New = Fusion.New
			local Children = Fusion.Children
			local Interface = {}
			function Interface:Init(Client)
				self.Client = Client
				self.Logger = Client.Logger
				local success, target = pcall(function()
					return game:GetService("CoreGui")
				end)
				if not success then
					target = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
				end
				self.Target = target
				self:Mount()
			end
			function Interface:Mount()
				if self.Target:FindFirstChild("BlossomUI") then
					self.Target.BlossomUI:Destroy()
				end
				local App = New("ScreenGui")({
					Name = "BlossomUI",
					Parent = self.Target,
					ResetOnSpawn = false,
					DisplayOrder = 100,
					[Children] = {
						Window({
							Title = "Blossom " .. self.Client.Version,
							[Children] = {
								Toggle({
									Title = "Movement Assist",
									Callback = function(state)
										local mod = self.Client.Modules.Movement
										if mod and mod.Toggle then
											mod:Toggle(state)
										end
									end,
								}),
								Toggle({
									Title = "Visuals (ESP)",
									Callback = function(state)
										local mod = self.Client.Modules.Visuals
										if mod and mod.Toggle then
											mod:Toggle(state)
										end
									end,
								}),
							},
						}),
					},
				})
				self.Instance = App
				self.Logger:Info("UI mounted successfully")
			end
			function Interface:Cleanup()
				if self.Instance then
					self.Instance:Destroy()
				end
			end
			return Interface
		end
		function __DARKLUA_BUNDLE_MODULES.i()
			local v = __DARKLUA_BUNDLE_MODULES.cache.i
			if not v then
				v = { c = __modImpl() }
				__DARKLUA_BUNDLE_MODULES.cache.i = v
			end
			return v.c
		end
	end
end
local Services = {
	Players = game:GetService("Players"),
	RunService = game:GetService("RunService"),
	UserInputService = game:GetService("UserInputService"),
}
local Logger = __DARKLUA_BUNDLE_MODULES.a()
local Signal = __DARKLUA_BUNDLE_MODULES.b()
local Client = {
	Version = "1.0.0",
	Logger = Logger.new("Blossom"),
	Events = { Started = Signal.new(), Stopped = Signal.new() },
	Modules = {},
	IsRunning = false,
}
function Client:LoadModule(name, moduleOrPath)
	local loader = function()
		if type(moduleOrPath) == "string" then
			return require(moduleOrPath)
		end
		return moduleOrPath
	end
	local success, result = pcall(loader)
	if success then
		self.Modules[name] = result
		if result.Init then
			task.spawn(function()
				result:Init(self)
			end)
		end
		self.Logger:Info("Loaded module:", name)
	else
		self.Logger:Warn("Failed to load module:", name, result)
	end
end
function Client:Start()
	if self.IsRunning then
		return
	end
	self.IsRunning = true
	self.Logger:Info("Client initializing...")
	self:LoadModule("Movement", __DARKLUA_BUNDLE_MODULES.c())
	self:LoadModule("Visuals", __DARKLUA_BUNDLE_MODULES.d())
	self:LoadModule("Interface", __DARKLUA_BUNDLE_MODULES.i())
	self.Events.Started:Fire()
end
function Client:Stop()
	self.IsRunning = false
	self.Events.Stopped:Fire()
	for name, module in pairs(self.Modules) do
		if module.Cleanup then
			pcall(module.Cleanup, module)
		end
	end
	self.Logger:Info("Client stopped.")
end
return Client:Start()
