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

anim = {}

function anim:init(_timer)
	self._animTable = {}
	self._animPool = {} -- all anims here loop without outside interaction
	self._stateTable = {}
	--[[
	anim table:
	- tex = deck texture
	- img - actual

	]]
	self._timer = _timer
end

function anim:newDeck(_deckName, _tileSize, _layer)
	local temp = { }
	temp.anim = image:newDeckTexture(_deckName, _layer, _deckName, _tileSize, "Not Nill")
	temp.tileSize = _tileSize
	temp.layer = _layer
	--table.insert(self._animTable, temp)
	return temp
end

function anim:newAnim(_deckPointer, _nrFrames, _x, _y, _index)
	local temp = {
		id = #self._animTable+1,
		img = image:newDeckImage(_deckPointer.anim, _x, _y, _index),
		startFrame = 1,
		currentFrame = 1,
		endFrame = _nrFrames,
		animTimer = self._timer,
		speed = 0.04,
		isInPool = false,
		poolIndex = nil,
		x = _x,
		y = _y,
		state = nil,
		layer = _deckPointer.layer,
		nextState = nil,
		flip = false,
	} 
	table.insert(self._animTable, temp)
	return temp
end

function anim:updateAnim(_anim, _x, _y, _forced)

	if _anim.isInPool == false then
		if self._timer > _anim.animTimer + _anim.speed then
			if _anim.currentFrame < _anim.endFrame then
				_anim.currentFrame = _anim.currentFrame + 1
				
			else
				if _anim.nextState ~= nil then
					anim:setState(_anim, _anim.nextState)
					_anim.nextState = nil
				else
					_anim.currentFrame = _anim.startFrame
				end
			end
			_anim.animTimer = self._timer
		end
			local flipIndex = 0
			if _anim.flip == true then
				flipIndex = 0
			end

		image:setIndex(_anim.img, _anim.currentFrame + flipIndex )

		if _x ~= nil and _forced == nil then
		
			_anim.x = _x
			_anim.y = _y
		end

		--if _x ~= _anim.x or _y ~= _anim.y then
		image:updateImage(_anim.img, _anim.x, _anim.y)
		--end
	end
end

function anim:delete(_anim, _layer)
	--print("ANIMATION LAYER IS: ".._anim.layer.."")
	if _anim.img ~= nil then
		image:removeProp(_anim.img,  _anim.layer)
		_anim.img = nil
	end
	--print("HERE BE A PROBLEM")
	
	--table.remove(self._animTable, _anim.id)
end

function anim:dropAll( )
	for i = 1, #self._animTable, -1 do
		if self._animTable[i] ~= nil then
			if self._animTable[i].img ~= nil then
				anim:delete(self._animTable[i].img, 2)
			end
		end
	end


	for i,v in ipairs(self._animTable) do
		if v.img ~= nil then
			anim:delete(v)
		end
	end

	self._animTable = {}
end

function anim:addToPool(_anim)
	table.insert(self._animPool, _anim)
	_anim.poolIndex = #self._animPool
	_anim.isInPool = true

end

function anim:setSpeed(_anim, _speed)
	_anim.speed = _speed
end

function anim:removeFromPool(_anim)
	table.remove(self._animPool, _anim.poolIndex)
	_anim.poolIndex = nil
end

function anim:updatePool( )
	for i,v in ipairs(self._animPool) do 
		if self._timer > v.animTimer + v.speed then
			if v.currentFrame < v.endFrame then
				v.currentFrame = v.currentFrame + 1
			else
				if v.nextState ~= nil then
					anim:setState(v.nextState)
					v.nextState = nil
				else
					v.currentFrame = v.startFrame
				end
			end
			v.animTimer = self._timer
			local flipIndex = 0
			if v.flip == true then
				flipIndex = 0
			end
			image:setIndex(v.img, v.currentFrame + flipIndex)
			image:updateImage(v.img, v.x, v.y)
		end
	end
end

function anim:getCurrentFrame(_anim)
	return _anim.currentFrame
end

function anim:getLastFrame(_anim)
	return _anim.endFrame
end

function anim:setPosition(_anim, _x, _y)
	_anim.x = _x
	_anim.y = _y
end

function anim:flip(_anim, _bool)
	_anim.flip = _bool
end

function anim:getPosition(_anim)
	return _anim.x, _anim.y
end

function anim:update(_dt)
	self._timer = _dt
	anim:updatePool( )
end

function anim:createState(_name, _startFrame, _endFrame, _speed)
	local temp = {
		name = _name, -- string.. ALWAYS
		startFrame = _startFrame,
		endFrame = _endFrame,
		speed = _speed,
	}
	table.insert(self._stateTable, temp)
end

function anim:setState(_anim, _state, _nextState)
	if _anim.img ~= nil then
		if (_anim.state ~= _state ) or (_anim.state == _state and _nextState ~= nil) then
			local stTable = self._stateTable[anim:_getStateIndex(_state)]
			_anim.startFrame = stTable.startFrame
			_anim.endFrame = stTable.endFrame
			_anim.currentFrame = stTable.startFrame
			_anim.speed = stTable.speed
			_anim.state = _state
			_anim.nextState = _nextState
			image:setIndex(_anim.img, stTable.startFrame)
		end
	end

end

function anim:getState(_anim)
	return _anim.state
end

function anim:_getStateIndex(_stateName)
	local stateIndex = nil
	for i,v in ipairs(self._stateTable) do
		if v.name == _stateName then
			stateIndex = i
		end
	end

	return stateIndex
end

function anim:removeStateFromAnim( )

end
