environment = { }

function environment:init( )
	self._environmentTable = { }
	self._doorTable = {}
	self._portalTable = {}

	self._doorMeshes = {}
	self._doorMeshes[1] = makeBox(95, 100, 10, "tiles/door.png" )

	self._portalMeshes = {}
	self._portalMeshes[1] = makeBox(95, 100, 95, "tiles/portal.png" )

	self._blockSize = 100
	self._mainMapLayer = 1
end

function environment:createDoor(_posX, _posY, _orientation)
	local temp = {
		id = #self._doorTable+1,
		x = _posX,
		y = _posY,
		height = self._blockSize,
		gfx = image:new3DImage(self._doorMeshes[1], _posX*self._blockSize, self._blockSize, _posY*self._blockSize, self._mainMapLayer),
		locked = true,
		orientation = _orientation,
	}
	if temp.orientation == 1 then
		image:setRot3D(temp.gfx, 0, 90, 0)
	else
		image:setRot3D(temp.gfx, 0, 0, 0)
	end
	rngMap:setWall(temp.x, temp.y, true)
	--Game:setCollisionAt(temp.x, temp.y, true)
	
	table.insert(self._doorTable, temp)
end

-- Opens all doors at a distance of less than 1.5/2 tiles away :D
function environment:openDoor(_px, _py)
	for i,v in ipairs(self._doorTable) do
		if math.dist(v.x, v.y, _px, _py) < 2 then
			if v.locked == true then
				v.locked = false
				if v.orientation == 1 then
					image:setRot3D(v.gfx, 0, 0, 0)
					image:setLoc(v.gfx, v.x*self._blockSize, self._blockSize, v.y*self._blockSize-50)
				else
					image:setRot3D(v.gfx, 0, 90, 0)
					image:setLoc(v.gfx, v.x*self._blockSize-50, self._blockSize, v.y*self._blockSize)
				end
				
				rngMap:setWall(v.x, v.y, false)
				--Game:setCollisionAt(v.x, v.y, false)
			else
				v.locked = true
				if v.orientation == 1 then
					image:setRot3D(v.gfx, 0, 90, 0)
				else
					image:setRot3D(v.gfx, 0, 0, 0)
				end
				image:setLoc(v.gfx, v.x*self._blockSize, self._blockSize, v.y*self._blockSize)
				rngMap:setWall(v.x, v.y, true)
				--Game:setCollisionAt(v.x, v.y, true)
			end
		end
	end
end

function environment:createPortal(_posX, _posY, _returnPortal)
	local temp = {
		id = #self._portalTable+1,
		x = _posX,
		y = _posY,
		height = self._blockSize,
		gfx = image:new3DImage(self._portalMeshes[1], _posX*self._blockSize, self._blockSize, _posY*self._blockSize, self._mainMapLayer),
		locked = true,
		returnToTowerLevel = Game.dungeoNLevel,
		isReturnPortal = false,
	}

	if _returnPortal == true then
		temp.isReturnPortal = _returnPortal
	end

	image:setRot3D(temp.gfx, 0, 0, 0)
	table.insert(self._portalTable, temp)
end

-- Opens all doors at a distance of less than 1.5/2 tiles away :D
function environment:accessPortal(_px, _py)
	for i,v in ipairs(self._portalTable) do
		if math.dist(v.x, v.y, _px, _py) < 2 then
			local dungeonType = nil
			if v.isReturnPortal == false then
			
				--[[if math.random(0, 1) == 1 then
					dungeonType = rngMap:returnCaveLevelType( )
				else
					dungeonType =  rngMap:returnCaveLevelType( )--rngMap:returnDungeonLevelType( )
				end--]]
				dungeonType = rngMap:getPortalLevelType( )[Game.dungeoNLevel]
			else
				dungeonType = rngMap:returnTowerLevelType( )
			end
			rngMap:setLevelType(dungeonType)
			currentState = 16
			--player:saveStats( )
			Game.iteration = Game.iteration + 1
		end
	end
end

function environment:removeAll( )
	for i,v in ipairs(self._doorTable) do
		image:removeProp(v.gfx, self._mainMapLayer)
	end

	self._doorTable = {}

	for i,v in ipairs(self._portalTable) do
		image:removeProp(v.gfx, self._mainMapLayer)
	end

	self._portalTable = {} 

	for i,v in ipairs(self._environmentTable) do
		image:removeProp(v.gfx, self._mainMapLayer)
	end

	self._environmentTable = {}

end