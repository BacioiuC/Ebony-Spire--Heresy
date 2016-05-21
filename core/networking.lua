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

local socket = require("socket")
local ser = require "core.ser"


-----------------------------------------------------------

mServer = {}

-- server stuff
function mServer:initServer(_ip, _port)
	self._ip = _ip
	self._port = _port
	self._timeOutPing = "anyoneHome?"
	self._timeOutResponse = "yes"
	self._serverTimer = Game.worldTimer
	if _ip == nil and _port == nil then
		self._ip, self._port = server:getsockname()
	else 
		self._ip = _ip
		self._port = _port
	end
	self._server = assert(socket.bind(""..self._ip.."", self._port))

	self._clientList = { }

	print("Server has been initialized")
end

function mServer:returnNrOfClients( )
	return #self._clientList
end

function mServer:newClient(_client, _timeOut)
	-- first, check to see if the same client isn't alreadt in the list
	local cBool = false
	--[[for i,v in ipairs(self._clientList) do
		if v.client == _client then
			cBool = true
		end
	end--]]
	print("Type of _client is: "..type(_client).."")
	if cBool == false then
		local temp = { 
			client = _client,
			timeOut = _timeOut,
			id = #self._clientList+1,
			wasPinged = false,
			pingTime = nil,
		}

		temp.client:settimeout(temp.timeOut)
		table.insert(self._clientList, temp)
	end
end

function mServer:clientListen(_client)
	local v = _client
	local data, err = v:receive( )

	return data, err
end

function mServer:deser(_data)
	local data = nil
	if _data ~= nil then
		data = load(_data)() -- create a table out of it
	end

	return data -- return it as a table
end

function mServer:ser(_data)
	local serializedData = ser(_data)

	return serializedData
end

function mServer:sendMessage(_client, _string)
	local v = _client
	local result = v:send(_string)
	return result
end

function mServer:getClientList( )
	return self._clientList
end

function mServer:broadcastToAllClients(_string)
	local result = nil
	if self._clientList ~= nil then
		for i,v in ipairs( self._clientList ) do
			--print("SENDING MESSAGE: "..i.." + ".._string.."")
			result = self:sendMessage(v.client, _string)
		end
	end
	return result
end

function mServer:closeClient(_client)
	local v = _client
	v.client:close( )
	table.remove(self._clientList, v.id)
	for i,v in ipairs(self._clientList) do
		v.id = i
	end
end


function mServer:closeServer( )
	self._server:close( )
	print("Server has been closed")
end

function mServer:acceptCon( )
	self._server:settimeout(0)
	return self._server:accept( )
end

function mServer:listen( )

end

function mServer:sendTimeOutCheck(_id)
	--for i,v in ipairs(self._clientList) do
	local v = self._clientList[_id]

	local result = self:sendMessage(v.client, self._timeOutPing)
	v.wasPinged = true
	v.pingTime = Game.worldTimer

	print("RESTULT TYPE: "..type(result).."")
	return result
	--end
end


function mServer:checkTimeout( )

	if Game.worldTimer > self._serverTimer + 2 then

		for i,v in ipairs(self._clientList) do
			--local message, err = v.client:receive( )
			local result = self:sendTimeOutCheck(i)

			if result == nil then -- no error
				self:closeClient(v)
			end
		end

		self._serverTimer = Game.worldTimer
	end
end

----------------------------------------------------------

mClient = {}

function mClient:init( )
	self._serverIP = nil
	self._serverPORT = nil
	self._timeOutPing = "anyoneHome?"
	self._timeOutResponse = "yes"
	self._isConnected = false
	self._clientTime = Game.worldTimer
	--local host, port = "127.0.0.1", 1341
	self._socket = require("socket")
	--self._socket
	self._tcp = assert(self._socket.tcp())

	
end

function mClient:listenForTimeoutPings( )
	s, status, partial = self._tcp:receive()

	if s or partial == self._timeOutPing then
		self:sendMessage(self._timeOutResponse)
		--print('message sent')
	end
end

function mClient:connectTo(_serverIP, _serverPort)

	if self._isConnected == false then
		if _serverIP == nil or _serverPort == nil then
			self._serverIP = "127.0.0.1"
			self._serverPORT = 1337
		else
			self._serverIP = _serverIP
			self._serverPORT = _serverPort
		end

		assert(self._tcp:connect(self._serverIP, self._serverPORT));
		self._tcp:settimeout(0)
	end
end


function mClient:sendMessage(_string)
	if self._tcp ~= nil then
		self._tcp:send("".._string.."\n");
	else
		print("NO TCP in mClient:SendMessage ~227")
	end
end

function mClient:listen( )
	return self._tcp:receive()
end

function mClient:disconnect( )
	self._tcp:close()
end

function mClient:checkConnection( )
	local oldPing = self._isConnected

	if Game.worldTimer > self._clientTime + 4 then
		local tPing = self._tcp:send("Ping")
		oldPing = tPing
	end
	return oldPing
end

function mClient:isConnected( )
	if self:checkConnection( ) == nil then
		self._isConnected = false
	else
		self._isConnected = true
	end

	return self._isConnected
end