--!strict
-- Standard Signal Implementation for RBX Scripting
local Signal = {}
Signal.__index = Signal

export type Connection = {
	Disconnect: (self: Connection) -> (),
	Connected: boolean,
}

function Signal.new()
	return setmetatable({
		_callbacks = {},
	}, Signal)
end

function Signal:Connect(callback: (...any) -> ())
	local connection = {
		Connected = true,
		Disconnect = function(self)
			if not self.Connected then
				return
			end
			self.Connected = false
			-- O(n) removal is fine for this scale
			for i, v in ipairs(self._signal._callbacks) do
				if v == self then
					table.remove(self._signal._callbacks, i)
					break
				end
			end
		end,
		_callback = callback,
		_signal = self,
	}

	table.insert(self._callbacks, connection)
	return connection
end

function Signal:Fire(...)
	for _, connection in ipairs(self._callbacks) do
		if connection.Connected then
			task.spawn(connection._callback, ...)
		end
	end
end

function Signal:Destroy()
	self._callbacks = {}
end

return Signal
