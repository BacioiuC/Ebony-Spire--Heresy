require "keys"

player = { }
FOVNORMAL = 90
FOVATTACK = 70
player.AAS = 0.1--08
player.AAT = Game.worldTimer
player.aabool = false
player.isDead = false
player.isSleeping = false
player.isVictor = false



-- Player class holds data on "Attributes" and on Input methods
function player:saveStats( )
	--for i,v in ipairs(self._playerStats) do
		--table.insert(Game.playerStatsSave, v)
		--Game.playerStatsSave = clone_table(self._playerStats)

	--end
end

function player:loadStats( )
	--self._playerStats = { }
	--for i,v in ipairs(Game.playerStatsSave) do
		--table.insert(self._playerStats, v)
	--self._playerStats = clone_table(Game.playerStatsSave)
	--end
end


function player:exportScore(_scoreMultiplier, _optionalNil)
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
	interface:_exportScore(self._scoreTable, _optionalNil)
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

function player:updateGunModifier(_ammount)
	self._playerStats.gunModifier = _ammount
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
	core:returnLayer(8):setCamera( camera ) 
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
--	self._playerStats = { }
	if Game.classOptions ~= nil then
		if Game.classOptions[2] ~= nil then
			self._playerStats = {

				speed = 15, -- 15 energy
				baseSpeed = 15,
				weaponAffinity = Game.classOptions[2].weaponAffinity,
				spellAtunement = { },
				gunKnowledge = Game.classOptions[2].gunKnowledge,
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
				gunModifier = 0,
			}
		else
			local saveGameData = table.load("saves/current_run.lua")
			player:_setStats(saveGameData.playerData)
			self._playerStats.timer = Game.worldTimer

			self._playerStats.speed = 15
			self._playerStats.baseSpeed = 15
		end
	else

	end
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
	player.savingGrace = false
	self._luckySurvivalText = {}
	self._luckySurvivalText[1] = "<c:f1b82d>You barely survived the attack!</c>"
	self._luckySurvivalText[2] = "<c:f1b82d>Faith smiles upon you, for yet you endured one more hit!</c>"
	self._luckySurvivalText[3] = "<c:f1b82d>Wind blows in your direction!</c>"
	self._luckySurvivalText[4] = "<c:f1b82d>You feel as your were supposed to faint</c>"
	rngMap:loadLevel( )
end

function player:pickupItemsOnTheFloor( )
	--print("ITERATION: "..Game.iteration.."")
	if Game.classOptions ~= nil then
		if Game.classOptions[1] ~= nil and Game.iteration < 2 then
			for i = 1, #Game.classOptions[1] do
				local bool, _id = item:isItemAt(self._playerX, self._playerY)
				if bool == true then
					local _item = item:returnItem(_id)
					interface:addItemToInventory(_item)
					item:dropitem(_id)
				end	
			end	
		else
			if Game.dungeonType == 1 then
				Game:importSaveInfo( )
			end
		end
	else
		if Game.dungeonType == 1 then
			Game:importSaveInfo( )
		end
	end
end

function player:outputStats( )
--[[
		weaponAffinity = Game.classOptions[2].weaponAffinity,
		spellAtunement = { },
		spellKnowdlege = Game.classOptions[2].spellKnowdlege,
		initial_health = Game.classOptions[2].initial_health,
]]
	local statWeaponAffinity = "<c:346524>Weapon Affinity:</c> "..self._playerStats.weaponAffinity..""
	local statSpellKnowledge = "<c:346524>Spell Knowledge:</c> "..self._playerStats.spellKnowdlege..""
	local statGunKnowledge = "<c:346524>Gun Knowledge:</c>"..self._playerStats.gunKnowledge..""
	local armorValue = "<c:346524>Armor Value:</c>"..interface:_getDefenseRating( )..""
	local statInitialHealth = "<c:d04648>Max Health:</c> "..self._playerStats.initial_health..""
	local statHealthModifier = "<c:d04648>Health Modifier:</c> "..self._playerStats.healthModifier..""
	local gunModifier = "<c:d04648>Marksmanship Modifier:</c> "..self._playerStats.gunModifier..""
	
	log:newMessage("<c:6daa2c>@ Stats: =============================</c>")
	log:newMessage(statWeaponAffinity)
	log:newMessage(statSpellKnowledge)
	log:newMessage(statGunKnowledge)
	log:newMessage(armorValue)
	log:newMessage(statInitialHealth)
	log:newMessage(statHealthModifier)
	log:newMessage(gunModifier)
	log:newMessage("<c:6daa2c>@ Stats: =============================</c>")
	interface:updateLogDispaly()
	interface:_showFullLog( )

end

function player:receiveDamage(_ammount, _isSpell)
	local armorDef = interface:_getDefenseRating( )
	if _isSpell == true then
		armorDef = interface:_getArcandeDefRating( )
	end

	local damageCalc = _ammount - armorDef
	if damageCalc < 0 then
		damageCalc = 0
	end
	local newHP = math.floor(self._playerStats.hp - damageCalc)
	--player.savingGrace
	if newHP < 1 and player.savingGrace == false then
		player.savingGrace = true
		log:newMessage(self._luckySurvivalText[math.random(1, #self._luckySurvivalText)])
		newHP = 1
	end
	self._playerStats.hp = newHP
	camera:setFieldOfView(FOVATTACK)
	player.AAT = Game.worldTimer
	player.aabool = true

	return damageCalc
end

function player:healPlayer( )
	self._playerStats.hp = self._playerStats.initial_health + self._playerStats.spellKnowdlege * 4 --[[self._playerStats.healthModifier--]]
end

function player:heal(_points)
	self._playerStats.hp = self._playerStats.hp + _points
	if self._playerStats.hp > self._playerStats.initial_health + self._playerStats.healthModifier then
		self._playerStats.hp = self._playerStats.initial_health + self._playerStats.healthModifier
	end
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

function player:_setStats(_statTable)
	self._playerStats = _statTable
	self._playerStats.timer = Game.worldTimer
end

function player:checkMovement(_orientation, key) 
	local map = rngMap:returnMap( )
	local bool = false

	if key == ACTION_FORWARD or key == ACTION_DOWN_S or key == ACTION_MOVE_LEFT_A or key == ACTION_MOVE_LEFT or key == ACTION_MOVE_RIGHT_D or key == ACTION_MOVE_RIGHT or key == ACTION_FORWARD_UP or key == ACTION_DOWN then
		local movement = false
		local keyValue =  1
		if key == ACTION_FORWARD or key == ACTION_FORWARD_UP then
			movement = true
			keyValue = 1
		elseif key == ACTION_DOWN_S or key == ACTION_DOWN then
			movement = true
			keyValue = 2
		elseif key == ACTION_MOVE_LEFT_A or key == ACTION_MOVE_LEFT then
			movement = true
			keyValue = 3 
		elseif key == ACTION_MOVE_RIGHT_D or key == ACTION_MOVE_RIGHT then
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

function player:setPosition(_x, _y)
	self._playerX = _x
	self._playerY = _y
	if self._playerX ~= nil and self._playerY ~= nil then
		self._cameraX = self._playerX * 100
		self._cameraZ = self._playerY * 100
		camera:setLoc(self._playerX*100, 1200, self._playerY*100)
	end
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

function player:_trainGunStats( )
	local rndChanceToTrain = math.random(1, 100)
	if rndChanceToTrain < 5 then
		 self._playerStats.gunKnowledge =  self._playerStats.gunKnowledge + ( self._playerStats.gunKnowledge / 10)
	end
end

function player:_getSpellKnowledge( )
	return self._playerStats.spellKnowdlege
end

function player:_getGunKnowledge( )
	return self._playerStats.gunKnowledge + self._playerStats.gunModifier
end

-- we assume that we move 100 units (size of a 3DTile)
function player:move(_orientation, key)
	
	if self:checkMovement(_orientation, key) == true then

		
		if self._orientation == 1 then -- forward
			if key == ACTION_FORWARD or key == ACTION_FORWARD_UP then
				self._cameraZ = self._cameraZ - self._step
			elseif key == ACTION_DOWN_S or key == ACTION_DOWN then
				self._cameraZ = self._cameraZ + self._step
			elseif key == ACTION_MOVE_LEFT_A or key == ACTION_MOVE_LEFT then
				self._cameraX = self._cameraX - self._step
			elseif key == ACTION_MOVE_RIGHT_D or key == ACTION_MOVE_RIGHT then
				self._cameraX = self._cameraX + self._step
				--core:setSordMode(2, MOAILayer.SORT_Z_ASCENDING)
			end
		elseif self._orientation == 2 then -- right
			if key == ACTION_FORWARD or key == ACTION_FORWARD_UP then
				self._cameraX = self._cameraX - self._step
			elseif key == ACTION_DOWN_S or key == ACTION_DOWN then
				self._cameraX = self._cameraX + self._step
			elseif key == ACTION_MOVE_LEFT_A or key == ACTION_MOVE_LEFT then
				self._cameraZ = self._cameraZ + self._step
			elseif key == ACTION_MOVE_RIGHT_D or key == ACTION_MOVE_RIGHT then
				self._cameraZ = self._cameraZ - self._step
			end
			--core:setSordMode(2, MOAILayer.SORT_X_ASCENDING)
		elseif self._orientation == 3 then -- backward
			if key == ACTION_FORWARD or key == ACTION_FORWARD_UP then
				self._cameraZ = self._cameraZ + self._step
			elseif key == ACTION_DOWN_S or key == ACTION_DOWN then
				self._cameraZ = self._cameraZ - self._step
			elseif key == ACTION_MOVE_LEFT_A or key == ACTION_MOVE_LEFT then
				self._cameraX = self._cameraX + self._step
			elseif key == ACTION_MOVE_RIGHT_D or key == ACTION_MOVE_RIGHT then
				self._cameraX = self._cameraX - self._step
			end
			--core:setSordMode(2, MOAILayer.SORT_Z_DESCENDING)

		elseif self._orientation == 4 then
			if key == ACTION_FORWARD or key == ACTION_FORWARD_UP then
				self._cameraX = self._cameraX + self._step
			elseif key == ACTION_DOWN_S or key == ACTION_DOWN then
				self._cameraX = self._cameraX - self._step
			elseif key == ACTION_MOVE_LEFT_A or key == ACTION_MOVE_LEFT then
				self._cameraZ = self._cameraZ - self._step
			elseif key == ACTION_MOVE_RIGHT_D or key == ACTION_MOVE_RIGHT then

				self._cameraZ = self._cameraZ + self._step
			end
			--core:setSordMode(2, MOAILayer.SORT_X_DESCENDING)
		end
		evTurn:handlePCTurn()




		self._goForEndMovement = true
		sound:play(Game.walk)
		
		self._endMovementCounter = Game.worldTimer

	end

	if key == ACTION_USE then
		evTurn:handlePCTurn()
	end

	--print("ORIENT: "..self._orientation.."")
	


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

function player:_getOrientation( )
	return self._orientation
end

function player:keypressed( key )
	--print("KEY: "..key.."")
	if player.isDead == true and key ~= nil then
		if key ~= KEY_L then
			if Game.worldTimer > self._deathCounter + 4 then
				player:exportScore( )
				currentState = 18
				Game.dungeonType = 1
				--self._deathCounter = Game.worldTimer
			end
		end
	end
	if item:getThrowProcessing( ) == false then
		if self._acceptInput == true then
			
			if player.isDead == false --[[and item:getThrowListSize( ) == 0--]] then
				self._playerX = math.floor(self._cameraX/100)
				self._playerY = math.floor(self._cameraZ/100)
				
				if key == KEY_ESC then
					--print("Escape Pressed")
					if interface:_getLogOrInventoryStatus( ) == false then
						if self._quitState == 1 then
							log:newMessage("Are you sure you want to quit? Press <c:FFFF00>ESC</c> again to confirm")
							self._quitState = 2
						elseif self._quitState == 2 and interface:_getLogOpenedStatus( ) == false then
							currentState = 18
						elseif self._quitState == 3 then
							currentState = 18
						end						
					else
						self._quitState = 1
						interface:_closeLog( )
						interface:_closeInventory( )

					end
				end
				--[[if key == KEY_ESC and interface:_getLogOpenedStatus( ) == false then
					print("ESC PRESSED AND INTERFACE OFF")

					if self._quitState == 1 then
						log:newMessage("Are you sure you want to quit? Press <c:FFFF00>ESC</c> again to confirm")
						self._quitState = 2
					elseif self._quitState == 2 and interface:_getLogOpenedStatus( ) == false then
						currentState = 18
					elseif self._quitState == 3 then
						currentState = 18
					end
									
				else
					print("ESC PRESSED AND INTERFACE ON")
					self._quitState = 1
					log:newMessage("Quit aborted")
					interface:_closeLog( )
					--end
				end--]]

				if key == ACTION_TURN_LEFT_Q or key == ACTION_TURN_LEFT  then
					self._cameraRotY = self._cameraRotY + 90
					self._orientation = self._orientation + 1

				elseif key == ACTION_TURN_RIGHT_E or key == ACTION_TURN_RIGHT then
					self._cameraRotY = self._cameraRotY - 90
					self._orientation = self._orientation - 1
				end

				if key == ACTION_CLIMB_STAIRS then
					--rngMap:destroyMap( )
					if evTurn:_isPlayerOnStairs( ) == true then
						if rngMap:isTowerLevel( ) then
							Game:exportSaveInfo( )
							Game.classOptions = nil
							Game.dungeonType = 1
							player:addToScore(Game.dungeoNLevel * 50)
							Game.dungeoNLevel = Game.dungeoNLevel + 1
							Game.levelSeed = nil
							
						end
						currentState = 16
					end
				end

				if key == ACTION_HELP then
					interface:pushKeyInfo( )
				end



				if key == ACTION_VIEW_MAP then
					camera:setRot(-90, 0, 0)
					--camera:setLoc(self._cameraX, self._cameraY-100, self._cameraZ);
					rngMap:setRoofVisibility(self._mapViewBool)
					self._mapViewBool = not self._mapViewBool
					
					image:setVisible3D(self._playerSprite, self._mapViewBool)
				elseif key == ACTION_INVENTORY then
					interface:toggleInvetory( )
				end
				
				if self._orientation > 4 then
					self._orientation = 1
				end

				if self._orientation < 1 then
					self._orientation = 4
				end

				if key == ACTION_LOG then
					interface:updateLogDispaly()
					interface:_showFullLog( )
				end

				if key == KEY_ESC then
					interface:_closeLog( )
				end

				if interface:getInventoryState( ) == false then
					--print("AQUI BOSS")
					--print("GWT: "..Game.worldTimer.." | PStats Timer: "..self._playerStats.timer.."")
					if Game.worldTimer > self._playerStats.timer + (self._playerStats.speed/100) then
						--print("HOLAAA")
						self:move(self._orientation, key)
						self._playerStats.timer = Game.worldTimer
						if key == ACTION_DROP then
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
						elseif key == ACTION_OPEN then
							environment:openDoor(self._playerX, self._playerY)
							environment:accessPortal(self._playerX, self._playerY)
						elseif key == ACTION_VIEW then
							entity:playerLookAtInventory( )
						elseif key == ACTION_PAGE_UP then -- page up
							interface:_increaseLogPointer( )
						elseif key == ACTION_PAGE_DOWN then -- page down
							interface:_decreaseLogPointer( )
						elseif key == ACTION_FAVORITE then -- F_KEY
							interface:triggerFavoriteItem( )
							--evTurn:handlePCTurn()
						elseif key == ACTION_VIEW_STATS then
							self:outputStats( )
						end
					end
				else
					if key == ACTION_FORWARD or key == ACTION_FORWARD_UP then
						interface:decPointer( )	
					elseif key == ACTION_DOWN_S or key == ACTION_DOWN then
						interface:incPointer( )
					elseif key == ACTION_MOVE_LEFT_A or key == ACTION_MOVE_LEFT then
						interface:movePointerTabLeft( )
					elseif key == ACTION_MOVE_RIGHT_D or key == ACTION_MOVE_RIGHT then
						interface:movePointerTabRight( )
					elseif key == ACTION_USE or key == ACTION_ENTER then
						local tab = interface:getPointerTab( )
						if tab == 1 then
							interface:addItemToEquipment(interface:getPointer( ))
						elseif tab == 2 then
							interface:addItemToInventory(interface:getPointer( ))
						end
					elseif key == ACTION_THROW then
						local throwBool = interface:_throwItem(interface:getPointer( ), self._orientation)
						if throwBool == true then
							evTurn:handlePCTurn( )
						end
					elseif key == ACTION_PICK_UP then
						interface:dropItemToGround(interface:getPointer( ))
					elseif key == ACTION_FAVORITE then -- F_KEY
						interface:addCurrentItemToFavorite(interface:getPointer( ))
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
				if key == ACTION_VIEW_MAP then
					camera:setRot(-90, 0, 0)
					rngMap:setRoofVisibility(self._mapViewBool)
					self._mapViewBool = not self._mapViewBool
					image:setVisible3D(self._playerSprite, self._mapViewBool)

					self:setCameraToFPS( )
				end		
		end
		self._acceptInput = not self._mapViewBool
	end

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
		--print("YOU DIED!!!")
		log:newMessage(" <c:FC0000>You died</c>")
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
		if Game.iteration ~= 0 then
			--interface:loadInventory( )
		end
		if Game.dungeoNLevel == 1 and Game.iteration == 0 then
			Game.iteration = Game.iteration + 1
			if Game.classOptions[1] ~= nil then
				for i, v in ipairs(Game.classOptions[1]) do
					local eqItem = v
					if type(v) == "table" then
						eqItem = v[1]
					else
						--print("V IS ITEM: "..v.."")
					end
					item:new(self._playerX, self._playerY, eqItem)
				end
			else
				--print("CLASS OPTION ZERO OMG OMG OMG OMG OMG")
			end
			
			Game.turn = 0
			Game.score = 0
		else
			--self:loadStats( )
			--Game:importSaveInfo( )
			 self._playerStats.timer = Game.worldTimer
		end


		self._acceptInput = false

		local nrEnemies = math.random(9,15)
		if Game.dungeoNLevel == 10 and Game.dungeonType == 1 then
			nrEnemies = 1
		end

		if Game.dungeonType == rngMap:returnDungeonTower( ) then
			nrEnemies = rngMap:getEnemyLevelRatio( )[Game.dungeoNLevel]
		end


		local clearFlagCheck = false
		if Game.dungeonType == 1 or Game.dungeonType == rngMap:returnTowerLevelType( ) then
			clearFlagCheck = true
		end
		--if Game._LevelsClearFlags[Game.dungeoNLevel] == false  then
		local boolInfiniteMode = false
		if Game.optionSettings.infinite_mode == 1 then
			boolInfiniteMode = false
		end
		if clearFlagCheck == true then

			if Game._LevelsClearFlags[Game.dungeoNLevel] == false then
				for i = 1, nrEnemies do

					local x, y = rngMap:returnEmptyLocations(boolInfiniteMode)
					entity:debugSpawner( x, y )
				end
		
				entity:_spawnSpecificCreatures( )
			end
		else
			for i = 1, nrEnemies do
				local x, y = rngMap:returnEmptyLocations(boolInfiniteMode)
				entity:debugSpawner( x, y )
			end
	
			entity:_spawnSpecificCreatures( )
		end

		--end
		if Game.dungeonType ~= rngMap:returnDungeonTower() then
			for i = 1, 265 do
				local x, y = rngMap:returnEmptyLocations( )
				--print("X: "..x.." Y: "..y.."")
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
		

		self._playerX, self._playerY = rngMap:getSpawnPointLoc( )

		
		self._cameraX = self._playerX*100
		self._cameraZ = self._playerY*100
		camera:setLoc(self._playerX*100, 100, self._playerY*100)
		evTurn:updateLights( )

		if Game.dungeoNLevel == 11 then
			interface:showVictory( )
		end
		if Game.dungeonType == 1 then
			Game:exportSaveInfo( )
		end
	else
		--print("BUT ARE WE HERE")

		rngMap:removeDarkness( )
		
		if self._mapViewBool == true then
			--[[
mapSzX/2*100
7500
mapSzY/2*100
			]]
			
			if rngMap:returnGenStatus( ) == 1337 then
				camera:setLoc(self._playerX*100, 1200, self._playerY*100)
				--camera:setRot(0, self._cameraRotY, 0 )
			end
			if self._goForEndMovement == true then

				if Game.worldTimer > self._endMovementCounter + (self._playerStats.speed/100) then
					item:isItemAt(self._playerX, self._playerY)
					self._goForEndMovement = false
					--print("LOOPING: and time is: "..math.abs( (Game.worldTimer-(self._endMovementCounter+self._playerStats.speed/100 )) ) )
					evTurn:handlePCTurn()
				end

				
			else
				
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
