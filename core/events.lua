--[[
* The MIT License
* Copyright (C) 2014 Bacioiu "Zapa" Ciprian (bacioiu.ciprian@gmail.com).  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom th be Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

event = {}

function event:init( )
	self._eventTable = { }
	--types of events
	--[[


	--]]
	unit_spawned_event = 1
	unit_moved_event = 2
	unit_battle_event = 3
	unit_killed_event = 4
	building_captured_event = 5
	factory_captured_event = 6

	
end

function event:sendEvent( event_type, _data1, _data2 )
	-- first param = event identifier
	-- second and third = data params
	-- example: sendEvent( unit_spawned_event, unit.team, unit.type )
	local temp = {
		id = #self._eventTable+1,
		data1 = _data1,
		data2 = _data2,
	}
	table.insert(self._eventTable, temp)
end

function event:listener( )

end