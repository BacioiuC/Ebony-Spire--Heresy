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

effect = {}

function effect:init( )
	self._effectTable = { }

end

function effect:new(_stringName, _x, _y, _animToUse, _maxFrames, _attachTo, _loop, _doOffset)
	local temp = {
		name = _stringName,
		id = #self._effectTable + 1,
		anim = anim:newAnim(_animToUse, _maxFrames, -2000, -2000, 1), -- 1 = deck pointer
		x = _x,
		y = _y,
		lastFrame = _maxFrames,
		attachment = _attachTo,
		isLooping = _loop,
	}

	if _doOffset ~= nil then
		temp.doOffset = _doOffset
	end
	table.insert(self._effectTable, temp)

	return temp.id
end


function effect:_getLastFrameValue(_id)
	local eff = self._effectTable[_id]
	return eff.lastFrame

end

function effect:_getAnim(_id)
	local eff = self._effectTable[_id]
	return eff.anim
end

function effect:setSpeed(_id, _speed)
	local eff = self._effectTable[_id]
	eff.speed = _speed
	anim:setSpeed(eff.anim, eff.speed )
end

function effect:updateEffect(_id, _x, _y)
	local eff = self._effectTable[_id]
	local offsetX, offsetY = 68, 64
	local tileSize = 64
	eff.x = _x 
	eff.y = _y 

	if eff.doOffset == nil or eff.doOffset == true then
		anim:updateAnim(eff.anim, _x * tileSize - tileSize+offsetX - 16, _y  * tileSize - tileSize+offsetY - 16)
	else
		anim:updateAnim(eff.anim, _x * tileSize - tileSize+offsetX - 8, _y  * tileSize - tileSize+offsetY - 8)
	end

	if anim:getCurrentFrame(eff.anim) == eff.lastFrame and eff.isLooping ~= true then
		self:deleteEffect(_id)
	end
end

function effect:deleteEffect(_id)
	local eff = self._effectTable[_id]
	--print("ID FOR EFF IS: ".._id.."")
	--print("DELETING ID: ".._id.."")
	--print("EFFECTS LEFT: "..(#self._effectTable-1).."")
	anim:delete(eff.anim)
	table.remove(self._effectTable, _id)
	for i,v in ipairs(self._effectTable) do
		v.id = i
	end
end

function effect:dropAll( )
	--for i,v in ipairs(self._effectTable) do
	--[[local nrEffects = #self._effectTable
	for i = 1, #self._effectTable, -1 do
		self:deleteEffect(i)
	end
	self._effectTable = { }--]]

	for i,v in ipairs(self._effectTable) do
		if v.anim ~= nil then
			anim:delete(v.anim)
			v.anim = nil
		end
	end

	self._effectTable = {}
end

function effect:update( )
	--[[for i,v in ipairs(self._effectTable) do

	end--]]
	local nrEffects = #self._effectTable
	--print("NR EFFECTS: "..nrEffects.."")
	for i = 1, nrEffects do
		local eff = self._effectTable[i]
		if eff ~= nil then
			local act_x
			local act_y
			if eff.attachment ~= nil then
				local v = eff.attachment
				if v ~= nil then
					act_x = v.x
					act_y = v.y
				else
					act_x = eff.x
					act_y = eff.y
				end
			else
				act_x = eff.x
				act_y = eff.y
			end
			effect:updateEffect(i, act_x, act_y)
		end
	end
end