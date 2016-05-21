player = { }
FOVNORMAL = 90
FOVATTACK = 60
player.AAS = 0.1--08
player.AAT = Game.worldTimer
player.aabool = false
player.isDead = false
-- Player class holds data on "Attributes" and on Input methods
function player:saveStats( )
	--for i,v in ipairs(self._playerStats) do
		--table.insert(Game.playerStatsSave, v)
		Game.playerStatsSave = clone_table(self._playerStats)

	--end
end

function player:loadStats( )
	self._playerStats = { }
	--for i,v in ipairs(Game.playerStatsSave) do
		--table.insert(self._playerStats, v)
	self._playerStats = clone_table(Game.playerStatsSave)
	--end
end


function player:exportScore(_scoreMultiplier)
	if _scoreMultiplier == nil then
		_scoreMultiplier = 0
	end
	local temp = { }
	temp.id = 1
	temp.name = ""..Game.scoreTable.name..""
	temp.turns = Game.turn--self._playerTurn
	temp.lvDeath = Game.dungeoNLevel
	temp.killedBy = ""..self._playerKilledBy..""
	temp.score = Game.score + _scoreMultiplier
	--print("SCORE: "..Game.score.."")
	if self:getMostValuableItem( ) ~= nil then
		temp.valuableItem = ""..self:getMostValuableItem( ).name..""
	else
		temp.valuableItem = "his wit!"
	end

	
	table.insert(self._scoreTable, temp)
	interface:_exportScore(self._scoreTable)
end

function player:addToScore(_amount)
	Game.score = Game.score + _amount
end

function player:getMostValuableItem( )
	return interface:_getMostValuableItem( )
end



function player:incTurn( )
	Game.turn = Game.turn + 1
end

function player:setKilledBy(_name)
	self._playerKilledBy = "".._name..""
end

function player:regenLife( )
	self._playerStats.hp = self._playerStats.hp + self._playerStats.regenModifier
	if self._playerStats.hp > self._playerStats.initial_health + self._playerStats.healthModifier then
		self._playerStats.hp =  self._playerStats.initial_health + self._playerStats.healthModifier
	end
end

function player:updateRegenModifier(_amount)
	self._playerStats.regenModifier = _amount
end

function player:init( )
	self._playerName = Game.scoreTable.name
	self._playerTurn = 0
	self._playerKilledBy = ""
	self._playerScore = 0
	self._scoreTable = { }
	--MOAIGfxDevice.getFrameBuffer ():setClearDepth ( true )
	self._playerMesh = makeBox(100, 100, 0, "player_sprite.png")
	self._playerSprite = image:new3DImage(self._playerMesh, 10, 100, 10, 2 )
	image:setVisible3D(self._playerSprite, false)
	player.isDead = false
	camera = MOAICamera.new ()
	camera:setLoc ( 0, 0, camera:getFocalLength ( 360 ))
	core:returnLayer(2):setCamera ( camera )
	core:returnLayer(1):setCamera( camera )
	core:returnLayer(g_Ui_Layer):setCamera(camera)
	camera:setOrtho(false)
	camera:setFieldOfView (FOVNORMAL)
	self._acceptInput = true
	self._endMovementCounter = Game.worldTimer
	self._goForEndMovement = false
	
	self._quitState = 1 -- aka question not asked
	self._quitTimer = Game.worldTimer
	self._quitWait = 3
	--121 - YES, 110 NO
	self._playerStats = {

		speed = 15, -- 15 energy
		baseSpeed = 15,
		weaponAffinity = Game.classOptions[2].weaponAffinity,
		spellAtunement = { },
		spellKnowdlege = Game.classOptions[2].spellKnowdlege,
		initial_health = Game.classOptions[2].initial_health,
		hp = Game.classOptions[2].hp,
		timer = Game.worldTimer,
		str = 100,
		int = 100,
		con = 100,
		dex = 100,
		viewRange = 4,
		healthModifier = 0,
		regenModifier = 0,
		thrownModifier = 1,
		maxWeightIncrease = 0,
	}
	--camera:setRot(45, 0, 0)

	rngMap:init( )
	log:init( )
	item:init( )

	self._mapViewBool = false

	local mapSzX, mapSzY = rngMap:getSize( )
	self._cameraX = mapSzX/2*100
	self._cameraY = 7500
	self._cameraZ = mapSzY/2*100

	self._cameraPos = { }
	self._cameraPos[1] = { self._cameraX, self._cameraY, self._cameraZ, 0 }
	self._cameraPos[2] = { self._cameraX, self._cameraY, self._cameraZ, self._cameraRotY }

	self._cameraRotY = 0
	self._cameraRotX = -90
	self._cameraRotZ = 0

	self._cameraStepAngle = 90

	self._orientation = 1

	camera:setRot(0, self._cameraRotY, 0, 0.5)
	camera:setLoc(self._cameraX, self._cameraY, self._cameraZ, 0.5)

	self._step = 100

	self._deathTimer = 0
	self._deathCounter = 90990999000099999

	self._playerX = math.floor(self._cameraX/100)
	self._playerY = math.floor(self._cameraZ/100)

	
	camera:setRot(self._cameraRotX, self._cameraRotY, 0, 0.5)


	self._playerDirTable = { }
	self._playerDirTable[1] = {0, -1} -- UP, L, D, R
	self._playerDirTable[2] = {0, 1}
	self._playerDirTable[3] = {-1, 0}
	self._playerDirTable[4] = {1, 0}

	self._playerDirTableR = { }
	self._playerDirTableR[1] = {-1, 0} -- UP, L, D, R
	self._playerDirTableR[2] = {1, 0}
	self._playerDirTableR[3] = {0, 1}
	self._playerDirTableR[4] = {0, -1}

	self._playerDirTableD = { }
	self._playerDirTableD[1] = {0, 1} -- UP, L, D, R
	self._playerDirTableD[2] = {0, -1}
	self._playerDirTableD[3] = {1, 0}
	self._playerDirTableD[4] = {-1, 0}	

	self._playerDirTableL = { }
	self._playerDirTableL[1] = {1, 0} -- UP, L, D, R
	self._playerDirTableL[2] = {-1, 0}
	self._playerDirTableL[3] = {0, -1}
	self._playerDirTableL[4] = {0, 1}


	self._orientationTable = { } -- N, E, S, W
	self._orientationTable[1] = self._playerDirTable
	self._orientationTable[2] = self._playerDirTableR
	self._orientationTable[3] = self._playerDirTableD
	self._orientationTable[4] = self._playerDirTableL

	--[[self._playerWeapon_mesh = makeBox(100, 100, 0, "sword_player.png")
	self._playerWeapon = image:new3DImage(self._playerWeapon_mesh, self._playerX*100, 100, self._playerY*100, 6)
	image:disableDepthmask(self._playerWeapon)
	image:setPiv(self._playerWeapon, 0, 0, 50)--]]


end

function player:pickupItemsOnTheFloor( )
	for i = 1, #Game.classOptions[1] do
		local bool, _id = item:isItemAt(self._playerX, self._playerY)
		if bool == true then
			local _item = item:returnItem(_id)
			interface:addItemToInventory(_item)
			item:dropitem(_id)
		end	
	end	
end

function player:receiveDamage(_ammount, _isSpell)
	print("PHYSICAL ARMOR CHECKS: =================================")
	local armorDef = interface:_getDefenseRating( )
	print("ARMOR DEF: "..armorDef.."")
	print("ARMOR DEF: "..armorDef.."")
	print("ARMOR DEF: "..armorDef.."")
	print("ARMOR DEF: "..armorDef.."")
	print("ARMOR DEF: "..armorDef.."")
	print("ARMOR DEF: "..armorDef.."")
	if _isSpell == true then
		armorDef = interface:_getArcandeDefRating( )
		print("ARCANE ARMOR CHECKS: =================================")
		print("ARMOR DEF: "..armorDef.."")
		print("ARMOR DEF: "..armorDef.."")
		print("ARMOR DEF: "..armorDef.."")
		print("ARMOR DEF: "..armorDef.."")
		print("ARMOR DEF: "..armorDef.."")
		print("ARMOR DEF: "..armorDef.."")
	end
	print("ARMOPR CHECKS: =================================")

	local damageCalc = _ammount - armorDef
	if damageCalc < 0 then
		damageCalc = 0
	end
	self._playerStats.hp = math.floor(self._playerStats.hp - damageCalc)
	camera:setFieldOfView(FOVATTACK)
	player.AAT = Game.worldTimer
	player.aabool = true

	return damageCalc
end

function player:healPlayer( )
	self._playerStats.hp = self._playerStats.initial_health + self._playerStats.healthModifier
end

function player:updateHealthModifier(_amount)
	self._playerStats.healthModifier = _amount
end

function player:updateThrownModifier(_amount)
	self._playerStats.thrownModifier = _amount
end

function player:getThrowNmdofier( )
	return self._playerStats.thrownModifier
end

function player:addRandomWalls( )

end

function player:checkMovement(_orientation, key) 
	local map = rngMap:returnMap( )
	local bool = false


	if key == 119 or key == 115 or key == 97 or key == 100 then
		local movement = false
		local keyValue =  1
		if key == 119 then
			movement = true
			keyValue = 1
		elseif key == 115 then
			movement = true
			keyValue = 2
		elseif key == 97 then
			movement = true
			keyValue = 3 
		elseif key == 100 then
			movement = true
			keyValue = 4
		else 
			keyValue = 1
		end
		--print("ORIENTATION IS: ".._orientation.."")
		local cardinalTable = self._orientationTable[_orientation]
		local checkX = self._playerX + cardinalTable[keyValue][1]
		local checkY = self._playerY+cardinalTable[keyValue][2]
		local wallCheckResult = rngMap:isWallAt(checkX, checkY)
		local entityCheck, entityID = entity:isEntityAt(checkX, checkY)
		if wallCheckResult == false and entityCheck == false then
			bool = true			
		end

		if entityCheck == true and movement == true then
			player.aabool = true
			entity:_combatDebug(entityID)
			player.AAT = Game.worldTimer
			evTurn:handlePCTurn( )
			camera:setFieldOfView (FOVATTACK)
			self:_trainStats( )
			sound:play(Game.attack)

		end
		if bool == false then
			--log:newMessage("You bumped into something...")
		else
			--log:newMessage("You moved towards something...")
		end

		self._playerX = math.ceil(self._cameraX/100)
		self._playerY = math.ceil(self._cameraZ/100)
		

		
	end
	return bool
end

function player:_trainStats( )
	local rndChanceToTrain = math.random(1, 100)
	if rndChanceToTrain < 5 then
		self._playerStats.weaponAffinity = self._playerStats.weaponAffinity + (self._playerStats.weaponAffinity/10)
	end
end

function player:_trainSpell( )
	local rndChanceToTrain = math.random(1, 100)
	if rndChanceToTrain < 5 then
		self._playerStats.spellKnowdlege = self._playerStats.spellKnowdlege + (self._playerStats.spellKnowdlege/10)
	end
end

-- we assume that we move 100 units (size of a 3DTile)
function player:move(_orientation, key)
	
	if self:checkMovement(_orientation, key) == true then

		
		if self._orientation == 1 then -- forward
			if key == 119 then
				self._cameraZ = self._cameraZ - self._step
			elseif key == 115 then
				self._cameraZ = self._cameraZ + self._step
			elseif key == 97 then
				self._cameraX = self._cameraX - self._step
			elseif key == 100 then
				self._cameraX = self._cameraX + self._step
				--core:setSordMode(2, MOAILayer.SORT_Z_ASCENDING)
			end
		elseif self._orientation == 2 then -- right
			if key == 119 then
				self._cameraX = self._cameraX - self._step
			elseif key == 115 then
				self._cameraX = self._cameraX + self._step
			elseif key == 97 then
				self._cameraZ = self._cameraZ + self._step
			elseif key == 100 then
				self._cameraZ = self._cameraZ - self._step
			end
			--core:setSordMode(2, MOAILayer.SORT_X_ASCENDING)
		elseif self._orientation == 3 then -- backward
			if key == 119 then
				self._cameraZ = self._cameraZ + self._step
			elseif key == 115 then
				self._cameraZ = self._cameraZ - self._step
			elseif key == 97 then
				self._cameraX = self._cameraX + self._step
			elseif key == 100 then
				self._cameraX = self._cameraX - self._step
			end
			--core:setSordMode(2, MOAILayer.SORT_Z_DESCENDING)

		elseif self._orientation == 4 then
			if key == 119 then
				self._cameraX = self._cameraX + self._step
			elseif key == 115 then
				self._cameraX = self._cameraX - self._step
			elseif key == 97 then
				self._cameraZ = self._cameraZ - self._step
			elseif key == 100 then

				self._cameraZ = self._cameraZ + self._step
			end
			--core:setSordMode(2, MOAILayer.SORT_X_DESCENDING)
		end
		evTurn:handlePCTurn()




		self._goForEndMovement = true
		sound:play(Game.walk)
		
		self._endMovementCounter = Game.worldTimer

	end

	if key == 32 then
		evTurn:handlePCTurn()
		--rngMap:disableDarkness( )
		--evTurn:handlePCTurn()
		
		--self._cameraY = self._cameraY + self._step
	elseif key == 257 or key == 480 then
		--self._cameraY = self._cameraY - self._step
	elseif key == 61 then
		self._playerStats.speed = self._playerStats.speed + 50
	elseif key == 45 then
		self._playerStats.speed = self._playerStats.speed - 50
	end

	print("ORIENT: "..self._orientation.."")
	


	self:setSortModeBasedOn(self._orientation) -- sort based on orientation! HOMOFPB! 
	local weightFactor = interface:_getTotalInventoryWeight( )
	
	-- stop spiining the freaking camera when building the world
	if rngMap:returnGenStatus( ) == 1337 then
		camera:seekLoc(self._cameraX, self._cameraY, self._cameraZ, ( (self._playerStats.speed/100) ) )
	end

	

	
	
end

function player:setSortModeBasedOn(_orientation)
	local _or = _orientation
	if _or == 1 then
		core:setSordMode(2, MOAILayer.SORT_Z_ASCENDING)
	elseif _or == 2 then -- stanga
		core:setSordMode(2, MOAILayer.SORT_X_ASCENDING)
	elseif _or == 3 then -- spate
		core:setSordMode(2, MOAILayer.SORT_Z_DESCENDING)
	elseif _or == 4 then -- dreapta
		core:setSordMode(2, MOAILayer.SORT_X_DESCENDING)
	end
end

function player:_updateQuitState(_key)

end


function player:keypressed( key )
	if player.isDead == true and key ~= nil then
		if key ~= 108 then
			if Game.worldTimer > self._deathCounter + 2 then
				player:exportScore( )
				currentState = 18
				Game.dungeonType = 1
				--self._deathCounter = Game.worldTimer
			end
		end
	end

	if self._acceptInput == true then
		if player.isDead == false --[[and item:getThrowListSize( ) == 0--]] then
			self._playerX = math.floor(self._cameraX/100)
			self._playerY = math.floor(self._cameraZ/100)


			if key == 27 then
				--[[
	self._quitState = 1 -- aka question not asked
	self._quitTimer = Game.worldTimer
	self._quitWait = 3
	--121 - YES, 110 NO
				]]

				if self._quitState == 1 then
					log:newMessage("Are you sure you want to quit? Press <c:FFFF00>ESC</c> again to confirm")
					self._quitState = 2
				elseif self._quitState == 2 then
					currentState = 18
				elseif self._quitState == 3 then
					currentState = 18
				end
			else
				--if self._quitState ~= 1 then
					--interface:destroyLog( )
				--end
				--self._quitState = 1
			end

			if key == 113 then
				self._cameraRotY = self._cameraRotY + 90
				self._orientation = self._orientation + 1

			elseif key == 101 then
				self._cameraRotY = self._cameraRotY - 90
				self._orientation = self._orientation - 1
			end

			if key == 46 then
				--rngMap:destroyMap( )
				--if evTurn:_isPlayerOnStairs( ) == true then
					if rngMap:isTowerLevel( ) then
						Game.dungeoNLevel = Game.dungeoNLevel + 1
					end
					currentState = 16
				--end
			end


			if key == 46 then
				rngMap:save( )
			end



			if key == 109 then
				camera:setRot(-90, 0, 0)
				--camera:setLoc(self._cameraX, self._cameraY+400, self._cameraZ);
				rngMap:setRoofVisibility(self._mapViewBool)
				self._mapViewBool = not self._mapViewBool
				image:setVisible3D(self._playerSprite, self._mapViewBool)
			elseif key == 105 then
				interface:toggleInvetory( )
			end
			
			if self._orientation > 4 then
				self._orientation = 1
			end

			if self._orientation < 1 then
				self._orientation = 4
			end

			if key == 108 then
				interface:_showFullLog( )
			end

			if interface:getInventoryState( ) == false then

				if Game.worldTimer > self._playerStats.timer + (self._playerStats.speed/100) then
					self:move(self._orientation, key)
					self._playerStats.timer = Game.worldTimer
					if key == 112 then
						local bool, _id = item:isItemAt(self._playerX, self._playerY)
						local curItems, maxItems, totalWEight = interface:getInventoryCurrentLimit( )
						if curItems < maxItems then
							if bool == true then
								
								local _item = item:returnItem(_id)
								if totalWEight + _item.weight < interface:getMaxWeightToCarry( ) then
									interface:addItemToInventory(_item)

									item:dropitem(_id)
								else
									log:newMessage("You cannot carry so much weight!")
								end
								
							end
						else
							log:newMessage("Your inventory is full!")
						end
					elseif key == 111 then
						 environment:openDoor(self._playerX, self._playerY)
						 environment:accessPortal(self._playerX, self._playerY)
					end
				end
			else
				if key == 119 then
					interface:decPointer( )	
				elseif key == 115 then
					interface:incPointer( )
				elseif key == 97 then
					interface:movePointerTabLeft( )
				elseif key == 100 then
					interface:movePointerTabRight( )
				elseif key == 32 then
					local tab = interface:getPointerTab( )
					if tab == 1 then
						interface:addItemToEquipment(interface:getPointer( ))
					elseif tab == 2 then
						interface:addItemToInventory(interface:getPointer( ))
					end
				elseif key == 116 then
					local throwBool = interface:_throwItem(interface:getPointer( ), self._orientation)
					if throwBool == true then
						evTurn:handlePCTurn( )
					end
				elseif key == 112 then
					interface:dropItemToGround(interface:getPointer( ))


				end
				--interface:equipmentResetAllitems()
				interface:inventoryResetAllItems()
			end
			--self._cameraRotY
			if rngMap:returnGenStatus( ) == 1337 then	
				if self._mapViewBool == false then
					camera:seekRot(0, self._cameraRotY, 0, 0.15)
				end
			end
			self._playerX = math.floor(self._cameraX/100)
			self._playerY = math.floor(self._cameraZ/100)
		end
	else
			if key == 109 then
				camera:setRot(-90, 0, 0)
				rngMap:setRoofVisibility(self._mapViewBool)
				self._mapViewBool = not self._mapViewBool
				image:setVisible3D(self._playerSprite, self._mapViewBool)

				self:setCameraToFPS( )
			end		
	end
	self._acceptInput = not self._mapViewBool

end

function player:setCameraToFPS( )
	self._cameraRotX = 0
	--self._cameraRotY = 0
	self._cameraY = 100
	--self._orientation = 1
	camera:setRot(self._cameraRotX, self._cameraRotY, 0)
	camera:setLoc(self._cameraX, self._cameraY, self._cameraZ)
end

function player:makeAttackAnim( )
	--player.AAS

	if player.aabool == true then

		if Game.worldTimer > player.AAT + player.AAS then
			player.AAT = Game.worldTimer
			camera:setFieldOfView (FOVNORMAL)
		end
	end
	
end

function player:setLoc(_x, _y)
	self._playerX = _x
	self._playerY = _y
	self._cameraX = _x * 100
	self._cameraZ = _y * 100
	camera:setRot(self._cameraRotX, self._cameraRotY, 0)
	camera:setLoc(self._cameraX, self._cameraY, self._cameraZ)
end

function player:update( )
	

	if self._playerStats.hp <= 0 and player.isDead == false then
		print("YOU DIED!!!")
		log:newMessage("<c:FC0000>You were  REKT!</c>")
		self._deathCounter = Game.worldTimer
		interface:showGameOver( )
		player.isDead = true
		interface:resetTowerMenuFlag( )
	end


	if rngMap:returnGenStatus( ) == false then 
		rngMap:update( )
		self._showInventory = false
		self._acceptInput = false
	elseif rngMap:returnGenStatus( ) == true then

		local tx, ty = rngMap:returnEmptyLocations( ) 
		
		self._cameraX = tx * 100
		self._cameraY = ty * 100
		player:setLoc(tx, ty)


		rngMap:addCeilings( )
		self:setCameraToFPS( )

				--add item to the world
		if Game.dungeoNLevel == 1 and Game.iteration == 0 then
			Game.iteration = Game.iteration + 1
			for i, v in ipairs(Game.classOptions[1]) do
				local eqItem = v
				if type(v) == "table" then
					eqItem = v[1]
				else
					print("V IS ITEM: "..v.."")
				end
				item:new(self._playerX, self._playerY, eqItem)
				--[[local bool, _id = item:isItemAt(self._playerX, self._playerY)
				if bool == true then
					local _item = item:returnItem(_id)
					interface:addItemToInventory(_item)
					item:dropitem(_id)
				end			--]]
			end
			
			Game.turn = 0
			Game.score = 0
		else
			self:loadStats( )
		end


		self._acceptInput = false

		local nrEnemies = 11
		if Game.dungeoNLevel == 10 and Game.dungeonType == 1 then
			nrEnemies = 1
		elseif Game.dungeoNLevel == 2 and Game.dungeonType == 1 then
			nrEnemies = 1
		end
		for i = 1, nrEnemies do
			local x, y = rngMap:returnEmptyLocations( )
			entity:debugSpawner( x, y )
		end

		if rngMap:isTowerLevel( ) == false then
			for i = 1, 65 do
				local x, y = rngMap:returnEmptyLocations( )
				item:new(x, y)
			end	
		end
			
		rngMap:setGenStatus(1337)
		rngMap:makePathFinderTable( )
		--rngMap:placeStairs( )
		self:pickupItemsOnTheFloor( )
		self._showInventory = false
		self:setCameraToFPS( )
		sound:stopAll( )
		sound:play(Game.inGameSound)
	else
		
		rngMap:removeDarkness( )
		
		if self._mapViewBool == true then
			--[[
mapSzX/2*100
7500
mapSzY/2*100
			]]
			
			if rngMap:returnGenStatus( ) == 1337 then
				camera:setLoc(self._playerX*100, 3300, self._playerY*100)
				
			end
			if self._goForEndMovement == true then

				if Game.worldTimer > self._endMovementCounter + (self._playerStats.speed/100) then
					item:isItemAt(self._playerX, self._playerY)
					self._goForEndMovement = false
					--print("LOOPING: and time is: "..math.abs( (Game.worldTimer-(self._endMovementCounter+self._playerStats.speed/100 )) ) )
					evTurn:handlePCTurn()
				end


			end

		else
			--self._cameraRotX = 0
			--self._cameraRotY = 0
			--self._cameraY = 100
			--local weightFactor = interface:_getTotalInventoryWeight( )
			self._playerStats.speed = self._playerStats.baseSpeed --+ weightFactor
			if self._goForEndMovement == true then

				if Game.worldTimer > self._endMovementCounter + (self._playerStats.speed/100) then
					item:isItemAt(self._playerX, self._playerY)
					self._goForEndMovement = false
					--print("LOOPING: and time is: "..math.abs( (Game.worldTimer-(self._endMovementCounter+self._playerStats.speed/100 )) ) )
					--evTurn:handlePCTurn()
				end


			end
			self:makeAttackAnim( )
			--camera:setRot(self._cameraRotX, self._cameraRotY, 0)
			--camera:setLoc(self._cameraX, self._cameraY, self._cameraZ)
		end
		rngMap:updateMapGFX( )
		local rx, ry, rz = camera:getRot( )
		image:setRot3D(self._playerSprite, rx, ry, 0)
		image:setLoc(self._playerSprite, self._playerX*100, 100, self._playerY*100)

	end

	--print("Speed "..self._playerStats.speed.."")
end

function player:getOrientation( )
	return self._orientation
end

function player:returnPosition( )
	return math.floor(self._cameraX/100), math.floor(self._cameraZ/100)
end

function player:returnPlayerStats( )
	return self._playerStats
end

----------------------------------------
------- PLAYER COMBAT STUFF/CALC -------
----------------------------------------

function player:calcDamage(_type)
	-- type is 1 - WEAPONS, 2 - CASTING
	local damage = 0
	if _type == 1 then 

		local weaponDamage, weaponMulti = interface:returnEquipmentBonus( )
		local weaponAffinity = self._playerStats.weaponAffinity

		damage = weaponDamage * (weaponAffinity * weaponMulti)
	else
		damage = 2
	end

	return damage
end

function player:doDamage(_target)

end

function clone_table (t) -- deep-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = clone_table(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end
