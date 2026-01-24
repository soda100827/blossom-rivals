--!strict
local RunService = game:GetService("RunService")

local Visuals = {
	Enabled = false,
	Connections = {},
}

function Visuals:Init(Client)
	self.Client = Client
	self.Logger = Client.Logger
end

function Visuals:Toggle(state: boolean)
	self.Enabled = state
	if state then
		self:Enable()
	else
		self:Disable()
	end
end

function Visuals:Enable()
	-- Bind to RenderStepped
	table.insert(
		self.Connections,
		RunService.RenderStepped:Connect(function()
			-- Drawing logic here
		end)
	)
end

function Visuals:Disable()
	for _, conn in ipairs(self.Connections) do
		conn:Disconnect()
	end
	self.Connections = {}

	-- Clear drawings if any
end

function Visuals:Cleanup()
	self:Disable()
end

return Visuals
