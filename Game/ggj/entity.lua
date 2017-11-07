entity = { }

function entity:init( )
	self._entityTable = { }

	self._woodenBox = {}
	self._woodenBox[1] = makeBox(60, 40, 60, "tiles/Docks/box_texture_1.png")--makeCube(60, "tiles/Docks/box_texture_1.png")
	self._woodenBox[2] = makeBox(40, 40, 40, "tiles/Docks/box_texture_1.png")--makeCube(60, "tiles/Docks/box_texture_1.png")
	self._woodenBox[3] = makeBox(60, 30, 60, "tiles/Docks/drawer.png" )--makeCube(60, "tiles/Docks/box_texture_1.png")
	self._woodenBox[4] = makeBox(40, 40, 40, "tiles/Docks/box_texture_1.png")

	self._gobber = makeBox(100, 100, 0.1, "assets/summon_gobber.png")

	self._entityCreatureTable = { }
	self._entityCreatureTable = loadCSVData("data/creatures.csv")
	self._actionQue = { }

	self._specificSpawnCreatureTable =  loadCSVData("data/creatures.csv")

	self._entityTowerDwellersTable = {}
	self._entityTowerDwellersTable = loadCSVData("data/towerDwellers.csv")
	self._movementAnimSpeed = 10
	self._entityHeight = 70
	-- generate their mesh from data
	for i,v in pairs(self._entityCreatureTable) do
		v.mesh = makeBox(70, 70, 0, ""..v.gfx.."")
	end

	for i,v in pairs(self._entityTowerDwellersTable) do
		v.mesh = makeBox(100, 100, 0, ""..v.gfx.."")
	end

	for i,v in pairs(self._specificSpawnCreatureTable) do
		v.mesh = makeBox(70, 70, 0, ""..v.gfx.."")
	end

	self._playerEventPerformed = false

	self._armorStats = { }
	self._armorStats[1] = {
		def = 1,
		arcaneDef = 1,
	}
	self._moveDir = { }
	self._moveDir[1] = {0, 1} -- UP, L, D, R
	self._moveDir[2] = {1, 0}
	self._moveDir[3] = {0, -1}
	self._moveDir[4] = {-1, 0}

	self._energyTable = { }
	self._energyTable[1] = 2 -- movement cost == 2
	self._energyTable[2] = 4 -- attacking cost == 4
	self._energyTable[3] = 1 -- picking stuff up = 1

	self._MOVEMENTCOST = 1
	self._ATTACKINGCOST = 2
	self._PICKINGSTUFFCOST = 3

	self._ATTACKRATIO = 1
	self._PACKRATIO = 2
	self._WANDERRATIO = 3

	

end

function entity:_spawnSpecificCreatures( )
	local creaturesToSpawn = rngMap:getCreatureToSpawnTable( )
	for i,v in ipairs(creaturesToSpawn) do
		--print("NOCTUS: "..v._x.. " | "..v._y.." TYPE: "..v._type.."")
		self:newCreature(v._x, v._y, v._type, v._bool)
	end
end

function entity:spawnGobber(_x, _y )
	self._boxMesh = self._gobber
	self._blockSize = 100
	self._floorElevation = 0
	local creatureNewTable = { }
	local yOffsetForHeight = 0
	local temp = {
		id = #self._entityTable + 1,
		x = _x,
		y = _y,
		prop = image:new3DImage(self._boxMesh, _x*self._blockSize, self._blockSize, _y*self._blockSize, 2),
		baseDamage = 1,
		heightDiff = yOffsetForHeight,
		energy = 4,
		mesh = self._boxMesh,
		angle = 1,
		speed = 25,
		timer = Game.worldTimer,
		hp = 15,
		initial_health = 15,
		name = "Gobber",
		isAttacking = false,
		state = "Follow", -- YES I USE STRINGS TO COMPARE, GTFO! 
		path = nil,
		hasGoal = false,
		destX = _x,
		destY = _y,
		cur = 1,
		isFollowing = false,
		mvRange = 0,--math.random(1,3),
		isDone = false,
		healthModifier = 0,
		regenModifier = 0,
		colorFactor = 0.0,
		nilCounter = 0,
		sightRange = 5,
		maxColor = 0.4,
		inventory = { },
		inventoryCapacity = 6,
		isBox = false,
		}


	temp.initialEnergy = temp.energy
	temp.movementR = { }
	temp.movementR[1] = 1
	temp.movementR[2] = 4
	temp.movementR[3] = 4
	temp.weaponAffinity = 0

	temp.isCreature = true
	--end
	--local nrItems = math.random(1, 5)
	--for i = 1, nrItems do
		--local rndSpawn = math.random(1, 5)
		--if rndSpawn >= 0 then
			item:new(_x, _y, 67)
			self:pickupItem(temp, false)
		--end
	--end
	table.insert(self._entityTable, temp)

	return temp.name

end

function entity:createBoxEntity(_x, _y, _type, _holdImage)
	self._boxMesh = makeBox(60, 40, 60, "tiles/Docks/box_texture_1.png")
	self._blockSize = 100
	self._floorElevation = 0
	local creatureNewTable = { }
	local yOffsetForHeight = 0
	local temp = {
		id = #self._entityTable + 1,
		x = _x,
		y = _y,
		prop = image:new3DImage(self._woodenBox[_type], _x*self._blockSize, self._blockSize-30, _y*self._blockSize, 2),
		baseDamage = 1,
		heightDiff = yOffsetForHeight,
		energy = 1,
		mesh = self._boxMesh,
		angle = 1,
		speed = 0.1,
		timer = Game.worldTimer,
		hp = 10,
		initial_health = 10,
		name = "WoodenBox",
		isAttacking = false,
		state = "Idle", -- YES I USE STRINGS TO COMPARE, GTFO! 
		path = nil,
		hasGoal = false,
		destX = _x,
		destY = _y,
		cur = 1,
		isFollowing = false,
		mvRange = 0,--math.random(1,3),
		isDone = false,
		healthModifier = 0,
		regenModifier = 0,
		colorFactor = 0.0,
		nilCounter = 0,
		sightRange = 5,
		maxColor = 0.4,
		inventory = { },
		inventoryCapacity = 6,
		isBox = true,
		heldImage = _holdImage,
		}


	temp.initialEnergy = temp.energy
	temp.movementR = { }
	temp.movementR[1] = 0
	temp.movementR[2] = 0
	temp.movementR[3] = 0
	temp.weaponAffinity = 0

	temp.isCreature = true
	--end
	local nrItems = math.random(1, 5)
	for i = 1, nrItems do
		local rndSpawn = math.random(1, 5)
		if rndSpawn >= 0 then
			item:newInBox(_x, _y)--item:new(_x, _y)
			self:pickupItem(temp, false)
		end
	end
	table.insert(self._entityTable, temp)

	return temp.name

end

function entity:updateLightning()
	local distFunction = math.distance
	local px, py = player:returnPosition( )
	for i,v in ipairs(self._entityTable) do
		local dist = distFunction(px, py, v.x, v.y)
		if dist > 1 then
			local lightFactor = dist/(7-Game.lightFactor)
			if v.state ~= "sleep" then
				image:setColor(v.prop, 1-lightFactor+v.colorFactor, 1-lightFactor, 1-lightFactor, 1)
			else
				image:setColor(v.prop, 0, 0, 0, 1)	
			end
		end	
	end
end

function entity:updateLightning2(_x, _y)
	local distFunction = math.distance
	local px, py = _x, _y
	for i,v in ipairs(self._entityTable) do
		local dist = distFunction(px, py, v.x, v.y)
		if dist > 1 then
			local lightFactor = dist/(7-Game.lightFactor)
			if v.state ~= "sleep" then
				image:setColor(v.prop, 1-lightFactor+v.colorFactor, 1-lightFactor, 1-lightFactor, 1)
			else
				image:setColor(v.prop, 0, 0, 0, 1)	
			end
		else
			local lightFactor = 0
			if v.state ~= "sleep" then
				image:setColor(v.prop, 1-lightFactor+v.colorFactor, 1-lightFactor, 1-lightFactor, 1)
			else
				image:setColor(v.prop, 0, 0, 0, 1)	
			end
		end	
	end
end

function entity:getName( _id )
	if self._entityTable[_id] ~= nil then
		local v = self._entityTable[_id]
		return v.name
	end
end

function entity:getList( )
	return self._entityTable
end

function entity:updateHealthModifier(_v, _amount)
	local v = _v
	v.healthModifier = _amount
end

--getAllCreatureList( )

function entity:newCreature(_x, _y, _tp, _isTowerLevel)
	local creatureNewTable = { }
	local yOffsetForHeight = 0
	creatureNewTable =  self:getAllCreatureList( )
	
	--print("CREATURE TABLE: "..creatureNewTable[_tp].mesh.."")
	--print("TP IS: ".._tp.."")
	if creatureNewTable[_tp] ~= nil then
		if creatureNewTable[_tp].mesh ~= nil then
			--print("MESH EXISTS")
		else
			--print("VAMPIRE MESH NO REALLY AQUI")
		end
	else
		--print("THE ENTIRE CREATURE TABLE DOES NOT EXIST WTF")
		--print("CREATURE TABLE SIZE: "..#creatureNewTable.."")
		for i = 1, #creatureNewTable do
			--print("CREATURE NEW TABLE NAME: "..creatureNewTable[i].name.."")
		end
	end
	if #creatureNewTable > 0 then
		local temp = {
			id = #self._entityTable + 1,
			x = _x,
			y = _y,
			prop = image:new3DImage(creatureNewTable[_tp].mesh, _x*100, 100, _y*100, 2),
			baseDamage = creatureNewTable[_tp].baseDamage,
			heightDiff = yOffsetForHeight,
			energy = creatureNewTable[_tp].energy,
			mesh = creatureNewTable[_tp].mesh,
			angle = 1,
			speed = tonumber(creatureNewTable[_tp].speed),
			timer = Game.worldTimer,
			hp = creatureNewTable[_tp].hp,
			initial_health = creatureNewTable[_tp].hp,
			name = creatureNewTable[_tp].name,
			isAttacking = false,
			state = "Idle", -- YES I USE STRINGS TO COMPARE, GTFO! 
			path = nil,
			hasGoal = false,
			destX = _x,
			destY = _y,
			cur = 1,
			isFollowing = false,
			mvRange = 1,--math.random(1,3),
			isDone = false,
			healthModifier = 0,
			regenModifier = 0,
			--isCreature = ,
			colorFactor = 0.0,
			nilCounter = 0,
			sightRange = 5,
			maxColor = 0.4,
			inventory = { },
			inventoryCapacity =creatureNewTable[_tp].inventoryCapacity,
			isBox = false,

			}


		temp.initialEnergy = temp.energy
		temp.movementR = { }
		temp.movementR[1] = creatureNewTable[_tp].Ratio1
		temp.movementR[2] = creatureNewTable[_tp].Ratio2
		temp.movementR[3] = creatureNewTable[_tp].Ratio3
		temp.weaponAffinity = creatureNewTable[_tp].weaponAffinity

		if temp.name == "Dae-Ria" then
			temp.sightRange = 15
		end

		if creatureNewTable[_tp].isCreature == "yes" then
			temp.isCreature = true
		else
			temp.isCreature = false
		end
		local itemList = {} 
		--print("UM INV: "..creatureNewTable[_tp].InventoryItem.."")
				-- ,
		if string.len(creatureNewTable[_tp].InventoryItem) > 2 then

			counter = 1;
			for newItem in string.gmatch(creatureNewTable[_tp].InventoryItem, '([^;]+)') do
			    itemList[counter] = tonumber(newItem)
			    --print("DEH NUMBERS: "..tonumber(newItem).."")
			    counter = counter + 1
			end
		end

		if temp.inventoryItem ~= 0 then
			if #itemList > 0 then
				for i = 1, #itemList do
					item:new(temp.x, temp.y, itemList[i])
					self:pickupItem(temp)
				end
			else
				temp.inventoryItem = creatureNewTable[_tp].InventoryItem
				if temp.inventoryItem ~= 0 then
					item:new(temp.x, temp.y, temp.inventoryItem)
					self:pickupItem(temp)
				end
			end
		end

		-- create a default item and add it to the entity's inventory
		--item:new(temp.x, temp.y, 4)
		--[[local bool, _id = item:isItemAt(temp.x, temp.y)
		if bool == true then
			local _item = item:returnItem(_id)
			self:addItemToInventory(temp, _item)
			item:dropitem(_id)
			log:newMessage(""..temp.name.." picked up ".._item.name.."")
		end--]]
		table.insert(self._entityTable, temp)

		return temp.name
	end
end

function entity:new(_x, _y, _tp, _isTowerLevel)
	local creatureNewTable = { }
	local yOffsetForHeight = 0
	if _isTowerLevel ~= true then
		self._entityCreatureTable = self:makeSpawnListForLevel( )
		creatureNewTable = self._entityCreatureTable
		yOffsetForHeight = 10
	else
		self._entityTowerDwellersTable = self:makeSpawnListForTowerLevel( )
		creatureNewTable = self._entityTowerDwellersTable
	end
	if #creatureNewTable > 0 then
		local temp = {
			id = #self._entityTable + 1,
			x = _x,
			y = _y,
			prop = image:new3DImage(creatureNewTable[_tp].mesh, _x*100, 100, _y*100, 2),
			baseDamage = creatureNewTable[_tp].baseDamage,
			heightDiff = yOffsetForHeight,
			energy = creatureNewTable[_tp].energy,
			mesh = creatureNewTable[_tp].mesh,
			angle = 1,
			speed = tonumber(creatureNewTable[_tp].speed),
			timer = Game.worldTimer,
			hp = creatureNewTable[_tp].hp,
			initial_health = creatureNewTable[_tp].hp,
			name = creatureNewTable[_tp].name,
			isAttacking = false,
			state = "Idle", -- YES I USE STRINGS TO COMPARE, GTFO! 
			path = nil,
			hasGoal = false,
			destX = _x,
			destY = _y,
			cur = 1,
			isFollowing = false,
			mvRange = 1,--math.random(1,3),
			isDone = false,
			healthModifier = 0,
			regenModifier = 0,
			--isCreature = ,
			colorFactor = 0.0,
			nilCounter = 0,
			sightRange = 5,
			maxColor = 0.4,
			inventory = { },
			inventoryCapacity =creatureNewTable[_tp].inventoryCapacity,
			isBox = false,

			}


		temp.initialEnergy = temp.energy
		temp.movementR = { }
		temp.movementR[1] = creatureNewTable[_tp].Ratio1
		temp.movementR[2] = creatureNewTable[_tp].Ratio2
		temp.movementR[3] = creatureNewTable[_tp].Ratio3
		temp.weaponAffinity = creatureNewTable[_tp].weaponAffinity
		--image:set3DDeck(temp.prop, self._ratTexture)
		--image:set3DIndex(temp.prop, 1)

		--[[if tostring(self._entityCreatureTable[_tp].hasAnim) ~= "0" then
			local animFrames = tonumber(self._entityCreatureTable[_tp].hasAnim)
			local anim = tostring(self._entityCreatureTable[_tp].animName)
			temp.anim = mAnim:new(temp.mesh, anim, animFrames, 0.4, temp.prop)
			if tostring(self._entityCreatureTable[_tp].attackAnim) ~= "" then -- we can play attack stuff
				local attackFrames = tonumber(self._entityCreatureTable[_tp].Frames)
				local atkAnim = tostring(self._entityCreatureTable[_tp].attackAnim)
				temp.attackAnim = mAnim:new(temp.mesh, atkAnim, attackFrames, (temp.speed/100)/attackFrames, temp.prop, false )
			end


		end--]]
		if creatureNewTable[_tp].isCreature == "yes" then
			temp.isCreature = true
		else
			temp.isCreature = false
		end
		local itemList = {} 
		--print("UM INV: "..creatureNewTable[_tp].InventoryItem.."")
				-- ,
		if string.len(creatureNewTable[_tp].InventoryItem) > 2 then

			counter = 1;
			for newItem in string.gmatch(creatureNewTable[_tp].InventoryItem, '([^;]+)') do
			    itemList[counter] = tonumber(newItem)
			    --print("DEH NUMBERS: "..tonumber(newItem).."")
			    counter = counter + 1
			end
		end

		if temp.inventoryItem ~= 0 then
			if #itemList > 0 then
				for i = 1, #itemList do
					item:new(temp.x, temp.y, itemList[i])
					self:pickupItem(temp)
				end
			else
				temp.inventoryItem = creatureNewTable[_tp].InventoryItem
				if temp.inventoryItem ~= 0 then
					item:new(temp.x, temp.y, temp.inventoryItem)
					self:pickupItem(temp)
				end
			end
		end

		-- create a default item and add it to the entity's inventory
		--item:new(temp.x, temp.y, 4)
		--[[local bool, _id = item:isItemAt(temp.x, temp.y)
		if bool == true then
			local _item = item:returnItem(_id)
			self:addItemToInventory(temp, _item)
			item:dropitem(_id)
			log:newMessage(""..temp.name.." picked up ".._item.name.."")
		end--]]
		table.insert(self._entityTable, temp)

		return temp.name
	end
end


function entity:makeSpawnListForLevel( )
	local level = Game.dungeoNLevel
	local spawnList = { }
	for i,v in ipairs(self._entityCreatureTable) do
		if v.dungeonLevel == level then
			table.insert(spawnList, v)
		end
	end

	return spawnList
end

function entity:makeSpawnListForPCGLevel( )
	local level = Game.dungeoNLevel
	local spawnList = { }
	for i,v in ipairs(self._entityCreatureTable) do
		if v.dungeonLevel == level then
			table.insert(spawnList, v)
		end
	end
	return spawnList
end

function entity:getAllCreatureList( )
	local spawnList = { }
	for i,v in ipairs(self._specificSpawnCreatureTable ) do
		table.insert(spawnList, v)
	end

	return spawnList
end

function entity:makeSpawnListForLevelSummoning( )
	local level = Game.dungeoNLevel
	local spawnList = { }
	for i,v in ipairs(self._entityCreatureTable) do
		if v.dungeonLevel <= level then
			table.insert(spawnList, v)
		end
	end

	return spawnList
end

function entity:makeSpawnListForTowerLevel( )
	local level = Game.dungeoNLevel
	local spawnList = { }
	for i,v in ipairs(self._entityTowerDwellersTable) do
		if v.dungeonLevel == level then
			table.insert(spawnList, v)
		end
	end

	return spawnList
end

function entity:debugSpawner(_x, _y )
	local creatureName = ""
	if Game.dungeonType == 1 then

		if #self:makeSpawnListForTowerLevel( ) > 0 then
			creatureName = self:new(_x, _y, math.random(1, #self:makeSpawnListForTowerLevel( ) ), true)
		end
	else

		if #self:makeSpawnListForLevel( ) > 0 then
			creatureName = self:new(_x, _y, math.random(1, #self:makeSpawnListForLevel( ) ))
		end
	end
	return creatureName
end

function entity:summonSpawner(_x, _y )
	local creatureName = " "
	if #self:makeSpawnListForLevel( ) > 0 then
		if  Game.grid[_x][_y] == 0 and self:isEntityAt(_x, _y) == false then
			creatureName = self:new(_x, _y, math.random(1, #self:makeSpawnListForLevel( ) ), false)
		end
	end

	return creatureName
end

function entity:update( )
	local rx, ry, rz = camera:getRot( )
	for i,v in ipairs(self._entityTable) do
		if v.isBox == false then
			
			image:setRot3D(v.prop, rx, ry, 0)
			--self:handleMovement(i)
		end
		if v.hp <= 1 then
			self:dropEntity(i)
		end
	end
end

function entity:dropEntity(_id, _forceDelete)
	local v = self._entityTable[_id]
	if v ~= nil then
		image:removeProp(v.prop, 2)
		self:dropAllitemsFromInventory(v)
		v.prop = nil
		if _forceDelete ~= true then
			if v.isBox == false then
				log:newMessage("You killed <c:0B5E87>"..v.name.."</c>")
			else
				log:newMessage("You destroyed the <c:0B5E87>"..v.name.."</c>")
				local heldObject = v.heldImage
				if heldObject ~= nil then
					image:setLoc(heldObject, v.x*100, 63, v.y*100)
				end
			end
			table.remove(self._entityTable, _id)
		end

		if v.anim ~= nil then
			mAnim:dropAnim(v.anim)
		end

	end
end

function entity:removeAll( )
	for i,v in ipairs(self._entityTable) do
		self:dropEntity(i, true)
	end

	for i = 1, #self._entityTable do
		table.remove(self._entityTable, i)
	end
end


function entity:handleMovement(_id)

end


function entity:goAfterPlayer(_v, _px, _py)
	local v = _v


end

function entity:getEntityWithID(_id)
	local id = nil
	for i,v in ipairs(self._entityTable) do
		if v.id == _id then
			id = i
		end
	end

	return id
end

function entity:performAction(_id)

	local v = self._entityTable[ self:getEntityWithID(_id) ]
	if v ~= nil then -- we can't have a nonexisting entity right? He he he he 
			-- step 1 - Check what state the entity is in
		v.__lID = _id
		local state = v.state
		if v.isBox == false then
			local evaResult = self:evaluateEnvironment(v)
			self:_regenHp(v)
			-- if evaResult is nil it means there is nothing of interest happening nearby :(
			if evaResult == nil then
				if v.state ~= "Follow" then
					if state == "Idle" then
						self:handleIdle(v)
					elseif state == "Aware" then
						self:handleAware(v)
					elseif state == "Combat" then
						self:handleAware(v)
					elseif state == "sleep" then
						self:handleSleep(v)
					end
				else
					self:handleFollowPlayer(v)
				end
			else -- OUR EVALUATION GAVE US THE MOST INTERESTING THING... YEAH!!!
				-- first, check the type of our evaluation.
				-- AI needs to behave differently depending on what the most interesting
				-- thing is. If it's a player, go into the AWARE mode. If it's an entity
				-- stay idle but decide weather to follow it.
				local evaType = evaResult._type
				if rngMap:isPatchAt(v.x, v.y, true) == true then -- if creature is in a darkness patch it will go into idle mode (AKA HE IS BLINDED. No playa'!)

					v.state = "Idle"
					self:handleIdle(v)
				else
					if v.state ~= "Follow" then
						if v.state ~= "sleep" then
							if evaType == 1 then -- type is 1. SO PLAYER
								v.state = "Aware" -- go into aware mode! 
								self:handleAware(v)
							elseif evaType == 2 then -- type is 2. SO ENTITY
								v.state = "Idle"
								self:handleIdle(v)
								-- IF TYPE OF ENTITY IS THE SAME ONE, PACK TOGETHER
								--v.destX = evaResult.x
								--v.destY = evaResult.y
							elseif evaType == 3 then -- item! Let's go IDLE BUUUUTTTTTTT,
								-- let'saa get that shiny, shiny, item (if we can)
								v.state = "Idle"

								-- by setting destX and destY to a value different than v.x, v.y, we
								-- pretty much give a direct goal to our entity in the moveAtRandom function
								-- bypassing the initial check and/or interrupting it's current movement 
								-- direction
								--print("ENTITY WITH ID: "..v.__lID.." Saw something interesting")
								v.destX = evaResult.x
								v.destY = evaResult.y
								self:handleIdle(v)
							end
						else
							self:handleSleep(v)
						end
					else
						self:handleFollowPlayer(v)
					end
				end


			end
		end
	end

end

function entity:handleSleep(_v)
	local wakeChance = 15
	local randomRoll = math.random(1, 100)
	--image:setColor(_v.prop, 0.4, 0.4, 0.4, 1)	
	local px, py = player:returnPosition( )
	local dist = math.dist(px, py, _v.x, _v.y)
	if randomRoll <= wakeChance then
		_v.state = "Aware"
		if dist < 5 then
			log:newMessage(" ".._v.name.." woke up")
		end
		
	else
		if dist < 5 then
			log:newMessage(" ".._v.name.." is still sleeping")
		end
	end
	image:setColor(_v.prop, 0, 0, 0, 1)	
end

function entity:handleFollowPlayer(_v)
	local v = _v

	local px, py = player:returnPosition( )
	self:followPlayer(v)
	if math.random(1, 10) == 2 then
		self:throwItem(v)
	end

end

-- Daddy function that handles what a entity does while 
-- in the Idle state. Starts by checking if the player is
-- nearby. If not, it sends the entity to move at random.
-- If the player is nearby, it will enter into the Aware state.
function entity:handleIdle(_v)
	local v = _v
	local bool = self:checkForPlayer(_v)
	if self:checkForPlayer(_v) == true then
		v.state = "Aware"
		self:handleAware(v)
		v.colorFactor = v.maxColor
	else
		v.colorFactor = 0.0
		self:moveAtRandom(v)
	end
	--self:_gotoLoc(v, px, py)
end

-- When Aware of the player, an entity will first check it's behavior to see what to do.
-- If it's an attacked inclined enemy, it will see if it can attack the player or
-- wheater to follow it.
function entity:handleAware(_v)
	local v = _v
	-- get the current ratio!
	local attackRatioMod = 0
	-- if the enemy is damaged (let's say, by the player, then lets make the enemy
	-- more likely to attack the player)
	if v.hp < v.initial_health+v.healthModifier then
		attackRatioMod = 6
	end

	local ratioSelected = self:decideRatio(v.movementR[self._ATTACKRATIO]+attackRatioMod, v.movementR[self._PACKRATIO], v.movementR[self._WANDERRATIO])
	if ratioSelected == 1 then -- it means the monster wants to attack
		-- see how far the player is
		--print("I WANT TO ATTACK THE PLAYER")
		local dist = self:getDistanceFromPlayer(v)

		--- the whole DIST 1 -> 5 thing needs to be changed
		-- to a, "SHOULD I ATTACK FROM RANGE?"
		-- or go into melee! Dist based is nevah good!
		--[[if dist <= 1 then -- next to the player
			self:_attack(v)
		elseif dist > 1 and dist <= 5  then --and self:isInventoryEmpty(v) == false
			print("DIS IS HAPPENING")

			self:throwItem(v)
		else -- further away
			self:followPlayer(v)
		end--]]
		local _dist = dist
		local px, py = player:returnPosition( )

		if rngMap:_DarknessAt(px, py) == true then
			--print("TRUE")
			dist = 50000
		end

		if dist <= 1 then
			self:_attack(v)
			v.colorFactor = v.maxColor
		elseif dist > 1 and dist <= 5 then
			local rndAction = math.random(1, 3)
			if self:isInventoryEmpty(v) == false then
				self:followPlayer(v)
			else
				if rndAction == 1 then
					self:followPlayer(v)
				else
					self:throwItem(v)
				end
			end
		end


		--print("GOING IN FOR THE KILL")
	elseif ratioSelected == 2 then
		-- pack, so search for a player
		v.state = "Aware"
	elseif ratioSelected == 3 then
		v.state = "Idle"
	else
		v.state = "Idle"
	end
end

-- Entity looks around to see if he spots anything of interest
-- this includes other entities, the player or items.
-- it will evaluate wether to follow the player and go
-- into the AWARE state, or go for an item. Or, stay idle.
function entity:evaluateEnvironment(_v)
	local v = _v
	if v ~= nil then
		-- the evaluationTable contains a list of environment
		-- observations from the entity, such as Items in it's vicinity,
		-- the player's perceived value/str or other entities nearby.
		local evaluationTable = { }
		-- loop around all positions near the entity
		for x = -v.sightRange, v.sightRange do
			for y = -v.sightRange, v.sightRange do


				-- check to see if the player or another entity is there
				local bool, id = self:isEntityAtLoc(v.x-x, v.y-y, v)
				local px, py = player:returnPosition( )
				local seePlayer = true
				if rngMap:_DarknessAt(px, py) == true then
					print("TRUE")
					seePlayer = false
				end
				if bool == true then -- it means there's a entity there (or player)
					if id == nil then -- clearly a player, since ID returns value for entity
						if seePlayer == true then
							local temp = {
								id = #evaluationTable + 1,
								value = 9000,
								x = v.x-x,
								y = v.y-y,
								_type = 1, -- ONE IS PLAYER
							}
							table.insert(evaluationTable, temp)
						end
					else
						local temp = {
							id = #evaluationTable + 1,
							value = 0, -- getPerceivedDangerForEntity -- NO MORE ENTITY INFIGHTING
							x = v.x-x,
							y = v.y-y,
							_type = 2, -- TWO IS ENTITY
						}
						table.insert(evaluationTable, temp)
					end
				end

				if #v.inventory < v.inventoryCapacity then
					-- now check to isee if there is an item there
					local bool, _id = item:isItemAt(v.x-x, v.y-y)
					if bool == true then -- so there is something there
						local _item = item:returnItem(_id) -- get the item based on it's id
						local temp = {
							id = #evaluationTable + 1,
							value = _item.value,
							x = v.x-x,
							y = v.y-y,
							_type = 3, -- THREE IS ITEM

						}
						table.insert(evaluationTable, temp)				

					end
				end
			end
		end

		-- now, sort the table! Insert the sorted values
		-- inside a new table for easy management
		local sortedEvaTable = { }
		if evaluationTable ~= nil then
			for i,v in spairs(evaluationTable, function(t,a,b) return t[b].value < t[a].value end) do
				table.insert(sortedEvaTable, v)
			end		

			-- first item in the table should be the most INTERESTING ONE! Return it
			if #sortedEvaTable ~= nil then
				return sortedEvaTable[1]
			end
		end
	end
	return nil

end

function entity:getPerceivedDangerForPlayer( )
	return player:calcDamage(1) -- so, pretty much get player's damage value from items :)
end

function entity:getPerceivedDangerForEntity(_id)
	local v = self._entityTable[_id]
	if v ~= nil then
		return entity:_calcDamage(v, 1)
	end
end

function entity:decideRatio(_ratio1, _ratio2, _ratio3)
	local r1 = _ratio1
	local r2 = _ratio2
	local r3 = _ratio3

	r2 = r2 + r1
	r3 = r3 + r1
	local r = math.random(1, r3)
	if r > r2 then
		return 3
	end
	if r > r1 then
		return 2
	end
	return 1
end

function entity:followPlayer(_v)
	local v = _v
	local px, py = self:getEmptySpotNextToPlayer( )--player:returnPosition( )
	if v.isFollowing == false then
		--log:newMessage("You feel as if you are <c:0B5E87> being followed! </c>")
		v.isFollowing = true
	end
	sound:play(Game.walk)
	self:move(v, px, py)
end

function entity:getEmptySpotNextToPlayer( )
	local px, py = player:returnPosition( )
	local distFunction = math.dist
	for i = -1, 1 do
		for j = -1, 1 do
			local _px = px-i
			local _py = py-j
			if distFunction(px, py, _px, _py) == 1 then
				if Game.grid[px-i][py-j] == 0 and self:isEntityAt(px-i, py-j) == false then
					return px-i, py-j
				end
			end
		end
	end

	return px, py
end

function entity:moveAtRandom(_v)
	local v = _v
	-- check if entity is there
	if v.destX == v.x and v.destY == v.y then
		local eX, eY = rngMap:returnEmptyLocations( )
		v.destX = eX
		v.destY = eY
	end
	--print("DESTX : "..v.destX.." | DESTY: "..v.destY.." X: "..v.x.." Y: "..v.y.."")

	self:move(v, v.destX, v.destY)		


	-- get random location to move towards
end

function entity:move(_v, _x, _y)
	local v = _v
	--local px, py = player:returnPosition( )
	--Game.grid[v.x][v.y] = 0
	local px = _x
	local py = _y
	local posTable = self:_gotoLoc(v, px, py)
	if posTable ~= nil then -- we have all our possible positions
		-- get entities current location
		--print("POS TABLE NOT NIL FRACKERS!")
		local curX = v.x
		local curY = v.y 
		-- get entity destination location based on movement distance
		local mvDist = math.floor(v.energy/self._energyTable[self._MOVEMENTCOST]) -- hardcoded to 2 for now. We'll transform it into entityEnergyCost/Action * speed
		--v.energy = v.energy - mvDist
		--v.energy = v.energy - (self._energyTable[self._MOVEMENTCOST]*mvDist)
		local tableSize = #posTable -- calculate table size only once #OPTIMISATION - little things count 
		if mvDist >= tableSize then
			mvDist = tableSize
		end
		if posTable[mvDist] ~= nil then
			for i = 1, mvDist do
				if self:isEntityAtLoc(posTable[i]._x, posTable[i]._y, v) == false then
					v.x = posTable[i]._x
					v.y = posTable[i]._y
				else
					v.destX = v.x
					v.destY = v.y
				end

				-- check if an item is here and if so, try and pick it up! If
				-- that is what the entity wants, anyway. Might move it somewhere
				-- else later.
				self:pickupItem(v)
				if v.energy > 0 then
					evTurn:addEntityToQue(v)
				end

			end
		else
			--HACK TO HOPEFULLY RESET GOAL DESTINATION
			v.destX = v.x
			v.destY = v.y
			--HACK TO HOPEFULLY RESET GOAL DESTINATION
		end

	else
		
		--HACK TO HOPEFULLY RESET GOAL DESTINATION
		v.destX = v.x
		v.destY = v.y
		--HACK TO HOPEFULLY RESET GOAL DESTINATION
	end
	--Game.grid[v.x][v.y] = 1
	image:seekLoc(v.prop, v.x*100, 100-v.heightDiff, v.y*100, 0.2)
end

-- Input: Entity and Target Location (x, y)
-- Takes in account it's current location and tries to establish a path to the goal
-- Checks if the next step of the path is free. If so, it moves 1 step * modifier
-- If something blocks it's path, it will search for an additional route.
-- Returns next location the entity must reach (two vars, _dX and _dY)
function entity:_gotoLoc(_v, _x, _y)
	local v = _v
	local path = pather:getPath(v.x, v.y, _x, _y)
	local positionTable = { }
	--print("Um... Path?")

	if path ~= nil then -- path established
		--print("YES PATH....")
		--local nodeList = path:nodes()

		-- path:getNodeList has been removed in latest JUMPER release. Thus, a custom way of obtaining
		-- the nodes is needed :(
		local nodeList = { }
		local nidx = 0
		for node, count in path:nodes( ) do
			nidx = nidx + 1
			nodeList[nidx] = { }
			nodeList[nidx]._x = node:getX( )
			nodeList[nidx]._y = node:getY( )
		end
		

		if nodeList ~= nil then
			--print("YES NodeList....")
			local nlSize = #nodeList -- size of the nodeList
			local nodeDistance = self:_checkNodeList(nodeList, v)
			if nodeDistance ~= nil then
				if nodeDistance < 2 then -- our path is blocked sadly :(
					-- return a NIL and ASK turn Manager to put the creature back in the list again.
					-- increment entities nil counter. When it reaches a certain value just FRACK IT!
					--print("ugh......")
					v.destX = v.x
					v.destY = v.y
					v.nilCounter = v.nilCounter + 1
					return nil
				else
					for i = 1, nodeDistance do
						positionTable[i] = nodeList[i]
					end
				end
			else
				--HACK TO HOPEFULLY RESET GOAL DESTINATION
				v.destX = v.x
				v.destY = v.y
				--HACK TO HOPEFULLY RESET GOAL DESTINATION
			end
		else
			--HACK TO HOPEFULLY RESET GOAL DESTINATION
			v.destX = v.x
			v.destY = v.y
			--HACK TO HOPEFULLY RESET GOAL DESTINATION
		end
	else
		--HACK TO HOPEFULLY RESET GOAL DESTINATION
		v.destX = v.x
		v.destY = v.y
		--HACK TO HOPEFULLY RESET GOAL DESTINATION
	end 
	return positionTable
end

-- Input: List of 2D table with X and Y positions.
-- Function checks recursively all positions in that list and sees
-- how far through a path a entity can traverse before it reaches an
-- occupied space.
-- Returns a number that represents how far an entity can go up that list
function entity:_checkNodeList(_list, _v)
	local list = _list
	local idx = 1
	local bool = false
	if list[idx] ~= nil and idx < #list then
		repeat
			bool = self:isEntityAtLoc(list[idx]._x, list[idx]._y, _v)
			idx = idx + 1
		until bool == true or idx == #list
		return idx
	else
		return nil
	end
end



function entity:checkForPlayer(_v)
	local v = _v
	local px, py = player:returnPosition( )
	--[[local dist = math.dist(v.x, v.y, px, py)
	if dist <= v.sightRange then -- go for player
		return true
	end
	return false--]]

	local path = pather:getPath(v.x, v.y, px, py)
	if path ~= nil then
		local len = path:getLength( )
		if len <= v.sightRange then
			return true
		end
	else
		return false
	end
	return false

end

function entity:getDistanceFromPlayer(_v)
	local v = _v
	local px, py = player:returnPosition( )
	local dist = math.dist(v.x, v.y, px, py)
	return dist
end



function entity:findEmptyLocationNextTo(_x, _y, _range, _v)

end

function entity:isEntityAtLoc(_x, _y, _v)
	local bool = false
	local px, py = player:returnPosition( ) -- Also retrieve player location because he is technically an entity
	local id = nil
	local _newV = nil
	for i,v in ipairs(self._entityTable) do
		if v.id ~= _v.id then
			if v.x == _x and v.y == _y then
				bool = true
				id = i
				_newV = v
			end
		end

		if px == _x and py == _y then
			bool = true
		end
	end
	return bool, id, _newV
end

function entity:isEntityAt(_x, _y)
	local bool = false
	local px, py = player:returnPosition( ) -- Also retrieve player location because he is technically an entity
	local id = nil
	local _newV = nil
	for i,v in ipairs(self._entityTable) do
		if v.x == _x and v.y == _y then
			bool = true
			id = i
			_newV = v
		end

		if px == _x and py == _y then
			bool = true
		end
		
	end
	return bool, id, _newV
end

--------------------------------------------
----- COMBAT STUFF -------------------------
--------------------------------------------

function entity:_combatDebug(_entityID, _forcedDamage)
	local v = self._entityTable[_entityID]
	--log:newMessage("You dealt quit a bit of damage to it")
	--if v.isBox == false then
		--print("FIGHTING A CREATURE")
		
		local plDMG = player:calcDamage(1)
		local entDef = self._armorStats[1].def
		local combatResult = plDMG - entDef

		if _forcedDamage ~= nil then
			combatResult =_forcedDamage
		end

		if combatResult > 0 then
			v.hp = v.hp - math.floor(combatResult)
		else
			combatResult = 0
		end

		log:newMessage("You dealt <c:0B5E87>"..math.abs(math.floor(combatResult)).."</c> to <c:0B5E87>"..v.name.."</c>  <c:296B29>HP Left: "..math.abs(math.floor(v.hp)).."</c>")
		--v.hp = v.hp - 10
	--end
end


function entity:_receiveDamage(_entityID, _forcedDamage)
	local v = self._entityTable[_entityID]
	--log:newMessage("You dealt quit a bit of damage to it")
	--if v.isBox == false then
		--print("FIGHTING A CREATURE")
		
		local plDMG = player:calcDamage(1)
		local entDef = self._armorStats[1].def
		local combatResult = plDMG - entDef

		if _forcedDamage ~= nil then
			combatResult =_forcedDamage
		end

		if combatResult > 0 then
			v.hp = v.hp - math.floor(combatResult)
		else
			combatResult = 0
		end

		log:newMessage("<c:0B5E87>"..v.name.."</c> received <c:0B5E87>"..math.abs(math.floor(combatResult)).."</c> damage. <c:296B29>HP Left: "..math.abs(math.floor(v.hp)).."</c>")
		--v.hp = v.hp - 10
	--end
end

function entity:_doDamage(_entityID, _dmgValue)
	local v = self._entityTable[_entityID]
	--if v.isBox == false then
		--print("FIGHTING A CREATURE")
		
		local entDef = self._armorStats[1].def
		local combatResult = _dmgValue - entDef

		if combatResult > 0 then
			v.hp = v.hp - math.abs(combatResult)
		end

		log:newMessage("You dealt <c:0B5E87>"..math.abs(math.floor(combatResult)).."</c> to <c:0B5E87>"..v.name.."</c>  <c:296B29>HP Left: "..math.abs(math.floor(v.hp)).."</c>")
		--player:setKilledBy(""..v.name.."")
		player:addToScore(combatResult)		--v.hp = v.hp - 10
	--end
end

function entity:_attack(_v)
	local v = _v
	if v ~= nil then
		local damage, roll = self:_calcDamage(v, 1)
		local dmgAmmount = math.floor(player:receiveDamage(math.floor( damage) ) )
		--print("SHIT BE ATTACKING ME")
		
		local critText = ""
		if roll == 20 then
			critText = "<c:4B647B>[Critical Hit!]</c>"
		end
		--print("TEST TEST TEST")
		sound:play(Game.attack)
		log:newMessage("The "..v.name.." attacked you for "..dmgAmmount.." damage "..critText.."")
		player:setKilledBy(""..v.name.."")
	end

end

function entity:_decideWeatherToRangeOrMelee(_v)
	local v = _v

	-- get player location
	local px, py = player:returnPosition( )
	-- get distance to player via a path
	local path = pather:getPath(v.x, v.y, px, py)
	local distanceToPlayer = path:getLength( )
	
	if path == nil then -- there is a path
		distanceToPlayer = math.dist(v.x, v.y, px, py)
	end

	--print("Distance to Player: "..distanceToPlayer.."")

	--  
	-- check inventory to see if there's anything we can throw! 
	local anythingToThrow = false
	local throwWeight = 0

	local _item = self:_getHeaviestItemInInventory( )
	if v.inventory[1] ~= nil then
		anythingToThrow = true
	end

	--print("ITEM WEIGHT: ".._item.weight.."")

	return 1 -- 1 for Melee, 2 for throw


end

function entity:addItemToInventory(_v, _item)
	local v = _v
	if v ~= nil and _item ~= nil then

		local temp = { }
		temp.weapon_dmg = _item.weapon_dmg
		temp.weapon_multi = _item.weapon_multi
		temp.spell_atune = _item.spell_atune
		temp.spell_dmg = _item.spell_dmg
		temp.armor_def = _item.armor_def
		temp.armor_arcane_def = _item.armor_arcane_def
		temp._type = _item._type
		temp.name = _item.name
		temp.weight = _item.weight
		temp.gfxID = _item.gfxID	
		temp.effect = _item.effect	
		temp.value = _item.value	
		table.insert(v.inventory, temp)

	end
end

function entity:dropItemFromInventory(_v, _item)
	local v = _v
	local _dItem = v.inventory[_item]
	item:new(v.x, v.y, _dItem.gfxID)
end

function entity:dropAllitemsFromInventory(_v)
	local v = _v
	if v ~= nil then
		for i,j in ipairs(v.inventory) do
			self:dropItemFromInventory(v, i)
		end
	end
end

function entity:pickupItem(_v, _announce)
	local v = _v
	local bool, _id = item:isItemAt(v.x, v.y)
	if bool == true then
		if #v.inventory < v.inventoryCapacity then
			local _item = item:returnItem(_id)
			self:addItemToInventory(v, _item)
			item:dropitem(_id)
			local dist = self:getDistanceFromPlayer(v)
			if dist < 5 and _announce ~= false then
				log:newMessage(""..v.name.." picked up ".._item.name.."")
			end
		end 
	else
		
	end
end

function entity:_calcDamage(_v,_type)
	local v = _v
	local damage = v.baseDamage
	if _type == 1 then 

		local weaponDamage, weaponMulti = self:returnEquipmentBonus(v)
		local weaponAffinity = v.weaponAffinity

		if weaponMulti == 0 then
			weaponMulti = 1
		end
		local critMulti = 0
		local diceRoll = math.random(1, 20)
		if diceRoll == 20 then
			critMulti = 0
		end
		damage = damage + weaponDamage * (weaponAffinity * weaponMulti)
		local afinityWeaponMulti = weaponAffinity * weaponMulti
		local nDamageCritMulti = damage*critMulti
		damage = damage + damage*critMulti
		--print("CALC DAMAGE TEST")
	else
		damage = 2
	end

	--self:_trainStats(v)

	return damage, diceRoll
end

function entity:returnEquipmentBonus(_v)
	local weapon_damage = 0
	local weapon_multi = 0
	local v = _v
--	print("============== INVENTORY For ENEMY =============")
	for i,j in pairs(v.inventory) do
		--print("Item: "..j.name.." Damage: "..j.weapon_dmg.."")
		weapon_damage = weapon_damage + j.weapon_dmg
		weapon_multi = weapon_multi + j.weapon_multi
	end
--	print("====================== END =====================")

	return weapon_damage, weapon_multi	
end

function entity:isInventoryEmpty(_v)
	local v = _v
	local bool = false
	if #v.inventory > 0 then
		bool = true
	end

	return bool
end

function entity:playerLookAtInventory( )
	local distFunction = math.distance
	if interface:_getLogOpenedStatus( ) == false then
		local px, py = player:returnPosition( )
		local listOfItems = item:getItemsAt(px, py)

		log:newMessage("You examine your nearby surroundings: ")
		if #listOfItems > 0 then
			log:newMessage("At your feet lie: ")
		end
		
		for i,v in ipairs(listOfItems) do
			log:newMessage("* "..v.name.."")
		end
		--local bool, _id = item:isItemAt(px, py)

		--[[local px, py = player:returnPosition( )
		local maxLookDistance = 3
		log:newMessage("You examine your nearby surroundings!")
		local itemTable = {}	
		itemTable[1] = {}
		itemTable[2] = {}
		itemTable[3] = {}
		itemTable[4] = {}
		itemTable[5] = {}
		itemTable[6] = {}
		itemTable[7] = {}
		for i,v in ipairs(self._entityTable) do
			local dist = distFunction(px, py, v.x, v.y)
			if dist <= maxLookDistance then
				if v.inventory ~= nil and v.isBox == false then
					--print("TYPE INVENT: "..type(v.inventory).."")
					for i = 1, #v.inventory do
						local eItem = v.inventory[i]
						table.insert(itemTable[1], eItem.name)
						table.insert(itemTable[2], eItem._type)
						table.insert(itemTable[3], eItem.description)
						table.insert(itemTable[4], eItem.weapon_dmg)
						table.insert(itemTable[5], eItem.armor_def)
						table.insert(itemTable[6], v.name)
						table.insert(itemTable[7], dist)
					end
				end
			end
		end
		local stringTableName = {}
		local stringTableItems = {}
		local itEnemies = #itemTable[6]
		if  itEnemies > 0 then
			for i = 1, itEnemies do
				--print("I: "..i.."")
				local stringEquip = "has equipped the following items: "
				log:newMessage("You notice that <c:25a866>"..itemTable[6][i].."</c> ["..math.floor(itemTable[7][i]).." tiles away] "..stringEquip.."")
				for j = 1, itEnemies do
					if itemTable[2][j] == "Weapon" then
						log:newMessage("* "..itemTable[1][j].." with a damage of: "..itemTable[4][j].."")				
					elseif itemTable[2][j] == "Armor" then
						log:newMessage("* "..itemTable[1][j].." with a defense of: "..itemTable[5][j].."")				
					else
						log:newMessage("* "..itemTable[1][j].."")
					end
				end
			end
			interface:_showFullLog( )
		else
			interface:_closeLog( )
		end--]]

	else
		interface:_closeLog( )
	end
	
end

function entity:throwItem(_v)
	local v = _v
	-- get the item with the most weight in inventory
	--local _itemToThrow = self:_getHeaviestItemInInventory(v)
	--print("THIS SHOULD WORKKKKKZZ!")
	if v.inventory ~= nil then
		local bool, __item = self:_scoreInventory(v)
		if bool == true then --we haz items
			local _item = v.inventory[__item]
			local px, py = player:returnPosition( )
			if _item._type == "Potion" then
				log:newMessage(""..v.name.." threw item ".._item.name.."")
				-- _dmg, _name, _multi, _armor_def, _armor_arcane_def
				item:throwSetStats(_item.gfxID, math.random(1,4), v.x, v.y, nil, _item.weapon_dmg,  _item.name,  _item.weapon_multi,  _item.armor_def,  _item.armor_arcane_def )		
				table.remove(v.inventory, 1)	
			elseif _item._type == "Scroll" then
				item:doItemEffect(_item, v.x, v.y, false)
				log:newMessage(""..v.name.." cast ".._item.name.."")
				table.remove(v.inventory, 1)
			elseif _item._type == "Artefact" then
				item:doItemEffect(_item, v.x, v.y, false)
				log:newMessage(""..v.name.." used artefact ".._item.name.."!")
			elseif _item._type == "Dialogue" then
				item:doItemEffect(_item, v.x, v.y, false)				
			elseif _item._type == "Accessories" then
				self:followPlayer(v)
				local rnd = math.random(1, 6)
				if rnd == 2 then
					log:newMessage(""..v.name.."Stares at the ".._item.name.." in his hand and grins!")
				elseif rnd == 4 then
					log:newMessage(""..v.name.."Places ".._item.name.." in his mouth and growls!")
				end
			else				
				log:newMessage(""..v.name.." threw item ".._item.name.."")
				item:throwSetStats(_item.gfxID, math.random(1,4), v.x, v.y, nil, _item.weapon_dmg,  _item.name,  _item.weapon_multi,  _item.armor_def,  _item.armor_arcane_def )	
				table.remove(v.inventory, 1)
			end
		end
	end
		-- get inventory size :)
		--[[local invSize = #v.inventory
		if v.inventory[1] ~= nil then
			-- get type of item in inventory!
			if v.inventory[1]._type == "Scroll" then
				print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSCROL")
				local px, py = player:returnPosition( )
				self:doItemEffect(v.inventory[1], v.x, v.y, true)
				log:newMessage(""..v.name.." cast "..v.inventory[1].name.."")
				print("ENDSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSCROL")
			else
			log:newMessage(""..v.name.." threw item "..v.inventory[1].name.."")
			item:throw(v.inventory[1].gfxID, math.random(1,4), v.x, v.y)
			--end
			table.remove(v.inventory, 1)
		else
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
			print(" I WANTED TO THROW SOMETHING BUT I HAZ NO SOMETHING")
		end
	
	end--]]

end

-- will only be used in case of smthing, smthing
-- with throwItem. N oneed to check if inv
-- exists. Returns true if there's something in there
-- and also the most valuable content
function entity:_scoreInventory(_v)
	local v = _v
	-- loop through the inventory and check value of items (kinda like we do with evaluate environment)
	local emptyTableEva = false
	local evaluationTable = { }
	for i, j in spairs(v.inventory, function(t,a,b) return t[b].weight < t[a].weight end) do
		table.insert(evaluationTable, i)
	end

	if evaluationTable ~= nil then
		emptyTableEva = true
	end

	local rndChanceForSeconds = math.random(1, 2)
	local item = 1
	if #evaluationTable > 1 then
		if rndChanceForSeconds == 2 then
			item = 2
		end
	end
	return emptyTableEva, evaluationTable[item]
end

function entity:_getHeaviestItemInInventory(_v)
	local v = _v

	local _itemID = nil
	local sortedWeightTable = { }

	for i,j in ipairs(v.inventory) do
		return j
	end


	return _itemID
end
--[[function entity:checkValueOfItemsInInventory(_v)
	local v = _v
	if v ~= nil then
		for i, k 
	end
end--]]






-----------------------------------------------------------------
-------------------- HELPFULL FUNCTIONS -------------------------
local function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function entity:_trainStats(_v)
	local rndChanceToTrain = math.random(1, 100)
	if rndChanceToTrain < 5 then
		_v.weaponAffinity = _v.weaponAffinity + (_v.weaponAffinity/5)
	end
end

function entity:_updateStatsModifier(_v)
	local v = _v
	local modifier = 0
	for i,j in ipairs(v.inventory) do
		if j.modifierType == "hp" then
			modifier = modifier + j.modifier
		end
	end
	v.healthModifier = modifier
	--player:updateHealthModifier(modifier)
end

function entity:_regenHp(_v)
	local v = _v
	if v.hp < v.initial_health + v.healthModifier then
		v.hp = v.hp + v.regenModifier
	end
	--print("Regenerating for : "..v.id.."")
end

function entity:_gobberDialogue( )
	local dialogue1 = "Gobber screams: Why why why why why why why?"
	log:newMessage(""..dialogue1.."")
end

function entity:_SetLevelClear( )
	if Game.dungeonType == 1 or Game.dungeonType == rngMap:returnTowerLevelType( ) then
		local nrEntities = 0
		for i, v in ipairs(self._entityTable) do
			if v.isBox == false then
				nrEntities = nrEntities + 1
			end
		end
		--print("SIZE ENTITY TABLE: "..nrEntities.."")
		if nrEntities == 0 then
			--[[print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&SET LEVEL TO CLEARED")
			print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&SET LEVEL TO CLEARED")
			print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&SET LEVEL TO CLEARED")
			print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&SET LEVEL TO CLEARED")
			print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&SET LEVEL TO CLEARED")--]]
			Game._LevelsClearFlags[Game.dungeoNLevel] = true
		else
			Game._LevelsClearFlags[Game.dungeoNLevel] = false
		end
	end
end