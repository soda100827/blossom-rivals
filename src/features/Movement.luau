--!strict
local Movement = {
	Enabled = false,
	Connections = {},
}

function Movement:Init(Client)
	self.Client = Client
	self.Logger = Client.Logger
end

function Movement:Toggle(state: boolean)
	self.Enabled = state
end

function Movement:Cleanup()
	self:Toggle(false)
end

return Movement
