local textstyles = require "gui/textstyles"

editor = { }

function editor:init( )
	print("Scene Editor GO")

	self._editCamera = true
	self._boolItemScale = false

	self:setupGrid(40, 40)
	self:setupCamera( )
	self:createPointer( )
	self:generateTextures( )

	self._environment = { }
	self._itemTable = { }
end

function editor:update( )
	self:updatePointer( )
	self:updateCamera( )

	if self._boolItemScale == true then
		self._blockSize = self._itemSize
	else
		self._blockSize = self._initialBlockSize
	end
end

function editor:exportScene( )
	table.save(self._environment,  "map/exported.gnrtd")
end

function editor:importScene( )
	self:_clearLevel( )
	local tab = table.load("map/exported.gnrtd")
	for i,v in ipairs(tab) do
		local temp = {
			x = v.x,
			y = v.y,
			--gfx = image:new3DImage(self._tileTypeSet[self._currentTileType].gfx, _x * self._blockSize, self._pointerPos[2]*self._blockSize, _y * self._blockSize, self._mainMapLayer),
			name = v.name,
			elevation = v.elevation,
			rot = v.rot,
			xRot = v.xRot,
			yRot = v.yRot,
			zRot = v.zRot,
			tileType = v.tileType,
		}
		if self._tileTypeSet[temp.tileType].variation ~= nil then
			temp.gfx = image:new3DImage(self._tileTypeSet[temp.tileType].variation[math.random(1, #self._tileTypeSet[temp.tileType].variation)], v.x * self._blockSize, temp.elevation*self._blockSize, v.y * self._blockSize, self._mainMapLayer)
		else
			temp.gfx = image:new3DImage(self._tileTypeSet[temp.tileType].gfx, v.x * self._blockSize, temp.elevation*self._blockSize, v.y * self._blockSize, self._mainMapLayer)
		end

		image:setRot3D(temp.gfx, temp.xRot, temp.yRot, temp.zRot)
		--temp.gfx = image:new3DImage(self._tileTypeSet[self._currentTileType].gfx, v.x * self._blockSize, self._pointerPos[2]*self._blockSize, v.y * self._blockSize, self._mainMapLayer)
		table.insert(self._environment, temp)
	end
end

------------- Default Scene Stuff

function editor:setupGrid(_width, _height)
		self._mapWidth = _width
		self._mapHeight = _height
		self._mainMapLayer = 1
		self._blockSize = 100
		self._itemSize = 10
		self._initialBlockSize = 100

		local grassTile = makeCube( 100, "tiles/sceneEditor/tile_1.png" )
		local map = { }
		for x = 1, self._mapWidth do
			map[x] = { }
			for y = 1, self._mapHeight do
				-- map becomes a table! It will store data such as
				-- what the tile it has is (floor, wall, etc)
				-- what type of a floor/wall it is
				-- etc
				map[x][y] = { }

				-- for starts, we make the floor and cover it with walls

				map[x][y].floor = image:new3DImage(grassTile, x*100, 0, y*100, self._mainMapLayer) -- set floors to be random
				image:set3DIndex(map[x][y].floor, math.random(1,5))
				map[x][y].hasFloor = true -- there is a floor there :)
				map[x][y].wasVisited = false
			end
		end
end

function editor:setupCamera( )
	camera = MOAICamera.new ()
	camera:setLoc ( 0, 0, camera:getFocalLength ( 360 ))
	core:returnLayer(2):setCamera ( camera )
	core:returnLayer(1):setCamera( camera )
	core:returnLayer(g_Ui_Layer):setCamera(camera)
	camera:setOrtho(false)
	camera:setFieldOfView (FOVNORMAL)

	self._cameraX = self._mapWidth/2*100
	self._cameraY = 3800
	self._cameraZ = self._mapHeight/2*100

	self._cameraPos = { }
	self._cameraPos[1] = { self._cameraX, self._cameraY, self._cameraZ, 0 }
	self._cameraPos[2] = { self._cameraX, self._cameraY, self._cameraZ, self._cameraRotY }

	self._cameraRotX = -90
	self._cameraRotY = 0
	self._cameraRotZ = 0

	self._fpsCamRotY = 0
	self._cameraStepAngle = 90

	self._orientation = 1

	camera:setRot(self._cameraRotX, self._cameraRotY, self._cameraRotZ, 0.5)
	camera:setLoc(self._cameraPos[1][1], self._cameraPos[1][2], self._cameraPos[1][3])
end

function editor:createPointer( )
	self._pointerPosY = 1
	self._pointerPos = { }
	self._pointerPos[1] = math.floor(self._mapWidth/2)
	self._pointerPos[2] = self._pointerPosY -- 1 * self._blockSize
	self._pointerPos[3] = math.floor(self._mapHeight/2)
	
	self._pointerTex = makeCube( 105, "tiles/sceneEditor/pointer.png" )
	self._pointer = image:new3DImage(self._pointerTex, self._pointerPos[1]*self._blockSize, self._pointerPos[2]*self._blockSize, self._pointerPos[3]*self._blockSize, self._mainMapLayer)


end

function editor:updateCamera( )
	if self._editCamera == true then
		camera:setLoc(self._cameraPos[1][1], self._cameraPos[1][2], self._cameraPos[1][3])
	else
		camera:setRot(0, self._fpsCamRotY, 0, 0.8)
	end
end

function editor:updatePointer( )
	image:setLoc(self._pointer, self._pointerPos[1]*self._blockSize, self._pointerPos[2]*self._blockSize, self._pointerPos[3]*self._blockSize)
	self._cameraPos[1][1] = self._pointerPos[1]*self._blockSize
	self._cameraPos[1][3] = self._pointerPos[3]*self._blockSize
end

function editor:handleInput(key)
	self:_updatePointerElevation( )
	if key == 119 then
		self._pointerPos[3] = self._pointerPos[3] - 1
	elseif key == 115 then
		self._pointerPos[3] = self._pointerPos[3] + 1
	elseif key == 97 then
		self._pointerPos[1] = self._pointerPos[1] - 1
	elseif key == 100 then
		self._pointerPos[1] = self._pointerPos[1] + 1
	elseif key == 32 then
		self:placePrimitive(self._pointerPos[1], self._pointerPos[3])
	end

	if key == 113 then
		self._currentTileType = self._currentTileType - 1
		if self._currentTileType <= 0 then
			self._currentTileType = 0
		end
	elseif key == 101 then
		self._currentTileType = self._currentTileType + 1
		if self._currentTileType > #self._tileTypeSet then
			self._currentTileType = #self._tileTypeSet
		end
	end

	if key == 8 then
		self:_deleteTileAt(self._pointerPos[1], self._pointerPos[3])
	end

	if key == 114 then -- rotate
		editor:_rotateTileAt(self._pointerPos[1], self._pointerPos[3])
	end

	if key == 61 then
		self._pointerPosY = self._pointerPosY  + 1
	elseif key == 45 then
		self._pointerPosY = self._pointerPosY  - 1
	end

	if key == 92 then
		self:_clearLevel( )
	end

	if key == 49 then
		self:_firstPersonPreview( )
	end

	if key == 106 then
		self._fpsCamRotY = self._fpsCamRotY + 90
	elseif key == 108 then
		self._fpsCamRotY = self._fpsCamRotY - 90
	end

	if key == 53 then -- key 5
		self:exportScene( )
	elseif key == 57 then
		self:importScene( )
	end

	if key == 105 then
		self._boolItemScale = not self._boolItemScale
	end
	--113 q, 101 e
	self:_updateUiTileUnderPointer( )
end

function editor:generateTextures( )
	self._mapWalls = {}
	textureToUse = 1
	self._levelTiles = {}
	for i = 1, 10 do
		self._levelTiles[i] = ""..i..""
	end
	self._mapWalls[1] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall.png" )
	self._mapWalls[2] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall2.png" )
	self._mapWalls[3] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall3.png" )
	self._mapWalls[4] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall4.png" )
	self._mapWalls[5] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall.png" )
	self._mapWalls[6] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall.png" )
	self._mapWalls[7] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall5.png" )

	self._tileTypeSet = {}
	self._tileTypeSet[1] = {name = "Wall", gfx = makeCube( self._blockSize, "tiles/wall.png" ), yRot = 0, variation = self._mapWalls, xRot = 0, zRot = 0, offsetY = 0 }
	self._tileTypeSet[2] = {name = "BookCase", gfx = makeBox(100, 100, 10, "tiles/BookCase.png" ), yRot = 0, variation = nil, xRot = 0, zRot = 0, offsetY = 0  }
	self._tileTypeSet[3] = {name = "Door", gfx = makeCube( self._blockSize, "tiles/door.png" ), yRot = 0, variation = nil, xRot = 0, zRot = 0, offsetY = 0  }
	self._tileTypeSet[4] = {name = "Portal", gfx = makeCube( self._blockSize, "tiles/portal.png" ), yRot = 0, variation = nil, xRot = 0, zRot = 0, offsetY = 0  }
	self._tileTypeSet[5] = {name = "Wall", gfx = makeCube( self._blockSize, "tiles/wall.png" ), yRot = 0, variation = nil, xRot = 0, zRot = 0, offsetY = 0 }
	self._tileTypeSet[6] = {name = "Water", gfx = makeCube( self._blockSize, "tiles/water.png" ), yRot = 0, variation = nil, xRot = 0, zRot = 0, offsetY = 0 }
	self._tileTypeSet[7] = {name = "Wood", gfx = makeCube( self._blockSize, "tiles/wood.png" ), yRot = 90, variation = nil, xRot = 0, zRot = 0, offsetY = 0 }
	self._tileTypeSet[8] = {name = "Table", gfx = colladaToMesh ( "tiles/small_table_2.dae", "tiles/table_mt_rough_dif.png" ), yRot = 0, variation = nil, xRot = 0, zRot = 0, offsetY = 10}
	self._currentTileType = 1
end

function editor:placePrimitive(_x, _y)
	if self:isPrimitiveAt(_x, _y) == false then
		local temp = {
			x = _x,
			y = _y,
			--gfx = image:new3DImage(self._tileTypeSet[self._currentTileType].gfx, _x * self._blockSize, self._pointerPos[2]*self._blockSize, _y * self._blockSize, self._mainMapLayer),
			name = ""..self._tileTypeSet[self._currentTileType].name.."",
			elevation = self._pointerPosY,
			rot = 0,
			xRot = self._tileTypeSet[self._currentTileType].xRot,
			yRot = self._tileTypeSet[self._currentTileType].yRot,
			zRot = self._tileTypeSet[self._currentTileType].zRot,
			tileType = self._currentTileType,
			offsetY = self._tileTypeSet[self._currentTileType].offsetY,
		}
		if self._tileTypeSet[self._currentTileType].variation ~= nil then
			temp.gfx = image:new3DImage(self._tileTypeSet[self._currentTileType].variation[math.random(1, #self._tileTypeSet[self._currentTileType].variation)], _x * self._blockSize, self._pointerPos[2]*self._blockSize, _y * self._blockSize - temp.offsetY, self._mainMapLayer)
		else
			temp.gfx = image:new3DImage(self._tileTypeSet[self._currentTileType].gfx, _x * self._blockSize, self._pointerPos[2]*self._blockSize - temp.offsetY, _y * self._blockSize, self._mainMapLayer)
		end

		if temp.tileType == 8 then
			image:set3DScale(temp.gfx, 11, 11, 11)
		end

		image:setRot3D(temp.gfx, temp.xRot, temp.yRot, temp.zRot)

		table.insert(self._environment, temp)
	end
end

function editor:isPrimitiveAt(_x, _y)
	local bool = false
	for i,v in ipairs(self._environment) do
		if v.x == _x and v.y == _y then
			if v.elevation == self._pointerPosY then
				bool = true
			end
		end
	end

	return bool
end

function editor:initEditorInterface( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("editor_ui.lua"), "")
	local g = element.gui

	-- More like TILE UNDER POINTER BUT IM TO LAZY 2 CHANGE
	self._currentTextureLabel = element.gui:createLabel( )
	self._currentTextureLabel:setDim(22, 4)
	self._currentTextureLabel:setPos(0,0)
	self._currentTextureLabel:setText("Empty")
	self._currentTextureLabel:setTextStyle(textstyles.get("mmButtonUnselected"))

	-- Current Tile Type
	self._currentTileTypeLabel = element.gui:createLabel( )
	self._currentTileTypeLabel:setDim(22, 4)
	self._currentTileTypeLabel:setPos(0,4)
	self._currentTileTypeLabel:setText("Wall")
	self._currentTileTypeLabel:setTextStyle(textstyles.get("mmButtonUnselected"))	

	self._elevationLevel = element.gui:createLabel( )
	self._elevationLevel:setDim(22, 4)
	self._elevationLevel:setPos(80,0)
	self._elevationLevel:setText("Elevation: "..self._pointerPosY.."")
	self._elevationLevel:setTextStyle(textstyles.get("mmButtonUnselected"))	

	self._itemEditMode = element.gui:createLabel( )
	self._itemEditMode:setDim(22, 4)
	self._itemEditMode:setPos(80,4)
	self._itemEditMode:setText("Editing Environment")
	self._itemEditMode:setTextStyle(textstyles.get("mmButtonUnselected"))	

	--[[self._saveButton = element.gui:createButton( )
	self._saveButton:setDim(12, 8)
	self._saveButton:setPos(0, 92)
	self._saveButton:setText("EXPORT")--]]
end

function editor:getTileNameAt(_x, _y)
	local name = "empty"
	for i,v in ipairs(self._environment) do
		if v.x == _x and v.y == _y then
			name = v.name
		end
	end
	return name
end

function editor:_updateUiTileUnderPointer( )
	self._currentTextureLabel:setText(""..self:getTileNameAt(self._pointerPos[1], self._pointerPos[3]).."")
	self._currentTileTypeLabel:setText(""..self._tileTypeSet[self._currentTileType].name.."")
	self._elevationLevel:setText("Elevation: "..self._pointerPosY.."")

	if self._boolItemScale == true then
		self._itemEditMode:setText("Editing Items")
	else
		self._itemEditMode:setText("Editing Environment")
	end
end

function editor:_deleteTileAt(_x, _y)
	local id = nil
	for i,v in ipairs(self._environment) do
		if v.x == _x and v.y == _y then
			if v.elevation == self._pointerPosY then
				id = i
				image:removeProp(v.gfx, self._mainMapLayer)
				v.name = "removed"
			end
		end
	end
	if id ~= nil then
		table.remove(self._environment, id)
	end
end

function editor:_getTileAt(_x, _y)
	local tile = nil
	for i,v in ipairs(self._environment) do
		if v.x == _x and v.y == _y then
			if v.elevation == self._pointerPosY then
				tile = v
			end
		end
	end

	return tile
end

function editor:_rotateTileAt(_x, _y)
	local v = self:_getTileAt(_x, _y)
	if v ~= nil then
		image:setRot3D(v.gfx, 0, v.rot + 45, 0)
		v.rot = v.rot + 45
	end
end

function editor:_updatePointerElevation( )
	self._pointerPos[2] = self._pointerPosY
end

function editor:_clearLevel( )
	local id = nil
	for i,v in ipairs(self._environment) do
		image:removeProp(v.gfx, self._mainMapLayer)
		v.name = "removed"
	end
	self._environment = { }
end

function editor:_firstPersonPreview( )
	self._editCamera = not self._editCamera
	if self._editCamera == false then
		camera:setRot(0, self._fpsCamRotY, 0, 0.1)
		camera:setLoc(self._cameraPos[1][1], 100, self._cameraPos[1][3])
	else
		camera:setRot(self._cameraRotX, self._cameraRotY, self._cameraRotZ, 0.5)
		camera:setLoc(self._cameraPos[1][1], self._cameraPos[1][2], self._cameraPos[1][3])
	end
end