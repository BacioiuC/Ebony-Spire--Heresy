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

mGrid = {}


function mGrid:init( )
	self._gridTable = {}
	self._width = 0
	self._height = 0
	self._tileSize = 0
	self._x = 0
	self._y = 0

	self.grid = nil

	self._texture = nil
	self._image = nil
	self._textureTable = {}

	self._dCurTile = 1
	self._dMaxTile = 4
	self._dLoop = false
	self._idCounter = 0
end

-- BRB, getting some coffee! 

-- if nil then gridn ot found! Error checking? meh :D
function mGrid:returnGridPosition(_id)
	local posGrid = nil
	for i,v in ipairs(self._gridTable) do
		if v.id == _id then
			posGrid = i
		end
	end
	return posGrid
end

function mGrid:new(_width, _height, _tileSize, _image, _optionalGridTile, _string, _optionalLayer)
	self._idCounter = self._idCounter + 1
	local layer
	if _optionalLayer ~= nil then
		layer = _optionalLayer
		print("ONE OPTIONAL")
	else
		print("REST IS GOOD")
		layer = g_GroundLayer
	end
	self._textureTable[#self._gridTable+1] = image:newDeckTexture(_image, layer, "".._image.."", _tileSize)
	
	local temp = {
		id = self._idCounter,
		width = _width,
		height = _height,
		tileSize = _tileSize,
		_layer = layer,
		image = image:newDeckImage(self._textureTable[#self._gridTable+1], self._x, self._y),
		grid = MOAIGrid.new(),
		x = math.random(1, 200),
		y = math.random(1, 200),
	}
	table.insert(self._gridTable, temp)
	
	if _string == "hex" then
		--temp.grid:setSize(temp.width, temp.height, temp.tileSize, temp.tileSize)
		temp.grid:initHexGrid(temp.width, temp.height, 32, -2, -16)
	else
		temp.grid:setSize(temp.width, temp.height, temp.tileSize, temp.tileSize)
	end
	

	--self.grid = MOAIGrid.new ()
	--self.grid:setSize ( self._width, self._height, self._tileSize, self._tileSize)
	local _value = nil
	if _optionalGridTile == nil then
		_value = 1
	else
		_value = _optionalGridTile
	end
		for _x = 1, temp.width do
			for _y = 1, temp.height do
				temp.grid:setTile(_x, _y, _value)
				temp.grid:setTileFlags(_x, _y,  0x40000000)
			end
		end
	--else

	--end

	image:setGrid(temp.image, temp.grid)
	print("TEMP ID IS :"..temp.id.."")
	
	return temp.id



end

function mGrid:new2(_width, _height, _tileSizeX, _tileSizeY, _xOFF, _yOFF, _tw, _th, _image, _optionalGridTile, _string, _optionalLayer)
	self._idCounter = self._idCounter + 1
	local layer
	if _optionalLayer ~= nil then
		layer = _optionalLayer
		print("ONE OPTIONAL")
	else
		print("REST IS GOOD")
		layer = g_GroundLayer
	end
	self._textureTable[#self._gridTable+1] = image:newDeckTexture(_image, layer, "".._image.."", 32)
	
	local temp = {
		id = self._idCounter,
		width = _width,
		height = _height,
		tileSizeX = _tileSizeX,
		tileSizeY = _tileSizeY,
		_layer = layer,
		image = image:newDeckImage(self._textureTable[#self._gridTable+1], self._x, self._y),
		grid = MOAIGrid.new(),
		x = math.random(1, 200),
		y = math.random(1, 200),
	}
	table.insert(self._gridTable, temp)

	if _string == "hex" then
		--temp.grid:setSize(temp.width, temp.height, temp.tileSize, temp.tileSize)
		temp.grid:initHexGrid(temp.width, temp.height, 32, -2, -16)
	else
		temp.grid:setSize(temp.width, temp.height, temp.tileSizeX, temp.tileSizeY, _xOFF, _yOFF, _tw, _th)
	end
	

	--self.grid = MOAIGrid.new ()
	--self.grid:setSize ( self._width, self._height, self._tileSize, self._tileSize)
	local _value = nil
	if _optionalGridTile == nil then
		_value = 1
	else
		_value = _optionalGridTile
	end
		for _x = 1, temp.width do
			for _y = 1, temp.height do
				temp.grid:setTile(_x, _y, _value)
				temp.grid:setTileFlags(_x, _y,  0x40000000)
			end
		end
	--else

	--end

	image:setGrid(temp.image, temp.grid)
	
	print("TEMP ID NEW 2 IS :"..temp.id.."")
	return temp.id


end


function mGrid:setDeck(_id, _deckID, _tileSize)

	local actualID = self:returnGridPosition(_id)
	--image:setTexture(self._gridTable[_id].image, self._textureTable[_deckID])
	image:removeProp(self._gridTable[actualID].image)
	self._gridTable[actualID].image = image:newDeckImage(self._textureTable[_deckID], 0, 0)
	self._gridTable[actualID].grid = MOAIGrid.new()
	self._gridTable[actualID].grid:setSize(1, 1, _tileSize, _tileSize  )
	--self._gridTable[_id].grid:setTile(1, 1, 1)
	image:setGrid(self._gridTable[actualID].image, self._gridTable[actualID].grid)
	map.gridSize = _tileSize
	
end


function mGrid:transformTableForJumper(_tab)
	local rot1 = mGrid:___rotateTable(_tab)
	local rot2 = mGrid:___rotateTable(rot1)
	local rot3 = mGrid:___rotateTable(rot2)
	local flip1 = mGrid:__flipTableOnX(rot3)

	return flip1

end

function mGrid:___rotateTable(_tab)
  local rotatedTable = {}
	for i= 1 , #_tab[1] do
		rotatedTable[i] = {}
		local cellNo = 0
		for j = #_tab , 1, -1 do
			cellNo = cellNo + 1
			rotatedTable[i][cellNo] = _tab[j][i]
		end
	end
	return rotatedTable
end

function mGrid:__flipTableOnX(_tab)
    local size = #_tab+1
    local newTable = {}

    for i,v in ipairs ( _tab ) do
        newTable[size-i] = v
    end

    return newTable
end

function mGrid:setTiles(_id, _table)
	for _y = 1, #_table do
		for _x = 1, #_table[_y] do
			self._gridTable[_id].grid:setTile(_x, _y, _table[_y][_x].node)
			self._gridTable[_id].grid:setTileFlags(_x, _y,  0x40000000)
		end
	end
end

function mGrid:setPriority(_id)
	image:setPriority(self._gridTable[_id].image, 1)
end	

function mGrid:setRot(_id, _x, _y, _z)
	image:setRot3D(_id, _x, _y, _z, 0)
end

function mGrid:setLoc(_id, _x, _y, _z)
	image:seekLoc(_id, _x, _y, _z, 0)
end

function mGrid:_debugAnim(__id, _tilesFrom, _tilesTo)
	local _id = self:returnGridPosition(__id)
	if self._dLoop == false then
		self._dStartTile = _tilesFrom
		self._dCurTile = _tilesFrom
		self._dMaxTile = _tilesTo
		self._dLoop = true
		self._curTimer = Game.worldTimer
	else
		if Game.worldTimer > self._curTimer + 0.1 then
			if self._dCurTile < self._dMaxTile then
				
				self._dCurTile = self._dCurTile + 1
			else
				self._dCurTile = self._dStartTile
			end
			self:setTiles3(_id, self._dCurTile)
			self._curTimer = Game.worldTimer
		end
	end
end

function mGrid:setTiles3(__id, _toe)
	local _id = self:returnGridPosition(__id)
	for _y = 1, 50 do
		for _x = 1, 50 do
			self._gridTable[_id].grid:setTile(_x, _y, _toe)
			self._gridTable[_id].grid:setTileFlags(_x, _y,  0x40000000)
		end
	end
end

function mGrid:setTilesExtra(__id, _value, _op1, _op2)
	local _id = self:returnGridPosition(__id)
	local counter = 0
	for x = 1, self._gridTable[_id].width do
		for y = 1, self._gridTable[_id].height do
			counter = counter + 1
			if counter > _value then
				self._gridTable[_id].grid:setTile(x, y, _op2)
			else
				self._gridTable[_id].grid:setTile(x, y, _op1)
			end
		end
	end
end

function mGrid:setTiles2(__id, _table)
	local _id = self:returnGridPosition(__id)
	for _y = 1, #_table do
		for _x = 1, #_table[_y] do
			self._gridTable[_id].grid:setTile(_x, _y, _table[_y][_x])
			--self._gridTable[_id].grid:setTileFlags(_x, _y,  0x40000000)
		end
	end
end

function mGrid:setTiles3(__id, _x, _y, _value)
	local _id = self:returnGridPosition(__id)
	--for _y = 1, #_table do
		--for _x = 1, #_table[_y] do
			self._gridTable[_id].grid:setTile(_x, _y, _value)
			self._gridTable[_id].grid:setTileFlags(_x, _y,  0x40000000)
		--end
	--end
end

function mGrid:setAllTilesTo(__id, _value)
	local _id = self:returnGridPosition(__id)
	for x = 1, self._gridTable[_id].width do
		for y = 1, self._gridTable[_id].height do
			self._gridTable[_id].grid:setTile(x, y, _value)
		end
	end
end

function mGrid:getTile(__id, _x, _y)
	local _id = self:returnGridPosition(__id)
	return self._gridTable[_id].grid:getTile(_x, _y)
end

function mGrid:setPos(__id, _x, _y)


	local _id = self:returnGridPosition(__id)
	if self._gridTable[_id].x ~= _x or self._gridTable[_id].y ~= _y then
		self._gridTable[_id].x = _x
		self._gridTable[_id].y = _y
		mGrid:update(_id)
	end
end

function mGrid:setPos2(__id, _x, _y)


	local _id = __id--self:returnGridPosition(__id)
	if self._gridTable[_id].x ~= _x or self._gridTable[_id].y ~= _y then
		self._gridTable[_id].x = _x
		self._gridTable[_id].y = _y
		mGrid:update(_id)
	end
end

function mGrid:updatePos(__id, _x, _y)
	local _id = self:returnGridPosition(__id)
	--print("UPDATE POS GRID BASE ID: ".._id.." AND __ID: ".._id.."")
	self._gridTable[_id].x = self._gridTable[_id].x + _x
	self._gridTable[_id].y = self._gridTable[_id].y + _y	
	mGrid:update(_id)
end


function mGrid:updateTile(__id, _x, _y, _value)
	local _id = self:returnGridPosition(__id)
	self._gridTable[_id].grid:setTile(_x, _y, _value)
	self._gridTable[_id].grid:setTileFlags(_x, _y, 0x40000000 )
end

function mGrid:mouseOverTile(_x, _y)
	if self._gridTable[_id].grid:getTile(_x, _y) ~= 0 or self._gridTable[_id].grid:getTile(_x, _y) ~= nil then
		return true
	end
	return false

end

function mGrid:returnProp(__id)
	local _id = self:returnGridPosition(__id)
	return self._gridTable[_id].image
end

function mGrid:update(__id)
	local _id = __id--self:returnGridPosition(__id)
	if _id == nil then
		print("baseID is: ".._id.."")
		print("___ID IS NIL")
	else
		--print("baseID is: ".._id.."")
		--print("__ID IS: ".._id.."")
	end
	image:updateImage(self._gridTable[_id].image, self._gridTable[_id].x, self._gridTable[_id].y)
end

function mGrid:destroy(__id)
	local _id = self:returnGridPosition(__id)
	if self._gridTable[_id] ~= nil then
		image:removeProp(self._gridTable[_id].image, self._gridTable[_id]._layer)
		self._gridTable[_id].grid = nil
		table.remove(self._gridTable, _id)
	end
end

function mGrid:_debugDestroyAll( )
	local nr = #self._gridTable
	--for i = 1, nr do
	--	image:removeProp(self._gridTable[i].image,  self._gridTable[i]._layer)
	--	--self._gridTable[i].grid = nil
		
	--end
	for i,v in ipairs(self._gridTable) do
		image:removeProp(v.image,  v._layer)
	end
	self._idCounter = 0
	--[[for i = 1, nr, -1 do
		table.remove(self._gridTable, i)
	end--]]
	self._gridTable = { }
end

function mGrid:returnNrGrids( )
	return #self._gridTable
end

function mGrid:getLocalTable(__id)
	local _id = self:returnGridPosition(__id)
	local exTable = {}
	local table = self._gridTable[_id]

	for x = 1, table.width do
		exTable[x] = {}
		for y = 1, table.height do
			exTable[x][y] = table.grid:getTile(x, y)
		end
	end

	return exTable
end