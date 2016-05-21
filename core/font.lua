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

font = {}

function font:init( )
	self._fontTable = {}
	self._wordTable = {}
	self._string = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
	"R", "S", "T", "U", "V", "W", "X", "Y", "Z", ".", "-", ":", " ", 
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", 
	 }

end

function font:newWord(_x, _y, _string, _imageFile, _size, _scale, _layer)
--[[	local temp = {
		id = #self._wordTable + 1,
		x = _x,
		y = _y,
		markForDel = false,
		prop = {},
		string = _string,
		size = _size,
		scale = _scale,
		layer = _layer,
	}
	--self._fontTexture = image:newDeckTexture("Game/media/MGL_Font_Smallest.png", 6, "dmg_font_tex", 32, "notNill")
	temp._fontTexture = image:newDeckTexture( _imageFile,  _layer, "".._string..""..math.random(1, 9000).."", _size, "notNill")
	for i = 1, #_string do
		local letter = _string:sub(i, i)
		self:newLetter(letter, temp)
	end

	table.insert(self._wordTable, temp)

	return temp.id--]]
end

function font:newLetter(_letter, _parrent)
	--[[local l = _letter
	local idx = self:_getIndex(l)
	if idx ~= nil then
		local prop = image:newDeckImage(_parrent._fontTexture,  _parrent.x + #_parrent.prop*_parrent.size, _parrent.y, idx)
		if _parrent.scale == true then
			image:setScale(prop, 1, 1)
		end
		--table.insert(temp, prop)
		table.insert(_parrent.prop, prop)
	end--]]
end

function font:draw(_id, _x, _y, _bool)
	--for i,v in ipairs(self._wordTable) do
	--[[local v = self._wordTable[_id]
		if v ~= nil and v.markForDel == false then
			if type(v.prop) == "table" then
				for k, j in ipairs(v.prop) do
					if j ~= nil then
						image:updateImage(j, _x + k*(v.size-8)-(v.size-8), _y)
						image:setVisible(j, _bool)
					end
				end
			end
		end--]]
	--end
end

function font:_getIndex(_letter)
	--[[for i,v in ipairs(self._string) do 
		if v == _letter then
			return i
		end
	end--]]
end

function font:dropAll( )
	--[[for i,v in ipairs(self._wordTable) do
		font:delete(i)
	end	--]]
end

function font:delete(_id)
	--[[local fnt = self._wordTable[_id]
	fnt.markForDel = true
	print("HAPPENING")
	for k, j in ipairs(fnt.prop) do
		image:removeProp(j, fnt.layer)
	end


	fnt = nil--]]
end

function font:setColor(_id, r, g, b, a)
	--[[local fnt = self._wordTable[_id]
	for i,v in ipairs(fnt.prop) do
		image:setColor(v, r, g, b, a)
	end--]]
end

function font:setText(_id, _string, _x, _y, _bool)
	--[[local fontID = self._wordTable[_id]
	if _string ~= fontID.string then
		for k, j in ipairs(fontID.prop) do
			--image:removeProp(j, fontID.layer)
			local l
			local idx 
			--for i = 1, #_string do
			if k <= #_string then
				l = _string:sub(k, k)
				idx = font:_getIndex(l)
				print("IDX IS: "..l.."")
				if idx ~= 0 then
					image:setIndex(j, idx )
				end
			else
				idx = 30
				image:setIndex(j, idx )
			end
				
			--end
			--
			--j = nil
		end
		--fontID.prop = {}

		fontID.string = _string
	end
	self:draw(_id, _x, _y, _bool)--]]

end