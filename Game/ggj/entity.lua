entity = { }

function entity:init( )
	self._entityTable = { }

	self._entityCreatureTable = { }
	self._entityCreatureTable = loadCSVData("data/creatures.csv")
	self._actionQue = { }

	self._entityTowerDwellersTable = {}
	self._entityTowerDwellersTable = loadCSVData("data/towerDwellers.csv")
	self._movementAnimSpeed = 10

	-- generate their mesh from data
	for i,v in pairs(self._entityCreatureTable) do
		v.mesh = makeBox(100, 100, 0, ""..v.gfx.."")
	end

	for i,v in pairs(self._entityTowerDwellersTable) do
		v.mesh = makeBox(100, 100, 0, ""..v.gfx.."")
	end

	--[[self._fountain = makeBox(100, 100, 0, "fountain.png")
	self._barrel = makeBox(100, 100, 0, "barrel.png")
	self._rat1 = makeBox(100, 100, 0, "rat.png")
	--fountain
	self._entityType = { }
	self._entityType[1] = {gfx = self._rat1, isCreature = true, life = 100, }
	self._entityType[2] = {gfx=self._barrel, isCreature=false}--]]

	

	--[[
	Movement dirs

	]]
	-- rat_tex_multi.png
	--self._ratTexture = image:newDeckTexture("rat_tex_multi.png", 2, "multi_rat_lol", 24)

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

function entity:new(_x, _y, _tp, _isTowerLevel)
	if _isTowerLevel ~= true then
		self._entityCreatureTable = self:makeSpawnListForLevel( )
	else
		self._entityCreatureTable = self:makeSpawnListForTowerLevel( )
	end
	if #self._entityCreatureTable > 0 then
		local temp = {
			id = #self._entityTable + 1,
			x = _x,
			y = _y,
			prop = image:new3DImage(self._entityCreatureTable[_tp].mesh, _x*100, 100, _y*100, 2),
			baseDamage = self._entityCreatureTable[_tp].baseDamage,
			energy = self._entityCreatureTable[_tp].energy,
			mesh = self._entityCreatureTable[_tp].mesh,
			angle = 1,
			speed = tonumber(self._entityCreatureTable[_tp].speed),
			timer = Game.worldTimer,
			hp = self._entityCreatureTable[_tp].hp,
			initial_health = self._entityCreatureTable[_tp].hp,
			name = self._entityCreatureTable[_tp].name,
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

			nilCounter = 0,
			sightRange = 5,

			inventory = { },
			inventoryCapacity = self._entityCreatureTable[_tp].inventoryCapacity,
			inventoryItem = self._entityCreatureTable[_tp].InventoryItem,

			}
		temp.initialEnergy = temp.energy
		temp.movementR = { }
		temp.movementR[1] = self._entityCreatureTable[_tp].Ratio1
		temp.movementR[2] = self._entityCreatureTable[_tp].Ratio2
		temp.movementR[3] = self._entityCreatureTable[_tp].Ratio3
		temp.weaponAffinity = self._entityCreatureTable[_tp].weaponAffinity
		--image:set3DDeck(temp.prop, self._ratTexture)
		--image:set3DIndex(temp.prop, 1)

		if tostring(self._entityCreatureTable[_tp].hasAnim) ~= "0" then
			local animFrames = tonumber(self._entityCreatureTable[_tp].hasAnim)
			local anim = tostring(self._entityCreatureTable[_tp].animName)
			temp.anim = mAnim:new(temp.mesh, anim, animFrames, 0.4, temp.prop)
			if tostring(self._entityCreatureTable[_tp].attackAnim) ~= "" then -- we can play attack stuff
				local attackFrames = tonumber(self._entityCreatureTable[_tp].Frames)
				local atkAnim = tostring(self._entityCreatureTable[_tp].attackAnim)
				temp.attackAnim = mAnim:new(temp.mesh, atkAnim, attackFrames, (temp.speed/100)/attackFrames, temp.prop, false )
			end


		end
		if self._entityCreatureTable[_tp].isCreature == "yes" then
			temp.isCreature = true
		else
			temp.isCreature = false
		end

		if temp.inventoryItem ~= 0 then
			item:new(temp.x, temp.y, temp.inventoryItem)
			self:pickupItem(temp)
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
	if rngMap:isTowerLevel( ) then
		self:new(_x, _y, math.random(1, #self:makeSpawnListForTowerLevel( ) ), true)
	else
		self:new(_x, _y, math.random(1, #self:makeSpawnListForLevel( ) ))
	end
	
end

function entity:update( )
	local rx, ry, rz = camera:getRot( )
	for i,v in ipairs(self._entityTable) do
		if v.isCreature == true then
			
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
			log:newMessage("You killed <c:0B5E87>"..v.name.."</c>")
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

		local evaResult = self:evaluateEnvironment(v)
		self:_regenHp(v)
		-- if evaResult is nil it means there is nothing of interest happening nearby :(
		if evaResult == nil then

			if state == "Idle" then
				self:handleIdle(v)
			elseif state == "Aware" then
				self:handleAware(v)
			elseif state == "Combat" then
				self:handleAware(v)
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
				if evaType == 1 then -- type is 1. SO PLAYER
					v.state = "Aware" -- go into aware mode! 
					self:handleAware(v)
				elseif evaType == 2 then -- type is 2. SO ENTITY
					v.state = "Idle"
					self:handleIdle(v)
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
			end


		end
	end

end

-- Daddy function that handles what a entity does while 
-- in the Idle state. Starts by checking if the player is
-- nearby. If not, it sends the entity to move at random.
-- If the player is nearby, it will enter into the Aware state.
function entity:handleIdle(_v)
	local v = _v
	local bool = self:checkForPlayer(_v)
	if bool == true and rngMap:isPatchAt(v.x, v.y, true) ~= true then
		v.state = "Aware"
		self:handleAware(v)
	else
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
			print("TRUE")
			dist = 50000
		end

		if dist <= 1 then
			self:_attack(v)
		elseif dist > 1 and dist <= 5 then
			local rndAction = math.random(1, 2)
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
								value = self:getPerceivedDangerForPlayer( ),
								x = v.x-x,
								y = v.y-y,
								_type = 1, -- ONE IS PLAYER
							}
							table.insert(evaluationTable, temp)
						end
					else
						local temp = {
							id = #evaluationTable + 1,
							value = self:getPerceivedDangerForEntity(id),
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
		log:newMessage("You feel as if you are <c:0B5E87> being followed! </c>")
		v.isFollowing = true
	end
	sound:play(Game.walk)
	self:move(v, px, py)
end

function entity:getEmptySpotNextToPlayer( )
	local px, py = player:returnPosition( )
	for i = -1, 1 do
		for j = -1, 1 do
			local _px = px-i
			local _py = py-j
			if math.dist(px, py, _px, _py) == 1 then
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
	image:seekLoc(v.prop, v.x*100, 100, v.y*100, 0.2)
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
	for i,v in ipairs(self._entityTable) do
		if v.id ~= _v.id then
			if v.x == _x and v.y == _y then
				bool = true
				id = i
			end
		end

		if px == _x and py == _y then
			bool = true
		end
	end
	return bool, id
end

function entity:isEntityAt(_x, _y)
	local bool = false
	local px, py = player:returnPosition( ) -- Also retrieve player location because he is technically an entity
	local id = nil
	for i,v in ipairs(self._entityTable) do
		if v.x == _x and v.y == _y then
			bool = true
			id = i
		end

		if px == _x and py == _y then
			bool = true
		end
		
	end
	return bool, id
end

--------------------------------------------
----- COMBAT STUFF -------------------------
--------------------------------------------

function entity:_combatDebug(_entityID, _forcedDamage)
	local v = self._entityTable[_entityID]
	--log:newMessage("You dealt quit a bit of damage to it")
	if v.isCreature == true then
		--print("FIGHTING A CREATURE")
		
		local plDMG = player:calcDamage(1)
		local entDef = self._armorStats[1].def
		local combatResult = plDMG - entDef

		if _forcedDamage ~= nil then
			combatResult =_forcedDamage
		end

		if combatResult > 0 then
			v.hp = v.hp - math.abs(combatResult)
		end

		log:newMessage("You dealt <c:0B5E87>"..math.abs(combatResult).."</c> to <c:0B5E87>"..v.name.."</c>  <c:296B29>HP Left: "..math.abs(math.floor(v.hp)).."</c>")
		--v.hp = v.hp - 10
	end
end

function entity:_doDamage(_entityID, _dmgValue)
	local v = self._entityTable[_entityID]
	if v.isCreature == true then
		--print("FIGHTING A CREATURE")
		
		local entDef = self._armorStats[1].def
		local combatResult = _dmgValue - entDef

		if combatResult > 0 then
			v.hp = v.hp - math.abs(combatResult)
		end

		log:newMessage("You dealt <c:0B5E87>"..math.abs(combatResult).."</c> to <c:0B5E87>"..v.name.."</c>  <c:296B29>HP Left: "..math.abs(math.floor(v.hp)).."</c>")
		--player:setKilledBy(""..v.name.."")
		player:addToScore(combatResult)		--v.hp = v.hp - 10
	end
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

function entity:pickupItem(_v)
	local v = _v
	local bool, _id = item:isItemAt(v.x, v.y)
	if bool == true then
		if #v.inventory < v.inventoryCapacity then
			local _item = item:returnItem(_id)
			self:addItemToInventory(v, _item)
			item:dropitem(_id)
			local dist = self:getDistanceFromPlayer(v)
			if dist < 10 then
				log:newMessage(""..v.name.." picked up ".._item.name.."")
			end
		end 
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
			critMulti = 1.3
		end
		damage = damage + weaponDamage * (weaponAffinity * weaponMulti)
		damage = damage + damage*critMulti
	else
		damage = 2
	end

	self:_trainStats(v)

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
				item:throw(_item.gfxID, math.random(1,4), v.x, v.y)		
				table.remove(v.inventory, 1)	
			elseif _item._type == "Scroll" then
				item:doItemEffect(_item, v.x, v.y, false)
				log:newMessage(""..v.name.." cast ".._item.name.."")
				table.remove(v.inventory, 1)
			elseif _item._type == "Artefact" then
				item:doItemEffect(_item, v.x, v.y, false)
				log:newMessage(""..v.name.." used artefact ".._item.name.."!")
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
				item:throw(_item.gfxID, math.random(1,4), v.x, v.y)	
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

	return emptyTableEva, evaluationTable[1]


	--[[

			for i,v in spairs(evaluationTable, function(t,a,b) return t[b].value < t[a].value end) do
				table.insert(sortedEvaTable, v)
			end		
	]]

end

function entity:_getHeaviestItemInInventory(_v)
	local v = _v

	local _itemID = nil
	local sortedWeightTable = { }
	--print("****************************** INVENTORY *****************************************")
	for i,j in ipairs(v.inventory) do
		--print("DEBUG INVENTORY I: "..i.."")
		--table.insert(sortedWeightTable, j)
		--print("I IS: "..i.."")
		return j
	end
	--print("*******************************************************************************")


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