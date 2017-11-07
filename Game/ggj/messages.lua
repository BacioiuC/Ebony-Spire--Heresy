log = { }

function log:init( )
	self._logTable = { } -- where messages are stored
	self._logDisplay = 1
	self._logIndex = 1
	self._maxWidth = 80
	self._ping = false
	self._timeTillFade = 2 -- seconds
	self._logTimer = Game.worldTimer


end

function log:returnMaxWidth( )
	return self._maxWidth
end

function log:newMessage(_string)
	local temp = {
		id = #self._logTable + 1,
		content = _string,
	}
	self._ping = true --notify new message was added
	table.insert(self._logTable, temp)

	interface:pushLogMessage( )
end

function log:getLogTable( )
	return self._logTable
end

function log:RESET_LOG_TABLE( )
	if self._logTable ~= nil then
		for j = 1, #self._logTable + 1-20 do
			for i,v in ipairs(self._logTable) do
				table.remove(self._logTable, i)
			end
		end
	end

	self._logTable = {}
end

function log:listenForPing( )

end
