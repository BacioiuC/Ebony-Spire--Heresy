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

	self._effectTable = {}
	self._portalMesh2 = makeBox(50, 50, 0, "assets/effects/summong_fx_2.png")

	self._portalID = Game.portalID
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
		requiresKey = false,
	}
	if temp.orientation == 1 then
		image:setRot3D(temp.gfx, 0, 90, 0)
	else
		image:setRot3D(temp.gfx, 0, 0, 0)
	end
	--rngMap:setWall(temp.x, temp.y, true)
	--Game:setCollisionAt(temp.x, temp.y, true)
	--Game:setCollisionAt(_posX, _posY, false)
	table.insert(self._doorTable, temp)
end

function environment:createLockedDoor(_posX, _posY, _orientation)
	local temp = {
		id = #self._doorTable+1,
		x = _posX,
		y = _posY,
		height = self._blockSize,
		gfx = image:new3DImage(self._doorMeshes[1], _posX*self._blockSize, self._blockSize, _posY*self._blockSize, self._mainMapLayer),
		locked = true,
		orientation = _orientation,
		requiresKey = true,
	}
	if temp.orientation == 1 then
		image:setRot3D(temp.gfx, 0, 90, 0)
	else
		image:setRot3D(temp.gfx, 0, 0, 0)
	end
	--rngMap:setWall(temp.x, temp.y, true)
	--Game:setCollisionAt(temp.x, temp.y, true)
	
	table.insert(self._doorTable, temp)
end

function environment:removeDoor(_posX, _posY)
	local removeID = nil
	for i,v in ipairs(self._doorTable) do
		if v.x == _posX and v.y == _posY then
			removeID = i
			image:removeProp(v.gfx, self._mainMapLayer)
		end
	end

	if removeID ~= nil then
		table.remove(self._doorTable, removeID)
	end
end

function environment:isDoorNearby(_posX, _posY)
	local bool = false
	for i,v in ipairs(self._doorTable) do
		if math.dist(v.x, v.y, _posX, _posY) < 3 then
			bool = true
		end
	end

	return bool

end

function environment:removeUnusedDoors( )
	for i,v in ipairs(self._doorTable) do
		if v.orientation == 1 then -- forward door
			if rngMap:isWallAt(v.x, v.y-1) == false or rngMap:isWallAt(v.x,v.y+1) == false then
				image:removeProp(v.gfx, self._mainMapLayer)
				rngMap:setWall(v.x, v.y, false)
				v.gfx = nil
			end
		else
			if rngMap:isWallAt(v.x-1, v.y) == false or rngMap:isWallAt(v.x+1,v.y) == false then
				image:removeProp(v.gfx, self._mainMapLayer)
				v.gfx = nil
				rngMap:setWall(v.x, v.y, false)
			end
		end
	end

	local idToRemoveTable = {}

	for i,v in ipairs(self._doorTable) do
		if v.gfx == nil then
			local temp = {
				id = i,
			}
			table.insert(idToRemoveTable, temp)
		end
	end

	for i = #idToRemoveTable, 1, -1 do
		table.remove(self._doorTable, idToRemoveTable[i].id)
	end


end

-- Opens all doors at a distance of less than 1.5/2 tiles away :D
function environment:openDoor(_px, _py)
	for i,v in ipairs(self._doorTable) do
		if math.dist(v.x, v.y, _px, _py) < 2 then
			if v.locked == true then
				if v.requiresKey == true then
					local bool, _item, _v = interface:isKeyInInventory( )
					if bool == true then
						v.requiresKey = false
						interface:removeKeyFromInventory(_item)
						interface:removeKeyFromInventoryObject(_v)
						log:newMessage("You used a <c:EAFF00> key  </c> to unlock this door")
						Game:setCollisionAt(_px, _py, false)
					else
						log:newMessage("You need a <c:EAFF00> key  </c> to unlock this door")
					end
				end
				if v.requiresKey == false then
					v.locked = false
					Game:setCollisionAt(_px, _py)
					if v.orientation == 1 then
						image:setRot3D(v.gfx, 0, 0, 0)
						image:setLoc(v.gfx, v.x*self._blockSize, self._blockSize, v.y*self._blockSize-50)
					else
						image:setRot3D(v.gfx, 0, 90, 0)
						image:setLoc(v.gfx, v.x*self._blockSize-50, self._blockSize, v.y*self._blockSize)
					end
					
					rngMap:setWall(v.x, v.y, false)
					--Game:setCollisionAt(v.x, v.y, false)
				end
			else
				v.locked = true
				Game:setCollisionAt(_px, _py, true)
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
	local _mesh = makeBox(70, 70, 0, "assets/effects/summong_fx_1.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/summong_fx_2.png")
	
	local temp = {
		id = #self._portalTable+1,
		x = _posX,
		y = _posY,
		height = self._blockSize,
		gfx = image:new3DImage(tmesh, 10, 10,  10, 2 ),
		locked = true,
		returnToTowerLevel = Game.dungeoNLevel,
		isReturnPortal = false,
	}

	if _returnPortal == true then
		temp.isReturnPortal = _returnPortal
	end
	--self._effectTable = { }
	local _x = _posX
	local _y = _posY
	local portalCounter = 0
	for i = 1, 3 do
		local tmesh = _mesh
		local rndCheck = math.random(1,2)
		if portalCounter ~= 1 then
			tmesh = _mesh2
		end
		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(tmesh, 10, 10-i*20,  10, 2),
			x = (_x),
			y = (_y),
			ix = math.random(-40, 40),
			iy = math.random(-40, 40),
			z = 100-i*20,
			life = 20,
			speed = 8,
			_effectType = 2,
		}

		if portalCounter == 1 then
			temp.ix = 0
			temp.iy = 0
			temp.z = 100
			temp.life = 100*100*100*100*10
			temp.mainElement = true
		end
		portalCounter = portalCounter + 1
		table.insert(self._effectTable, temp)

	end

	rngMap:setWall(temp.x, temp.y, true)
	table.insert(self._portalTable, temp)
end

function environment:createSpecialPortal(_posX, _posY, _returnPortal)
	local _mesh = makeBox(70, 70, 0, "assets/effects/polymorph_1.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/polymorph_2.png")
	
	local temp = {
		id = #self._portalTable+1,
		x = _posX,
		y = _posY,
		height = self._blockSize,
		gfx = image:new3DImage(tmesh, 10, 10,  10, 2 ),
		locked = true,
		returnToTowerLevel = Game.dungeoNLevel,
		isReturnPortal = false,
		isSpecialPortal = true,
	}

	if _returnPortal == true then
		temp.isReturnPortal = _returnPortal
	end
	--self._effectTable = { }
	local _x = _posX
	local _y = _posY
	local portalCounter = 0
	for i = 1, 3 do
		local tmesh = _mesh
		local rndCheck = math.random(1,2)
		if portalCounter ~= 1 then
			tmesh = _mesh2
		end
		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(tmesh, 10, 10-i*20,  10, 2),
			x = (_x),
			y = (_y),
			ix = math.random(-40, 40),
			iy = math.random(-40, 40),
			z = 100-i*20,
			life = 20,
			speed = 8,
			_effectType = 2,
		}

		if portalCounter == 1 then
			temp.ix = 0
			temp.iy = 0
			temp.z = 100
			temp.life = 100*100*100*100*10
			temp.mainElement = true
		end
		portalCounter = portalCounter + 1
		table.insert(self._effectTable, temp)

	end

	rngMap:setWall(temp.x, temp.y, true)
	table.insert(self._portalTable, temp)
end

function environment:getPortalTable( )
	return self._portalTable
end

function environment:updateEffects( )
	local heightCount = 0
	local rotCounter = 1
	for i,v in ipairs(self._effectTable) do
		local px, py = player:returnPosition( )
		--for i,v in ipairs(self._itemTable) do
			local dist = math.distance(px, py, v.x, v.y)
			if dist > 1 then
				local lightFactor = dist/(7-Game.lightFactor)
				image:setColor(v.gfx, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
			end	
		--end
		if v._effectType == 1 then -- particles-like
			heightCount = heightCount + 10
			local rx, ry, rz = camera:getRot( )
			image:setRot3D(v.gfx, 0, ry, 0)
			v.z = v.z + v.speed
			image:setLoc(v.gfx, v.x*100+v.ix, v.z, v.y*100+v.iy)
		elseif v._effectType == 2 then -- with main element around which particles spin
			local rx, ry, rz = camera:getRot( )
			if v.mainElement == true then
				local irx, iry, irz = image:getRot3D(v.gfx)
				image:setRot3D(v.gfx, rx+math.random(1, 5), ry, 0)
				--image:moveRot(v.gfx, 0, 0, rotCounter)

				image:setLoc(v.gfx, v.x*100+v.ix, v.z, v.y*100+v.iy)
				rotCounter = rotCounter + 1
			else
				v.z = v.z + v.speed
				image:setLoc(v.gfx, v.x*100+v.ix, v.z, v.y*100+v.iy)
				image:setRot3D(v.gfx, 0, ry, 0)
			end
		end
		v.life = v.life - 1
	end

	for i,v in ipairs(self._effectTable) do
		if v.life <= 0 then
			self:dropEffect(i)
		end
	end
end

function environment:dropEffect(_i)
	local _item = self._effectTable[_i]
	image:removeProp(_item.gfx, 2)
	_item.gfx = nil
	if _forceDelete ~= true then
		table.remove(self._effectTable, _i)
	end

end

function environment:returnPortalPosition( )
	--return self._portalTable[1].x, self._portalTable[1].y
	local px, py = player:returnPosition( )
	local id = 1
	local dist = 1000
	for i,v in ipairs(self._portalTable) do
		local newDist = math.dist(v.x, v.y, px, py)
		if newDist < dist then
			id = i
			dist = newDist
		end
	end
	--print("ID IS: "..id.."")
	self._portalID = id
	Game.portalID = self._portalID
	return self._portalTable[id].x, self._portalTable[id].y
end

function environment:getPortalID( )
	return self._portalID
end
-- Opens all doors at a distance of less than 1.5/2 tiles away :D
function environment:accessPortal(_px, _py)
	for i,v in ipairs(self._portalTable) do
		if math.dist(v.x, v.y, _px, _py) < 2 then
			local dungeonType = nil
			self._portalID = i
			if v.isSpecialPortal == true then
				player:exportScore(20, 90)
				currentState = 18
			else
				if v.isReturnPortal == false then

					if Game.dungeonType == 1 then
						Game.dungeonType = rngMap:returnPortalLevelType( )
					else
						Game.dungeonType = rngMap:returnTowerLevelType( )
					end
					self._portalID = nil
				else
					dungeonType = rngMap:returnTowerLevelType( )
					Game.dungeonType = rngMap:returnTowerLevelType( )
					--print("SWITCH TO TOWER")
				end
				--interface:saveInventory( )
				player:addToScore(400) -- 400 points for each portal run
				currentState = 16
				--player:saveStats( )
				Game:exportSaveInfo( )
				Game.iteration = Game.iteration + 1
			end
		end
	end
end

function environment:update( )
	local px, py = player:returnPosition( )
	for i,v in ipairs(self._doorTable) do
		local dist = math.distance(px, py, v.x, v.y)
		if dist > 1 then
			local lightFactor = dist/(7-Game.lightFactor)
			image:setColor(v.gfx, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
		end	
	end

	for i,v in ipairs(self._portalTable) do
		local dist = math.distance(px, py, v.x, v.y)
		if dist > 1 then
			local lightFactor = dist/(7-Game.lightFactor)
			image:setColor(v.gfx, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
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
	core:clearLayer(2)
end