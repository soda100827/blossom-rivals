--!strict
local Movement = {
	Enabled = false,
	Connections = {},
}

function Movement:Init(Client)
	self.Client = Client
	self.Logger = Client.Logger
	self.Logger:Info("Movement loaded")
end

function Movement:Toggle(state: boolean)
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
