item = { }

function item:init( )
	self._itemTable = {}
	--self._book = makeBox(100, 100, 0, "book_sprite.png")
	self._effectTable = { }
	self._itemDataTabel = { }
	self._throwList = { }
	self._itemDataTabel = loadCSVData("data/items.csv")
	self._spawnableItems = { }
	for i,v in pairs(self._itemDataTabel) do
		v.mesh = makeBox(100, 100, 0, ""..v.gfx.."")
		--if v.canSpawn == "yes" then
			table.insert(self._spawnableItems, v)
		--end
		print("V: "..i.."")
		print("V NAME: "..v.description.."")
	end

	self._itemFakeLabel = { }
	self._itemFakeLabel[1] = "<c:F00>Heap of 30 torches (u) - A</>"
	self._itemFakeLabel[2] = "<c:00FF00>Box with Flint and Steel (u) - 1</>"
	self._itemFakeLabel[3] = "Cheap Gloves (e) - <E>"
	self._itemFakeLabel[4] = "Potion of Water (u)"
	self._itemFakeLabel[5] = "Scroll of Darkness (u)"
	self._itemFakeLabel[6] = "Scroll of Item Detect (u)"
	self._itemFakeLabel[7] = "Spellbook of Frost (u)"
	self._itemFakeLabel[8] = "Spellbook of Fire Blast (u)"
	self._itemFakeLabel[9] = "Helmet of the Dovakin (u)"
	self._itemFakeLabel[10] = "Cursed Amulet Ring (u)" 

	self._itemColorTable = { }--will hold the colors

	self._moveDir = { }
	self._moveDir[1] = {0, -1} -- UP, L, D, R
	self._moveDir[2] = {-1, 0}
	self._moveDir[3] = {0, 1}
	self._moveDir[4] = {1, 0}

	self._randomDamageMin = 4
	self._randomDamageMax = 45
	---- later, add a multiplier based on your level/enemy average level :)

	self._firePotionDamage = 15

	self._magicMissileItem = 16

end

function item:throw(_gfxID, _orientation, __x, __y, _goForPlayer)
	sound:play(Game.dropItem)
	local distance = 5
	local throwSpeed = 0.5
	local throwTimer = Game.worldTimer
	local rndItem = _gfxID
	local _x, _y 
	local thrownByPlayer = false
	if _goForPlayer == nil then
		if __x == nil and __y == nil then
			_x, _y = player:returnPosition( )
			thrownByPlayer = true
		else
			_x = __x
			_y = __y
			thrownByPlayer = false
		end
	else 
		thrownByPlayer = _goForPlayer
		_x = __x
		_y = __y
	end
	print("GFXID IS: ".._gfxID.."")
	local temp = {
		id = #self._throwList + 1,
		distance = 5,
		speed = 0.04,
		throwTimer = Game.worldTimer,
		gfx = image:new3DImage(self._itemDataTabel[rndItem].mesh, _x*100, 100, _y*100, 2 ),
		x = _x,
		y = _y,
		gfxID = rndItem,
		orient = _orientation,
		weight = self._itemDataTabel[rndItem].weight,
		weapon_dmg = self._itemDataTabel[rndItem].wmd,
		isPlayerThrown = thrownByPlayer,
		effect = self._itemDataTabel[rndItem].effect,
		cur = 1,
		_type = self._itemDataTabel[rndItem]._type,
		name = self._itemDataTabel[rndItem].name,
		hitSomething = false,
		spell_dmg = self._itemDataTabel[rndItem].sdmg,
		spell_atun = self._itemDataTabel[rndItem].sa,
	}
	print("WEEE AND THRWWW")
	table.insert(self._throwList, temp)
end

function item:getThrowListSize( )
	return #self._throwList
end

function item:updateThrow()
	local rx, ry, rz = camera:getRot( )
	for i,v in ipairs(self._throwList) do
		print("VX: "..v.x.." VY: "..v.y.."")
		if Game.worldTimer > v.throwTimer + v.speed then
			local checkX = v.x + self._moveDir[v.orient][1]
			local checkY = v.y + self._moveDir[v.orient][2]
			local wallCheckResult = rngMap:isWallAt(checkX, checkY)
			local entityCheck, entityID = entity:isEntityAt(checkX, checkY)
			local _x, _y = player:returnPosition( )
			if v.isPlayerThrown == true then
				if wallCheckResult == false and entityCheck == false then
					v.x = v.x + self._moveDir[v.orient][1]
					v.y = v.y + self._moveDir[v.orient][2]
					v.throwTimer = Game.worldTimer
					image:setLoc(v.gfx, v.x*100, 100, v.y*100)

					image:setRot3D(v.gfx, 0, ry, 0)
					v.distance = v.distance - 1
				else
					v.hitSomething = true
					local _entName = entity:getName(entityID)

					if _entName ~= nil then
						log:newMessage("You hit <c:27F>".._entName.."</c> for "..v.weight.."damage")
						entity:_doDamage(entityID, v.weight + v.weapon_dmg)
					end

					--[[if v._type == "Potion" then
						local _v = entity:getList()[entityID]
						if _v ~= nil then
							self:doItemEffect(v, _v.x, _v.y)
						elseif wallCheckResult == true then
							self:doItemEffect(v, v.x, v.y)
						end
					elseif v._type == "Spell" then

						
						local _v = entity:getList()[entityID]
						if _v ~= nil then
							self:doItemEffect(v, _v.x, _v.y)
						elseif wallCheckResult == true then
							self:doItemEffect(v, v.x, v.y)
						end					
					end--]]

					if v.effect ~= "nil" then
						local _v = entity:getList()[entityID]
						if _v ~= nil then
							self:doItemEffect(v, _v.x, _v.y)
						elseif wallCheckResult == true then
							self:doItemEffect(v, v.x, v.y)
						end	
					end
					v.distance = 0
				end
			else
				-- check to see if it didn't hit the wall, or the player
				if (v.x ~= _x or v.y ~= _y) and wallCheckResult == false then
					--[[v.x = v.x + self._moveDir[v.orient][1]
					v.y = v.y + self._moveDir[v.orient][2]--]]
					-- Here's where it gets tricky. Technically,
					-- I don't have time to get a propper Fov and LoS 
					-- algorithm in place. So what I'mma gonna do is
					-- when the entity tries to throw an item at you,
					-- it will try and get a path to you.
					-- The thrown item will travel down that path.
					-- In case a path isn't obtainable, the entity
					-- will just throw straight :)
					local path = pather:getPath(v.x, v.y, _x, _y)
					if path ~= nil then
						local nodeList = { }
						local nidx = 0
						for node, count in path:nodes( ) do
							nidx = nidx + 1
							nodeList[nidx] = { }
							nodeList[nidx]._x = node:getX( )
							nodeList[nidx]._y = node:getY( )
						end

						if nodeList ~= nil then
							if nodeList[v.cur+1] ~= nil then
								v.x = nodeList[v.cur+1]._x
								v.y = nodeList[v.cur+1]._y
								v.cur = v.cur + 1
							end
						else
							v.x = v.x + self._moveDir[v.orient][1]
							v.y = v.y + self._moveDir[v.orient][2]
						end
					else
						v.x = v.x + self._moveDir[v.orient][1]
						v.y = v.y + self._moveDir[v.orient][2]
					end
					v.throwTimer = Game.worldTimer
					image:setLoc(v.gfx, v.x*100, 100, v.y*100)

					image:setRot3D(v.gfx, 0, ry, 0)
					v.distance = v.distance - 1
				else
					v.hitSomething = true
					local px, py = player:returnPosition( )
					if entityCheck == true then -- did it hit another entity
						local _entName = entity:getName(entityID)
						log:newMessage("It hit entity <c:27F>".._entName.."</c> for "..v.weight.."damage")
						entity:_doDamage(entityID, v.weight + v.weapon_dmg)
						--[[if v._type == "Potion" then
							local _v = entity:getList()[entityID]
							self:doItemEffect(v, v.x, v.y)
						end--]]
						if v.effect ~= "nil" then
							local _v = entity:getList()[entityID]
							self:doItemEffect(v, v.x, v.y)						
						end
					elseif v.x == px and v.y == py then -- it hit the player
						--[[if v._type == "Potion" then
							self:doItemEffect(v, v.x, v.y)
						end--]]
						if v.effect ~= "nil" then
							self:doItemEffect(v, v.x, v.y)						
						end						
						log:newMessage("You were hit for "..v.weight.."damage")
						player:receiveDamage(v.weight)
						print("GOOOOOOOOOOOOOOOOOOOOAD DAMN IT")					
					end					
					--entity:_doDamage(entityID, v.weight + v.weapon_dmg)
					v.distance = 0
				end

			end
		end

		if v.distance <= 0 then
			self:destroyThrownitem(i)
		end
	end
end

function item:_debugMakeTableOfSpawnableItems( )

end

---- MinlevelToSpawn MIGHT BE FUCKING BROKEN! 
function item:new(_x, _y, _item)
	local itemNr = #self._itemDataTabel
	local rndItem = math.random(1,itemNr)
	local tableToSpawnFrom = self._itemDataTabel
	local string = "yes"
	local tempLevToSpawnFrom = nil

	if _item ~= nil then
		 rndItem = _item
		 string = "no"
		 tempLevToSpawnFrom = 0
	else
		tableToSpawnFrom = self._spawnableItems
		rndItem = math.random(1,#tableToSpawnFrom)
	end

	local itemTableSize = #self._itemTable
	local minLevelsToSpawn = tableToSpawnFrom[rndItem].AllowedFrom
	if tempLevToSpawnFrom ~= nil then
		minLevelsToSpawn = tempLevToSpawnFrom
	end
	if Game.dungeoNLevel >= minLevelsToSpawn then
		if tableToSpawnFrom[rndItem].canSpawn == "yes" or tableToSpawnFrom[rndItem].canSpawn == ""..string.."" then
			local rnd = math.random(1, 100)
			if _item ~= nil then
				rnd = tableToSpawnFrom[rndItem].spawnChance
			end
			if rnd <= tableToSpawnFrom[rndItem].spawnChance + itemTableSize  then
				local temp = {
					id = #self._itemTable + 1,
					x = _x,
					y = _y,
					gfx = image:new3DImage(tableToSpawnFrom[rndItem].mesh, _x*100, 100, _y*100, 2 ), 
					name = "<c:"..tableToSpawnFrom[rndItem].color..">"..tableToSpawnFrom[rndItem].name.."</c>",
					weight = tableToSpawnFrom[rndItem].weight,
					weapon_dmg = tableToSpawnFrom[rndItem].wmd,
					weapon_multi = tableToSpawnFrom[rndItem].wmulti,
					spell_dmg = tableToSpawnFrom[rndItem].sdmg,
					spell_atune = tableToSpawnFrom[rndItem].sa,
					armor_def = tableToSpawnFrom[rndItem].adef,
					armor_arcane_def = tableToSpawnFrom[rndItem].aarcdef,
					_type = tableToSpawnFrom[rndItem]._type,
					gfxID = rndItem,
					value = tableToSpawnFrom[rndItem].value,
					effect = tableToSpawnFrom[rndItem].effect,
					color = tableToSpawnFrom[rndItem].color,
					description = tableToSpawnFrom[rndItem].description,
					spawnChance = tableToSpawnFrom[rndItem].spawnChance,
					modifierType = tableToSpawnFrom[rndItem].modifierType,
					modifier = tableToSpawnFrom[rndItem].modifier,
				}

				if temp._type == "Armor" then
					temp.armor_def = temp.armor_def + math.floor( math.random(temp.armor_def/2, temp.armor_def/2+temp.armor_def/2) )
					temp.armor_arcane_def = temp.armor_arcane_def + math.floor( math.random( temp.armor_arcane_def/2,  temp.armor_arcane_def/2 + temp.armor_arcane_def/2) )
				elseif temp._type == "Weapon" then
					temp.weapon_dmg =  temp.weapon_dmg + math.floor( math.random(temp.weapon_dmg/2, temp.weapon_dmg/2+temp.weapon_dmg/2) )
					temp.weapon_multi = temp.weapon_multi + math.floor( math.random(temp.weapon_multi/2, temp.weapon_multi/2+temp.weapon_multi/2) )
				end
				table.insert(self._itemTable, temp )
			end
		else
			self:new(_x, _y, _item)
		end
	end
end

function item:update( )
	local rx, ry, rz = camera:getRot( )
	for i,v in ipairs(self._itemTable) do
		
		--print("I IS: "..i.."")
		image:setRot3D(v.gfx, rx, ry, 0)
	end

	self:updateEffects( )

	self:updateThrow()
end

function item:isItemAt(_x, _y)
	local bool = false
	local id = nil
	for i,v in ipairs(self._itemTable) do
		if v.x == _x and v.y == _y then
			bool = true
			id = i
			--log:newMessage("There is an item here: "..v.name.."")
			
		end
	end

	return bool, id
end

function item:dropitem(_i, _forceDelete)
	local _item = self._itemTable[_i]
	image:removeProp(_item.gfx, 2)
	_item.gfx = nil
	if _forceDelete ~= true then
		table.remove(self._itemTable, _i)
	end
end

function item:removeAll( )
	for i,v in ipairs(self._itemTable) do
		self:dropitem(i, true)
	end

	for i = 1, #self._itemTable do
		table.remove(self._itemTable, i)
	end
end

function item:destroyThrownitem(_i)
	local _item = self._throwList[_i]

	image:removeProp(_item.gfx, 2)
	_item.gfx = nil
	if _item._type ~= "Potion" and _item._type ~= "Spell" then
		self:new(_item.x, _item.y, _item.gfxID )
	elseif _item._type ~= "Spell" then
		if _item.hitSomething == false then
			self:new(_item.x, _item.y, _item.gfxID )
		end
	end
	table.remove(self._throwList, _i)
end

function item:returnItem(_id)
	local _item = self._itemTable[_id]
	return _item
end


-----------------------------------------------------------
----------------------- EFFECTS ---------------------------
-----------------------------------------------------------
function item:doItemEffect(_v, _px, _py, _toPlayer)
	local v = _v

	local px = v.x
	local py = v.y

	if _px ~= nil and _py ~= nil then
		px = _px
		py = _py
	end

	if v.isPlayerThrown == true then

	end

	if v.effect == "heal" then
		self:createItemEffect_HEAL(px, py)
	elseif v.effect == "heal_single" then
		self:createItemEffect_HEALSINGLE(px, py)
		-- apply health here
	elseif v.effect == "burn" then
		self:createItemEffect_FIRE(px, py, v.spell_dmg)
	elseif v.effect == "teleport" then
		self:createItemEffect_TELEPORT(px, py)
	elseif v.effect == "summon" then
		self:createItemEffect_SUMMON(px, py)
	elseif v.effect == "darkness" then
		self:createItemEffect_SpawnDarkness(px, py)
	elseif v.effect == "reveal_map" then
		self:createItemEffect_REVEAL(px, py)
	elseif v.effect == "damage_all" then
		--print("DMG SHOULD BE: "..v.spell_dmg.."")
		if _toPlayer == false then
			self:createItemEffect_DamagePlayer(px, py, v.spell_dmg)
		else
			self:createItemEffect_DamageAll(px, py, v.spell_dmg)
		end
	elseif v.effect == "magic_missile" then
		self:createItemEffect_MagicMissile(px, py, _toPlayer)
	elseif v.effect == "magic_missile_proj" then
		self:createItemEffect_MagicMissileImpact(px, py, _ammount)
	elseif v.effect == "polymorph" then
		self:createItemEffect_POLYMORPH(px, py)
	elseif v.effect == "summon_epic" then
		self:createItemEffect_SUMMONEPIC(px, py)
	elseif v.effect == "WinCondition" then
		self:doWinCondition(_v, px, py, _toPlayer)
	end
end

function item:doWinCondition(_v, _x, _y, _toPlayer)
	local v = _v
	player:setKilledBy("<c:9FC43A>lovely mass of love and friendship</c>")
--[[	for i = 1, 6 do
		rngMap:destroyMap( )
		item:removeAll( )
		entity:removeAll( )
		interface:destroyUI ( )
		item:removeAll( )
	end
	--player:saveStats( )
	
	_bGameLoaded = false
	_bGuiLoaded = false


	currentState = 22--
	Game.dungeoNLevel = 1--]]
	if _toPlayer ~= false then
		currentState = 23
	end

	--[[

	--]]
end



function item:createItemEffect_POLYMORPH(_x, _y)
	local _mesh = makeBox(40, 40, 0, "assets/effects/poly1.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/polymorph_2.png")
	local portalCounter = 0
	for i = 1, 64 do
		local tmesh = _mesh
		local rndCheck = math.random(1,2)
		if i ~= 1  then
			tmesh = _mesh2
		end
		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(tmesh, 10, 10-i*20,  10, 2 ), 
			x = (_x),
			y = (_y),
			ix = math.random(-40, 40),
			iy = math.random(-40, 40),
			z = 100-i*20,
			life = 100,
			speed = 8,
			_effectType = 2,
		}

		if i == 1 then
			temp.ix = 0
			temp.iy = 0
			temp.z = 100
			temp.life = 100
			temp.mainElement = true
		end
		portalCounter = portalCounter + 1
		table.insert(self._effectTable, temp)
	end	

	local px, py = player:returnPosition( )
	if (px == _x and py == _y) then -- yep, player
		--player:healPlayer( )
		log:newMessage("<c:26EB5D>You feel a change inside you!!</c>")
	else -- check for enemies
		rngMap:isDarknessAt(_x, _y, true)
		local bool, id = entity:isEntityAt(_x, _y)
		if bool == true then -- yep, entity is there
			--print("BOOL IS TRUE")
			local v = entity:getList( )[id]
			if v ~= nil then
				--v.hp = v.initial_health
				--log:newMessage(""..v.name.." <c:26EB5D> has recovered his health</c>")
				local oldName = v.name
				v.hp = 0
				local rnd = math.random(1, #entity:makeSpawnListForLevel( ))
				local newName = entity:new(_x, _y, rnd)
				log:newMessage(""..oldName.." was turned into "..newName.."")
			end
		end
	end	


end

function item:createItemEffect_MagicMissileImpact(_x, _y)
	local _mesh = makeBox(40, 40, 0, "assets/effects/mm_ef_casted.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/mm_ef_casted.png")
	local tmesh = _mesh
	local rndCheck = math.random(1,2)
	if rndCheck == 1 then
		tmesh = _mesh2
	end
	local temp = {
		id = #self._effectTable + 1,
		gfx = image:new3DImage(tmesh, 10, 10-1*20,  10, 2 ), 
		x = (_x),
		y = (_y),
		ix = math.random(-40, 40),
		iy = math.random(-40, 40),
		z = 100-1*20,
		life = 100,
		speed = 8,
		_effectType = 1,
	}

	table.insert(self._effectTable, temp)	


end


function item:createItemEffect_MagicMissile(_x, _y, _toPlayer)
	-- add some magic missile items to the player's inventory
	local _positionTable = { }

	if player:getOrientation() == 1 or player:getOrientation() == 3 then
		_positionTable[1] = {x = -1, y = 0}
		_positionTable[2] = {x = 0, y = 0}
		_positionTable[3] = {x = 1, y = 0}
	else
		_positionTable[1] = {x = 0, y = -1}
		_positionTable[2] = {x = 0, y = 0}
		_positionTable[3] = {x = 0, y = 1}
	end

	if _toPlayer == nil then
		_toPlayer = true
	end

	for i = 1, 3 do
		item:throw(self._magicMissileItem, player:getOrientation(), _x+_positionTable[i].x, _y+_positionTable[i].y, _toPlayer)
	end

end

function item:createItemEffect_HEALSINGLE(_x, _y)
	local _mesh = makeBox(20, 20, 0, "assets/effects/health_anim.png")
	for i = 1, 24 do
				--if _x-dx ~= _x or _y-dy ~= _y then
		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(_mesh, 10, 10-i*20,  10, 2 ), 
			x = (_x),
			y = (_y),
			ix = math.random(-60, 60),
			iy = math.random(-60, 60),
			z = 100-i*20,
			life = 200,
			speed = 5,
			_effectType = 1,
		}

		table.insert(self._effectTable, temp)
		--end
	end

	local px, py = player:returnPosition( )
	if (px == _x and py == _y) then -- yep, player
		player:healPlayer( )
		log:newMessage("<c:26EB5D>Your wounds are healed!</c>")
	else -- check for enemies
		rngMap:isDarknessAt(_x, _y, true)
		local bool, id = entity:isEntityAt(_x, _y)
		if bool == true then -- yep, entity is there
			--print("BOOL IS TRUE")
			local v = entity:getList( )[id]
			if v ~= nil then
				v.hp = v.initial_health+v.healthModifier
				log:newMessage(""..v.name.." <c:26EB5D> has recovered his health</c>")
			end
		end
	end	


end

-- creates a HEALING effect with the center point
-- at the given coordinates.
-- the effect is made out of multiple textured meshes that
-- spawn in the center of the player mesh
-- and then move outwords and up in a radius
function item:createItemEffect_HEAL(_x, _y)
	--self._effectTable = { }
	local _mesh = makeBox(20, 20, 0, "assets/effects/health_anim.png")
	for i = 1, 26 do
		for dx = -1, 1 do
			for dy = -1, 1 do
				--if _x-dx ~= _x or _y-dy ~= _y then
					local temp = {
						id = #self._effectTable + 1,
						gfx = image:new3DImage(_mesh, 10, 10-i*20,  10, 2 ), 
						x = (_x-dx),
						y = (_y-dy),
						ix = math.random(-60, 60),
						iy = math.random(-60, 60),
						z = 100-i*20,
						life = 200,
						speed = 5,
						_effectType = 1,
					}

					table.insert(self._effectTable, temp)
				--end
			end
		end
	end

	-- is player in that location?
	print("*************************************************")
	print("EFFECT TABLE SIZE: "..#self._effectTable.."")
	print("EFFECT TABLE SIZE: "..#self._effectTable.."")
	print("EFFECT TABLE SIZE: "..#self._effectTable.."")
	print("EFFECT TABLE SIZE: "..#self._effectTable.."")
	print("EFFECT TABLE SIZE: "..#self._effectTable.."")
	print("EFFECT TABLE SIZE: "..#self._effectTable.."")
	local px, py = player:returnPosition( )
	for i, j in ipairs(self._effectTable) do
		print("I IS: "..i.."")
		
		if (px == j.x and py == j.y) then -- yep, player
			player:healPlayer( )
			log:newMessage("<c:26EB5D>Your wounds are healed!</c>")
		else -- check for enemies
			rngMap:isDarknessAt(j.x, j.y, true)
			local bool, id = entity:isEntityAt(j.x, j.y)
			if bool == true then -- yep, entity is there
				--print("BOOL IS TRUE")
				local v = entity:getList( )[id]
				if v ~= nil then
					v.hp = v.initial_health+v.healthModifier
					log:newMessage(""..v.name.." <c:26EB5D> has recovered his health</c>")
				end
			end
		end
	end
	print("*************************************************")
end

function item:createItemEffect_DamagePlayer(_x, _y, _ammount)
	local _mesh = makeBox(40, 40, 0, "assets/effects/effect_discharge_1.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/effect_discharge_2.png")

	local dmg = _ammount--math.random(4, 45)
	log:newMessage("You took "..dmg.." damage from the discharge spell")
	--entity:_combatDebug(i, dmg)
	local px, py = player:returnPosition( )
	player:receiveDamage(dmg, true)
	for i = 1, 12 do
		local tmesh = _mesh
		local rndCheck = math.random(1,2)
		if rndCheck == 1 then
			tmesh = _mesh2
		end
		_x = px
		_y = py
		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(tmesh, 10, 10-i*20,  10, 2 ), 
			x = (_x),
			y = (_y),
			ix = math.random(-40, 40),
			iy = math.random(-40, 40),
			z = 100-i*20,
			life = 100,
			speed = 8,
			_effectType = 1,
		}

		table.insert(self._effectTable, temp)

	end

end

function item:createItemEffect_DamageAll(_x, _y, _ammount)
	local _mesh = makeBox(40, 40, 0, "assets/effects/effect_discharge_1.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/effect_discharge_2.png")
	local entTable = entity:getList( )
	for i,v in ipairs(entTable) do
		local dmg = _ammount
		entity:_combatDebug(i, dmg)
		for i = 1, 12 do
			local tmesh = _mesh
			local rndCheck = math.random(1,2)
			if rndCheck == 1 then
				tmesh = _mesh2
			end
			local temp = {
				id = #self._effectTable + 1,
				gfx = image:new3DImage(tmesh, 10, 10-i*20,  10, 2 ), 
				x = (v.x),
				y = (v.y),
				ix = math.random(-40, 40),
				iy = math.random(-40, 40),
				z = 100-i*20,
				life = 100,
				speed = 8,
				_effectType = 1,
			}

			table.insert(self._effectTable, temp)

		end
	end

	
	--for i,v in ipairs
end

function item:createItemEffect_REVEAL(_x, _y)
	local _mesh = makeBox(40, 40, 0, "assets/effects/reveal_darkness_fx1.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/reveal_darkness_fx2.png")
	for i = 1, 64 do
		local tmesh = _mesh
		local rndCheck = math.random(1,2)
		if rndCheck == 1 then
			tmesh = _mesh2
		end
		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(tmesh, 10, 10-i*20,  10, 2 ), 
			x = (_x),
			y = (_y),
			ix = math.random(-40, 40),
			iy = math.random(-40, 40),
			z = 100-i*20,
			life = 100,
			speed = 8,
			_effectType = 1,
		}

		table.insert(self._effectTable, temp)

	end
	--end

	rngMap:disableDarkness( )
end

function item:createItemEffect_TELEPORT(_x, _y)
	--self._effectTable = { }
	local _mesh = makeBox(40, 40, 0, "assets/effects/teleport_effect_1.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/teleport_effect_2.png")
	for i = 1, 64 do
		local tmesh = _mesh
		local rndCheck = math.random(1,2)
		if rndCheck == 1 then
			tmesh = _mesh2
		end
		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(tmesh, 10, 10-i*20,  10, 2 ), 
			x = (_x),
			y = (_y),
			ix = math.random(-40, 40),
			iy = math.random(-40, 40),
			z = 100-i*20,
			life = 100,
			speed = 8,
			_effectType = 1,
		}

		table.insert(self._effectTable, temp)

	end

	-- is player in that location?
	local px, py = player:returnPosition( )
	if px == _x and py == _y then -- yep, player
		--player:receiveDamage(self._firePotionDamage) -- MAGIC NUMBER 15
		--log:newMessage("You took "..self._firePotionDamage.." damage form the fire brew ")
		local x, y = rngMap:returnEmptyLocations( )
		for i = 1, 64 do
			self._effectTable[i].x = x
			self._effectTable[i].y = y
		end
		player:setLoc(x, y)
		log:newMessage("You feel jumpy! You were randomly teleported somewhere....")
	else -- check for enemies
		local bool, id = entity:isEntityAt(_x, _y)
		if bool == true then -- yep, entity is there
			local v = entity:getList( )[id]
			print("I2222D IS: "..id.."")
			if v ~= nil then
				print("V NOT NIl")
				--entity:_doDamage(id, self._firePotionDamage)
				-- get random cell to teleport to
				local x, y = rngMap:returnEmptyLocations( )
				v.x = x
				v.y = y
				image:setLoc(v.prop, v.x*100, 100, v.y*100)
				log:newMessage(""..v.name.." was randomly teleported somewhere else....")
			end
		else

		end
	end
end

function item:createItemEffect_SpawnDarkness(_x, _y)

	local bool = rngMap:getDarknessAt(_x, _y)
	if bool == true then -- darkness present, REMOVE IT!
		for dx = -1, 1 do
			for dy = -1, 1 do
				rngMap:isDarknessAt(_x-dx, _y-dy, true)
			end
		end
		log:newMessage("Patches of Darkness are retreating")
	else -- not present, add it
		for dx = -1, 1 do
			for dy = -1, 1 do
				rngMap:addDarknessAt(_x-dx, _y-dy, true)
			end
		end
		log:newMessage("Patches of Darkness start to creep out")
	end



	
end

-- summong effect 1 and 2
function item:createItemEffect_SUMMONEPIC(_x, _y)
	--self._effectTable = { }
	local _mesh = makeBox(40, 40, 0, "assets/effects/summong_fx_1.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/summong_fx_2.png")
	local portalCounter = 0
	for i = 1, 64 do
		local tmesh = _mesh
		local rndCheck = math.random(1,2)
		if portalCounter ~= 1 then
			tmesh = _mesh2
		end
		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(tmesh, 10, 10-i*20,  10, 2 ), 
			x = (_x),
			y = (_y),
			ix = math.random(-40, 40),
			iy = math.random(-40, 40),
			z = 100-i*20,
			life = 100,
			speed = 8,
			_effectType = 2,
		}

		if portalCounter == 1 then
			temp.ix = 0
			temp.iy = 0
			temp.z = 100
			temp.life = 100
			temp.mainElement = true
		end
		portalCounter = portalCounter + 1
		table.insert(self._effectTable, temp)

	end



	local px, py = player:returnPosition( )
	local bool = false --, id = entity:isEntityAt(_x,_y)
	local spawnText = " creature"
	if bool == false then
		--if _x ~= px and _y ~= py then
		local itemTable = { }
		itemTable[1] = 23
		itemTable[2] = 22
		itemTable[3] = 21

		item:new(_x, _y, 23)

		log:newMessage("A summoning portal has appeared. A powerful item is being brough into this world!")

			
	else
		log:newMessage("A summoning portal has appeared, but nothing can pass through it")
	end

end

-- summong effect 1 and 2
function item:createItemEffect_SUMMON(_x, _y)
	--self._effectTable = { }
	local _mesh = makeBox(40, 40, 0, "assets/effects/summong_fx_1.png")
	local _mesh2 = makeBox(50, 50, 0, "assets/effects/summong_fx_2.png")
	local portalCounter = 0
	for i = 1, 64 do
		local tmesh = _mesh
		local rndCheck = math.random(1,2)
		if portalCounter ~= 1 then
			tmesh = _mesh2
		end
		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(tmesh, 10, 10-i*20,  10, 2 ), 
			x = (_x),
			y = (_y),
			ix = math.random(-40, 40),
			iy = math.random(-40, 40),
			z = 100-i*20,
			life = 100,
			speed = 8,
			_effectType = 2,
		}

		if portalCounter == 1 then
			temp.ix = 0
			temp.iy = 0
			temp.z = 100
			temp.life = 100
			temp.mainElement = true
		end
		portalCounter = portalCounter + 1
		table.insert(self._effectTable, temp)

	end



	local px, py = player:returnPosition( )
	--local x, y = rngMap:returnEmptyLocations( )
	local bool, id = entity:isEntityAt(_x,_y)
	local spawnType = math.random(1, 4)
	local spawnText = " creature"
	if bool == false then
		--if _x ~= px and _y ~= py then
			if spawnType == 1 then -- summon an item
				spawnText = "n item"
				item:new(_x, _y)
			else
				entity:debugSpawner(_x, _y )
			end
			log:newMessage("A summoning portal has appeared. A"..spawnText.." is being brought into our world!")
		--else
		--	log:newMessage("A summoning portal has appeared, but nothing can pass through it")
		--end
			
	else
		log:newMessage("A summoning portal has appeared, but nothing can pass through it")
	end

end


function item:createItemEffect_FIRE(_x, _y, _ammount)
	--self._effectTable = { }
	local _mesh = makeBox(20, 20, 0, "assets/effects/fire_ball.png")
	for i = 1, 26 do

		local temp = {
			id = #self._effectTable + 1,
			gfx = image:new3DImage(_mesh, 10, 10-i*20,  10, 2 ), 
			x = (_x),
			y = (_y),
			ix = math.random(-30, 30),
			iy = math.random(-30, 30),
			z = 100-i*20,
			life = 200,
			speed = 5,
			_effectType = 1,
		}

		table.insert(self._effectTable, temp)

	end

	print("AMMOUNT OF DAMAGE FIRE: ".._ammount.."")
	print("AMMOUNT OF DAMAGE FIRE: ".._ammount.."")
	-- is player in that location?
	local px, py = player:returnPosition( )
	if px == _x and py == _y then -- yep, player
		player:receiveDamage(_ammount, true) -- MAGIC NUMBER 15
		log:newMessage("You took "..self._firePotionDamage.." damage form the fire brew ")
	else -- check for enemies
		local bool, id = entity:isEntityAt(_x, _y)
		if bool == true then -- yep, entity is there
			local v = entity:getList( )[id]
			print("I2222D IS: "..id.."")
			if v ~= nil then
				print("V NOT NIl")
				entity:_doDamage(id, _ammount)
				log:newMessage("The Fire Brew exploded dealing ".._ammount.." damage to "..v.name.." Life left: "..v.hp.."")
			end
		else

		end
	end
end
-----------------------------------------------------------
----------------- END OF EFFECTS --------------------------
-----------------------------------------------------------

function item:updateEffects( )
	local heightCount = 0
	local rotCounter = 1
	for i,v in ipairs(self._effectTable) do
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

function item:dropEffect(_i)
	local _item = self._effectTable[_i]
	image:removeProp(_item.gfx, 2)
	_item.gfx = nil
	if _forceDelete ~= true then
		table.remove(self._effectTable, _i)
	end

end