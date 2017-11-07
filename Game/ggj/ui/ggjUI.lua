local textstyles = require "gui/textstyles"


function interface:initAP()
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("cmd.lua"), "")
	local g = element.gui
	g:addToResourcePath(filesystem.pathJoin("resources", "fonts"))
	g:addToResourcePath(filesystem.pathJoin("resources", "gui"))
	g:addToResourcePath(filesystem.pathJoin("resources", "media"))
	g:addToResourcePath(filesystem.pathJoin("resources", "themes"))
	FRAME = MOAISim.getPerformance ()
	self._blackBG = widgets.backGround.window
	self._logLabel = widgets.messageLog.window
	self._logLines = 1

	self._blackBG:setImage(resources.getPath("../gui/overlay_image_"..Game.optionSettings.scanLine..".png"), 1, 1, 1, 1)

	self._inventoryMax = 23
	self._inventoryLimit = 0  -- max items you can carry: 23
	self._inventoryBurdenMax = 0
	self._maxWeightToCarry = 100
	self._maxWeightToCarryDefault = 100

	textstyles.update("log", 14, 14)
	self._logLabel:setTextStyle(textstyles.get("log"), 54)

	--self._fpsCounter = widgets.fpsCounter.window

	self._inventoryBg = widgets.inventory.window
	self._logStringTable = { }
	--self:debugTesting( )
	self:setupInventory( )
	self:setupHud( )
	self._gameOverScreen = widgets.game_over.window
	self._maxArmor = 1
	self._maxWeapon = 1
	self._maxAccessories = 2
	self:hideGameOver( )

	
	self._favoriteItem = Game.favoriteItem
	interface:addCurrentItemToFavorite(nil)
end


function interface:_GetFavoriteItem( )
	return self._favoriteItem
end

function interface:_SetFavoriteItem(_item)
	self._favoriteItem = _item
	Game.favoriteItem = _item
end

function interface:getMaxWeightToCarry( )
	return self._maxWeightToCarry, self._maxWeightToCarryDefault
end

function interface:updateMaxWeightToCarry(_ammount)
	self._maxWeightToCarry = self._maxWeightToCarry + _ammount
end

function interface:setupHud( )
	--local roots, widgets, groups = element.gui:loadLayout(resources.getPath("cmd.lua"), "")
	local col_y = 89
	local spacing = 4

	local left_aling = 1
	local center_align = 30
	local right_aling = 70
	-- Player name
	self._playerNameLabel = element.gui:createLabel( )
	self._playerNameLabel:setDim(100, 4)
	self._playerNameLabel:setPos(left_aling-100, col_y)
	textstyles.update("inventory", 16, 14)
	self._playerNameLabel:setTextStyle(textstyles.get("inventory"))
	self._playerNameLabel:setText(""..Game.scoreTable.name.."")

	self._blackBG:addChild(self._playerNameLabel)
	self._showLog = false

	-- Player Stats
	self._playerLevelLabel = element.gui:createLabel( )
	self._playerLevelLabel:setDim(100, 4)
	self._playerLevelLabel:setPos(left_aling, col_y+spacing)
	textstyles.update("inventory", 16, 14)
	self._playerLevelLabel:setTextStyle(textstyles.get("inventory"))
	self._playerLevelLabel:setText("")

	self._blackBG:addChild(self._playerLevelLabel)

	--Weapon | Spell | Affinity
	self._AffinityLabel = element.gui:createLabel( )
	self._AffinityLabel:setDim(100, 4)
	self._AffinityLabel:setPos(center_align-5, col_y)
	textstyles.update("inventory", 16, 14)
	self._AffinityLabel:setTextStyle(textstyles.get("inventory"))
	self._AffinityLabel:setText("Direction: NORTH") -- WPN: 0.4 | SPK: 1 | ND: 0

	self._blackBG:addChild(self._AffinityLabel)

	-- Health/Weight
	self._statsLabel = element.gui:createLabel( )
	self._statsLabel:setDim(100, 4)
	self._statsLabel:setPos(center_align, col_y+spacing)
	textstyles.update("inventory", 16, 14)
	self._statsLabel:setTextStyle(textstyles.get("inventory"))
	self._statsLabel:setText("Health: 20/20 | Carry: 100")

	self._blackBG:addChild(self._statsLabel)


	-- Experience
	self._attackOverlay = element.gui:createImage( )
	self._attackOverlay:setDim(100, 85)
	self._attackOverlay:setPos(-1000, 7)
	self._attackOverlay:setImage(resources.getPath("../../attack_effect.png"), 1, 1, 1, 1)
	self._attackTimer = Game.worldTimer

	self._logTableLabels = {}

	self._gameOverMessageShown = false
	self._victoryMessageShown = false
end

function interface:updateAffinities( )
	--weaponAffinity
	local orientation = player:_getOrientation( )
	local compas = {}
	compas[1] = "North"
	compas[2] = "West"
	compas[3] = "South"
	compas[4] = "East"
	local getPlayerStats = player:returnPlayerStats( )
	if getPlayerStats ~= nil then
		self._AffinityLabel:setText("Direction: "..compas[orientation].." | Dungeon Level: "..math.floor(Game.dungeoNLevel).."") --WPN: "..math.floor(getPlayerStats.weaponAffinity).." | SPK: "..math.floor(getPlayerStats.spellKnowdlege).." | DL: "..math.floor(Game.dungeoNLevel)..""
	end
end

function interface:showGameOver( )
	self._showInventory = false

	self:_showFullLog( )
	if self._gameOverMessageShown == false then
		log:newMessage("You died! Press any key to return to the Main Menu")
		log:newMessage(" ")
		log:newMessage(" ")
		Game:deleteSave( )
		self._gameOverMessageShown = true
	end
	--Game.dungeoNLevel = 0
end

function interface:showVictory( )
	self._showInventory = false
	self._showLog = false
	log:RESET_LOG_TABLE( )
	self:_showFullLog( )
	if self._victoryMessageShown == false then
		log:newMessage("")
		log:newMessage("")
		log:newMessage("")
		log:newMessage("")
		log:newMessage("")
		log:newMessage("")
		log:newMessage("")
		log:newMessage("You <c:9FC43A>picked up</c> what was left of the <c:9FC43A>fervent goddess</c>")
		log:newMessage("And you <c:9FC43A>shatter it</c> without looking back!")
		log:newMessage("The <c:9FC43A>goddess is no more</c>, and her influence")
		log:newMessage("Is forever banished from this world!")
		log:newMessage("")
		log:newMessage("")
		log:newMessage("<c:9FC43A>You won!</c>")
		log:newMessage("")
		log:newMessage("")
		log:newMessage("Now go <c:9FC43A>forth</c>! A new adventure awaits....")
		log:newMessage("")
		log:newMessage("")
		interface:updateLogDispaly( )
		--Game:deleteSave( )
		self._victoryMessageShown = true
	end
	
end

function interface:hideGameOver( )
	self._gameOverScreen:setPos(0, -100)
end

function interface:doAttackAnim( )
	--[[if Game.worldTimer > self._attackTimer + 0.1 then
		self._attackOverlay:setPos(0, 7)
		self._attackTimer = Game.worldTimer
	else
		self._attackOverlay:setPos(-10000, 7)
		
	end--]]
end



function interface:toggleInvetory( )
	self._showInventory = not self._showInventory
	self._pointerTab = 1
	interface:incPointer( )
	interface:decPointer( )	
	self._showLog = false
	self:inventorySetPointerInList( )
end

function interface:getInventoryState( )
	return self._showInventory
end

function interface:isKeyInInventory( )
	local bool = false
	local item = nil
	local _v = nil
	for i,v in ipairs(self._inventoryTabel) do
		local endName = string.find(v.name, "Key")
		if endName ~= nil then
			bool = true
			item = i
			_v = v
		end
		
	end	
	return bool, item, _v
end

function interface:removeKeyFromInventoryObject(_v)

end

function interface:removeKeyFromInventory(_key)
	--print("Key: ".._key.."")
	interface:removeItemFromInventory(_key)
	--table.remove(self._inventoryTabel, _key)
end

function interface:_getInventoryTable( )
--[[	local _inventoryNoUserData = {}
	for i,v in ipairs(self._inventoryTabel) do
		----print("V GFXID: "..v.gfxID.."")
		_inventoryNoUserData[i] = v.gfxID
	end

	--table.save(_inventoryNoUserData, "inventoryTest.lua")
	----print("ALL OK HERE")
	return _inventoryNoUserData--]]
	local _inventoryNoUserData = {}
	for i,v in ipairs(self._inventoryTabel) do
		----print("V GFXID: "..v.gfxID.."")
		_inventoryNoUserData[i] = {}
		_inventoryNoUserData[i].id = v.gfxID
		_inventoryNoUserData[i].name = v.name
		_inventoryNoUserData[i].dmg = v.weapon_dmg
		_inventoryNoUserData[i].weapon_multi = v.weapon_multi
		_inventoryNoUserData[i].armor_arcane_def = v.armor_arcane_def
		_inventoryNoUserData[i].armor_def = v.armor_def
	end

	--table.save(_inventoryNoUserData, "inventoryTest.lua")
	----print("ALL OK HERE")
	return _inventoryNoUserData
end

function interface:_getEquipmentTable( )
--[[	local _equipmentNoUserData = {}
	if self._equipmentTable ~= nil then
		for i,v in ipairs(self._equipmentTable) do
			----print("V GFXID: "..v.gfxID.."")
			_equipmentNoUserData[i] = v.gfxID
		end
	end]]

	local _equipmentNoUserData = {}
	if self._equipmentTable ~= nil then
		for i,v in ipairs(self._equipmentTable) do
			----print("V GFXID: "..v.gfxID.."")
			_equipmentNoUserData[i] = {}
			_equipmentNoUserData[i].id = v.gfxID
			_equipmentNoUserData[i].name = v.name
			_equipmentNoUserData[i].dmg = v.weapon_dmg
			_equipmentNoUserData[i].weapon_multi = v.weapon_multi
			_equipmentNoUserData[i].armor_arcane_def = v.armor_arcane_def
			_equipmentNoUserData[i].armor_def = v.armor_def
		end
	end

	--table.save(_equipmentNoUserData, "equipmentTest.lua")
	----print("ALL OK HERE")
	return _equipmentNoUserData
end

function interface:saveInventory( )
	Game.inventorySave[1] = { }
	Game.inventorySave[2] = { }

	for i,v in ipairs(self._inventoryTabel) do
		table.insert(Game.inventorySave[1], v)
	end	

	for i,v in ipairs(self._equipmentTable ) do
		table.insert(Game.inventorySave[2], v)
	end	
end

function interface:loadInventory( )


	if Game.iteration ~= 0 then
		if Game.inventorySave[1] ~= nil then
			self._inventoryTabel = { }
			for i,v in ipairs(Game.inventorySave[1]) do
				--table.insert(self._inventoryTabel, v)
				self:addItemToInventory(v)
			end
		end

		if Game.inventorySave[2] ~= nil then
			self._equipmentTable = { }
			for i,v in ipairs(Game.inventorySave[2]) do
				--table.insert(self._equipmentTabel, v)
				self:addItemToEquipment(v, true)

			end
		end

		self._tabTable[1] = self._inventoryTabel
		self._tabTable[2] = self._equipmentTable
	end
end

function interface:removeItemFromInventory(_item)
	
	if _item ~= nil then
		local dItem = self._tabTable[self._pointerTab][_item]
		if dItem ~= nil then
			sound:play(Game.dropItem)
			local px, py = player:returnPosition( )
			dItem.label:destroy( )
			table.remove(self._tabTable[self._pointerTab], _item)
		end
	end
	self:_updateHealthModifier( )
end

function interface:loadInventoryFromSaveGame(_inventory)
	if self._inventoryTabel ~= nil then
		for j = 1, #self._inventoryTabel+1 do
			for i,v in ipairs(self._tabTable[1]) do
				v.label:destroy( )
				table.remove(self._tabTable[1], i)
			end	
		end

		local px, py = player:returnPosition( )
		for i = 1, #_inventory do
			--item:new(px, py, _inventory[i])
			item:newSetStats(px, py, _inventory[i].id, _inventory[i].dmg, _inventory[i].name, _inventory[i].weapon_multi,  _inventory[i].armor_def,  _inventory[i].armor_arcane_def)
			local bool, _id = item:isItemAt(px, py)
			if bool == true then
				local _item = item:returnItem(_id)
				interface:addItemToInventory(_item)
				item:dropitem(_id)
			end				
		end
		--print("ADDED INVENTORY DATA")
	
	--[[
		for i,v in ipairs(self._tabTable[1]) do
			v.label:destroy( )
			table.remove(self._tabTable[1], i)
		end		
	]]

	end
end

function interface:loadEquipmentFromSaveGame(_equipment)
	if self._equipmentTable ~= nil then
		for j = 1, #self._equipmentTable+2 do
			for i,v in ipairs(self._tabTable[2]) do
				v.label:destroy( )
				table.remove(self._tabTable[2], i)
			end	
		end

		local px, py = player:returnPosition( )
		for i = 1, #_equipment do
			--item:new(px, py, _equipment[i])
			item:newSetStats(px, py, _equipment[i].id, _equipment[i].dmg, _equipment[i].name, _equipment[i].weapon_multi, _equipment[i].armor_def,  _equipment[i].armor_arcane_def)
			local bool, _id = item:isItemAt(px, py)
			if bool == true then
				----print("IT IS TRUE")
				local _item = item:returnItem(_id)
				interface:addItemToEquipment(_item, true)
				item:dropitem(_id)
			end				
		end
	end

end

function interface:_updateHealthModifier( )
	local modifier = 0
	local regModifier = 0
	local thrownModifier = 0
	local gunModifier = 0
	for i,v in ipairs(self._equipmentTable) do
		if v.modifierType == "hp" then
			modifier = modifier + v.modifier
		elseif v.modifierType =="hp_regen" then
			regModifier = regModifier + v.modifier
		elseif v.modifierType == "thrown" then
			thrownModifier = thrownModifier + v.modifier
		elseif v.modifierType == "gobber_effect_rengen" then
			regModifier = regModifier + v.modifier
			local chanceToSpawnItem = 2
			local randomRoll = math.random(1, 200)
			if randomRoll <= chanceToSpawnItem then
				local px, py = player:returnPosition( )
				item:createItemEffect_SUMMONEPIC(px, py)
			end
		elseif v.modifierType == "marksmanship" then
			gunModifier = gunModifier + v.modifier
		end
	end

	for i,v in ipairs(self._inventoryTabel) do
		if v._type == "Artefact" then
			if v.modifierType == "hp" then
				modifier = modifier + v.modifier
			elseif v.modifierType =="hp_regen" then
				regModifier = regModifier + v.modifier
			elseif v.modifierType == "thrown" then
				thrownModifier = thrownModifier + v.modifier
			elseif v.modifierType == "gobber_effect_rengen" then
				regModifier = regModifier + v.modifier
				local chanceToSpawnItem = 99
				local randomRoll = math.random(1, 100)
				if randomRoll <= chanceToSpawnItem then
					local px, py = player:returnPosition( )
					item:createItemEffect_SUMMONEPIC(px, py)
				end
			end
		end
	end
	player:updateHealthModifier(modifier)
	player:updateRegenModifier(regModifier)
	player:updateThrownModifier(thrownModifier)
	player:updateGunModifier(gunModifier)
end



function interface:_updateRegModifier( )
	local regModifier = 0
	for i,v in ipairs(self._equipmentTable) do
		if v.modifierType == "hp_regen" then
			regModifier = regModifier + v.modifier
		end
	end
	
end

function interface:_getMostValuableItem( )
	local _value = 0
	local sortingTable = { }
	for i,v in ipairs(self._inventoryTabel) do
		table.insert(sortingTable, v)
	end

	for i,v in ipairs(self._equipmentTable) do
		table.insert(sortingTable, v)
	end

	local sortedTable = { }
	for i, j in spairs(sortingTable, function(t,a,b) return t[b].value < t[a].value end) do
		table.insert(sortedTable, j)
	end

	if sortedTable ~= nil then
		return sortedTable[1]
	end
end


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

function interface:_closeInventory( )
	self._showInventory = false
end

function interface:setupInventory( )
	self._showInventory = false
	-- panel is inventoryBG
	-- Idea is to have 3 panels Inventory | Equipment | Description
	-- All items picked up go into Inventory. Equiping an item sends it to equipment. You can go through all items you have by scrolling through the list with W/S

	self._nrOfpanels = 3
	self._inventoryTabel = { } -- holds items added to inventory
	self._equipmentTable = { } -- holds items added to equipment
	self._inventoryX = 1
	self._inventoryY = 5
	self._equipmentX = 35
	self._equipmentY = 5

	self._inventoryMaxItems = 20
	self._equipmentMaxItems = 7


	self._tabTable = { } -- this holds all 3 tables and allows pointer switching
	self._tabTable[1] = self._inventoryTabel
	self._tabTable[2] = self._equipmentTable

	self._tabLocation = { }
	self._tabLocation[1] = {x = self._inventoryX, y = self._inventoryY}
	self._tabLocation[2] = {x = self._equipmentX, y = self._equipmentY}

	self._spaceBetweenItems = 3

	self._Pointer = ">"
	self._pointerPos = 1
	self._pointerTab = 1 -- default on inventoryTable
	-- INVENTORY LABEL
	self._inventoryLabel = element.gui:createLabel( )
	self._inventoryLabel:setDim(100, 4)
	self._inventoryLabel:setPos(1, 5)
	textstyles.update("inventory", 16, 14)
	self._inventoryLabel:setTextStyle(textstyles.get("inventory"))
	self._inventoryLabel:setText("<c:AA5500>*-</c><c:FFFF00>Inventory</c><c:AA5500>---------*</c>")

	self._inventoryBg:addChild(self._inventoryLabel)

	-- EQUIPMENT LABEL
	self._equipmentLabel = element.gui:createLabel( )
	self._equipmentLabel:setDim(100, 4)
	self._equipmentLabel:setPos(32, 5)
	textstyles.update("inventory", 16, 14)
	self._equipmentLabel:setTextStyle(textstyles.get("inventory"))
	self._equipmentLabel:setText("<c:AA5500>*-</c><c:FFFF00>Equipment</c><c:AA5500>----------*</c>")

	self._inventoryBg:addChild(self._equipmentLabel)

	-- DESCRIPTION LABEL
	self._descriptionLabel = element.gui:createLabel( )
	self._descriptionLabel:setDim(100, 4)
	self._descriptionLabel:setPos(64.8, 5)
	textstyles.update("inventory", 16, 14)
	self._descriptionLabel:setTextStyle(textstyles.get("inventory"))
	self._descriptionLabel:setText("<c:AA5500>*-</c><c:FFF00>Description</c><c:AA5500>--------*</c>")

	self._inventoryBg:addChild(self._descriptionLabel)
 	

	--[[local colorTabel = { }
	colorTabel[1] = {s="<c:FFFF00>", e="</c>" }
	colorTabel[2] = {s="<c:7CFC00>", e="</c>" }
	colorTabel[3] = {s="<c:FF0000>", e="</c>" }
	colorTabel[4] = {s="<c:FF00FF>", e="</c>" }
	colorTabel[5] = {s="<c:483D8B>", e="</c>" }
	colorTabel[6] = {s="<c:1E90FF>", e="</c>" }
	colorTabel[7] = {s="<c:800080>", e="</c>" }
	colorTabel[8] = {s="<c:008080>", e="</c>" }
	colorTabel[9] = {s="<c:808080>", e="</c>" }
	colorTabel[10] = {s="<c:33FF99>", e="</c>" }--]]


	for i = 1, 10 do
	--	self:addItemToInventory(""..colorTabel[i].s..""..itemFakeLabel[i]..""..colorTabel[i].e.."")
	end

	self:setupInventoryDescriptionArea( )
	self:loadInventory( )
	self._Pointer = ">"
	self._pointerPos = 1
	self._pointerTab = 1 -- default on inventoryTable
end


function interface:setupInventoryDescriptionArea( )
	textstyles.update("inventory", 16, 14)

	self._itemNameLabel = element.gui:createLabel( )
	self._itemNameLabel:setDim(30, 4)
	self._itemNameLabel:setPos(68, 10)
	self._itemNameLabel:setText("Item Name")
	self._itemNameLabel:setTextStyle(textstyles.get("inventoryItem"))
	self._inventoryBg:addChild(self._itemNameLabel)

	self._itemDamageLabel = element.gui:createLabel( )
	self._itemDamageLabel:setDim(30, 4)
	self._itemDamageLabel:setPos(68, 14)
	self._itemDamageLabel:setText("Damage:")
	self._itemDamageLabel:setTextStyle(textstyles.get("inventoryItem"))
	self._inventoryBg:addChild(self._itemDamageLabel)	

	self._itemMultiplierLabel = element.gui:createLabel( )
	self._itemMultiplierLabel:setDim(30, 4)
	self._itemMultiplierLabel:setPos(68, 18)
	self._itemMultiplierLabel:setText("Multiplier:")
	self._itemMultiplierLabel:setTextStyle(textstyles.get("inventoryItem"))
	self._inventoryBg:addChild(self._itemMultiplierLabel)	

	self._itemDefenseLabel = element.gui:createLabel( )
	self._itemDefenseLabel:setDim(30, 4)
	self._itemDefenseLabel:setPos(68, 22)
	self._itemDefenseLabel:setText("Defense:")
	self._itemDefenseLabel:setTextStyle(textstyles.get("inventoryItem"))
	self._inventoryBg:addChild(self._itemDefenseLabel)	

	self._itemArcaneDefenseLabel = element.gui:createLabel( )
	self._itemArcaneDefenseLabel:setDim(30, 4)
	self._itemArcaneDefenseLabel:setPos(68, 26)
	self._itemArcaneDefenseLabel:setText("Arcane Defense:")
	self._itemArcaneDefenseLabel:setTextStyle(textstyles.get("inventoryItem"))
	self._inventoryBg:addChild(self._itemArcaneDefenseLabel)	
	
	self._itemValueLabel = element.gui:createLabel( )
	self._itemValueLabel:setDim(30, 4)
	self._itemValueLabel:setPos(68, 30)
	self._itemValueLabel:setText("Value:")
	self._itemValueLabel:setTextStyle(textstyles.get("inventoryItem"))
	self._inventoryBg:addChild(self._itemValueLabel)	

	self._itemWeightLabel = element.gui:createLabel( )
	self._itemWeightLabel:setDim(30, 4)
	self._itemWeightLabel:setPos(68, 34)
	self._itemWeightLabel:setText("Weight:")
	self._itemWeightLabel:setTextStyle(textstyles.get("inventoryItem"))
	self._inventoryBg:addChild(self._itemWeightLabel)	

	--self._debugImage = element.gui:createImage( )
	--self._debugImage:setDim(32, 70)
	--self._debugImage:setPos(66, 38)

	--self._debugImage:setImage(resources.getPath("../gui/mb_box.png"), 1, 1, 1, 1)
	--self._inventoryBg:addChild(self._debugImage)	

	self._descriptionTextBox = element.gui:createTextBox( )
	self._descriptionTextBox:setDim(32, 90)
	self._descriptionTextBox:setPos(66, 38)
	self._descriptionTextBox:setLineHeight(4)
	--self._descriptionTextBox:setBackgroundImage( )
	self._inventoryBg:addChild(self._descriptionTextBox)	


	self._descriptionTextBox:addText("")
	

	self._descriptionTextBox:_setTextStyle("inventoryItem")

	--------------------------------------------------------
	------------------- FULL LOG ---------------------------
	--------------------------------------------------------
	self._logBG = element.gui:createImage( )
	self._logBG:setDim(100, 70)
	self._logBG:setPos(-100, 15)
	
	self._logBG:setImage(resources.getPath("../gui/ggMM/bg_ui_option.png"), 1, 1, 1, 1)

	self._logTextBox = element.gui:createTextBox( )
	self._logTextBox:setDim(100, 70)
	self._logTextBox:setPos(0, 3)
	self._logTextBox:setLineHeight(4)

	self._logPointer = 0
	self._logBG:addChild(self._logTextBox)
	--self._inventoryBg:addChild(self._descriptionTextBox)	

end

function interface:updateItemDescription(_item)

--[[
				temp.weapon_dmg = oldTable.weapon_dmg
				temp.weapon_multi = oldTable.weapon_multi
				temp.spell_atune = oldTable.spell_atune
				temp.spell_dmg = oldTable.spell_dmg
				temp.armor_def = oldTable.armor_def
				temp.armor_arcane_def = oldTable.armor_arcane_def
				temp._type = oldTable._type
				temp.name = oldTable.name
				temp.weight = oldTable.weight
				temp.gfxID = oldTable.gfxID
				temp.value = oldTable.value
				temp.effect = oldTable.effect

]]
	if _item ~= nil then
		self._itemNameLabel:setText("Item Name: <c:".._item.color..">".._item.name.."</c>")
		self._itemDamageLabel:setText("Damage:".._item.weapon_dmg.."")
		self._itemMultiplierLabel:setText("Multiplier:".._item.weapon_multi.."")
		self._itemDefenseLabel:setText("Defense:".._item.armor_def.."")
		self._itemArcaneDefenseLabel:setText("Arcane Defense:".._item.armor_arcane_def.."")
		self._itemValueLabel:setText("Value:".._item.value.."")
		self._itemWeightLabel:setText("Weight:".._item.weight.."")
		self._descriptionTextBox:_clear( )
		--self._descriptionTextBox:addText("".._item.description.."")
		--[[
			If text is wider than 30 characters split it into several lines
		]]
		local newText = ""
		local maxCharacters = 27
		local stringLine = ""
		local counter = 0
		local lines = { }
		local lineCounter = 1
		local lastWordStart = 0
		for i = 1, #_item.description do
			local c = _item.description:sub(i,i)
			if counter < maxCharacters then
				stringLine = stringLine..""..c..""
				if i >= #_item.description then
					table.insert(lines, stringLine)
				end
			else
				stringLine = stringLine..""
				table.insert(lines, stringLine)
				stringLine = ""..c..""
				counter = 0
			end
			counter = counter + 1
		end
		--self._descriptionTextBox:_clear( )
		for i,v in ipairs(lines) do
			----print("Line ["..i.."]: "..v.."")
			self._descriptionTextBox:addText(""..v.."")
			self._descriptionTextBox:newLine( )
		end
		self._descriptionTextBox:_setTextStyle("inventoryItem")
	end
end

function interface:updateFullLog( )

end

function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end


function interface:inventorySetPointerInList( )
	local _idx = self._pointerPos
	local iTable = self._tabTable[self._pointerTab]
	
	if  iTable[_idx] ~= nil then
		local itemLabelText = iTable[_idx].label:getText( )
		iTable[_idx].label:setText(""..self._Pointer..""..itemLabelText.."")
	end

end

function interface:incPointer( )
	sound:play(Game.uiSwitch)
	self._pointerPos = self._pointerPos + 1
	if self._pointerPos > #self._tabTable[self._pointerTab] then
		if #self._tabTable[self._pointerTab] > 0 then
			self._pointerPos = 1
		else
			self._pointerPos = #self._tabTable[self._pointerTab]
		end
	end

	--self:updateItemDescription(_item)
	local iTable = self._tabTable[self._pointerTab]
	----print("POINTER TAB: "..self._pointerTab.."Pointer Pos: "..self._pointerPos.."")
	self:updateItemDescription(iTable[self._pointerPos])
end

function interface:decPointer( )
	sound:play(Game.uiSwitch)
	self._pointerPos = self._pointerPos - 1
	if self._pointerPos  < 1 then
		if #self._tabTable[self._pointerTab] > 0 then
			self._pointerPos = #self._tabTable[self._pointerTab]
		else
			self._pointerPos = 1
		end
	end

	local iTable = self._tabTable[self._pointerTab]
	self:updateItemDescription(iTable[self._pointerPos])
end

function interface:movePointerTabRight( )
	sound:play(Game.uiSwitch)
	self._pointerPos = 1
	self._pointerTab = self._pointerTab + 1
	if self._pointerTab > #self._tabTable then
		self._pointerTab = #self._tabTable
	end
	self:inventoryResetAllItems( )
end

function interface:movePointerTabLeft( )
	sound:play(Game.uiSwitch)
	self._pointerPos = 1
	self._pointerTab = self._pointerTab - 1
	if self._pointerTab < 1 then
		self._pointerTab = 1
	end
	self:inventoryResetAllItems( )
	--self:equipmentResetAllitems( )
end

function interface:getPointer( )
	return self._pointerPos
end

function interface:getPointerTab( )
	return self._pointerTab
end

function interface:inventoryResetAllItems()
	local iTable = self._tabTable[self._pointerTab] -- self._inventoryTabel
	----print("TABLE SIZE: "..#iTable.." and pointer loc: "..self._pointerPos.."")
	if iTable ~= nil and #iTable > 0 and self._pointerPos > 0 then
		if self._pointerPos > #self._tabTable[self._pointerTab] then
			self._pointerPos = #self._tabTable[self._pointerTab]
		end
		local _exceptionID = self._pointerPos
		local _idx = self._pointerPos
		local itemLabelText = iTable[_idx].name
		for i = 1, #iTable do
			iTable[i].id = i
			local itemLabelText = iTable[i].name
				iTable[i].label:setPos(self._tabLocation[self._pointerTab].x, self._tabLocation[self._pointerTab].y+self._spaceBetweenItems*i)
			if i ~= _exceptionID then
				iTable[i].label:setText(""..itemLabelText.."")
			else
				iTable[i].label:setText(">"..itemLabelText.."")
			end
			
		end
	end
end

function interface:_getTotalInventoryWeight( )
	local idx = 2
	local tab = self._tabTable

	local totalWeight = 0
	for i = 1, idx do
		local _tb = tab[i]
		for i,v in ipairs(_tb) do
			totalWeight = totalWeight + v.weight
		end
	end

	return totalWeight
end

function interface:updateInventoryAmmount( )
	
	-- loop throug inventory and equipment, check WEIGHT OF ITEMS
	local nrItems = 0
	local weight = 0
	for i,v in ipairs(self._inventoryTabel) do
		weight = weight + v.weight
		nrItems = nrItems + 1
	end

	for i,v in ipairs(self._equipmentTable) do
		weight = weight + v.weight
		nrItems = nrItems + 1
	end

	self._inventoryBurdenMax = weight
	self._inventoryLimit = nrItems--#self._inventoryTabel + #self._equipmentTable
end

function interface:returnInventorySize( )
	return self._inventoryTabel
end

function interface:getInventoryCurrentLimit( )
	self:updateInventoryAmmount( )
	return self._inventoryLimit, self._inventoryMax, self._inventoryBurdenMax
end

function interface:_checkNrOfItemTypesEquipped( )
--[[

	self._maxArmor = 1
	self._maxWeapon = 1
	self._maxAccessories = 2
	]]

	local armorCounter = 0
	local weaponCounter = 0
	local accessoriesCounter = 0
	for i,v in ipairs(self._equipmentTable) do
		if v._type == "Armor" then 
			armorCounter = armorCounter + 1
		elseif v._type == "Weapon" then
			weaponCounter = weaponCounter + 1
		elseif v._type == "Accessories" then
			accessoriesCounter = accessoriesCounter + 1
		end
	end

	return armorCounter, weaponCounter, accessoriesCounter
end

function interface:_getDefenseRating( )
	local def = 0
	for i,v in ipairs(self._equipmentTable) do
		if v._type == "Armor" or v._type == "Accessories" then
			def = v.armor_def
		end
	end
	return def
end

function interface:_getArcandeDefRating( )
	local def = 0
	for i,v in ipairs(self._equipmentTable) do
		if v._type == "Armor" then
			def = v.armor_arcane_def
		end
	end
	return def
end
-- item will just be a name for now
function interface:addItemToInventory(_item)

	--if self._inventoryLimit < self._inventoryMax then
		if _item ~= nil  then
			local oldTable = nil
			local bool = true
			if type(_item) == "number" then
				oldTable = self._equipmentTable[_item]
				if self._equipmentTable[_item] ~= nil then
					_item = self._equipmentTable[_item].name
				else
					bool = false
				end
			end
				if _item.ALABALAPORTOCALA ~= nil then
					--print(_item.ALABALAPORTOCALA)
					--print(_item.ALABALAPORTOCALA)
					--print(_item.ALABALAPORTOCALA)
					--print(_item.ALABALAPORTOCALA)
					--print(_item.ALABALAPORTOCALA)
					--print(_item.ALABALAPORTOCALA)
				end
			if bool == true then
				local temp = {
					id = #self._inventoryTabel+1,
					tp = 1,
					label = element.gui:createLabel( ),
					name = _item.name,
				}

				 -- it's an item from the ground
					----print("FROM ZA GROUND")
				if oldTable ~= nil then
					temp.weapon_dmg = oldTable.weapon_dmg
					temp.weapon_multi = oldTable.weapon_multi
					temp.spell_atune = oldTable.spell_atune
					temp.spell_dmg = oldTable.spell_dmg
					temp.armor_def = oldTable.armor_def
					temp.armor_arcane_def = oldTable.armor_arcane_def
					temp._type = oldTable._type
					temp.name = oldTable.name
					temp.weight = oldTable.weight
					temp.gfxID = oldTable.gfxID
					temp.value = oldTable.value
					temp.effect = oldTable.effect
					temp.value = oldTable.value
					temp.color = oldTable.color
					temp.description = oldTable.description
					temp.spawnChance = oldTable.spawnChance
					temp.modifierType = oldTable.modifierType
					temp.modifier = oldTable.modifier
				else
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
					temp.value = _item.value
					temp.effect = _item.effect
					temp.value = _item.value
					temp.color = _item.color
					temp.description = _item.description
					temp.spawnChance = _item.spawnChance
					temp.modifierType = _item.modifierType
					temp.modifier = _item.modifier
				end
				

				sound:play(Game.pickupSound)
				temp.label:setDim(50, 4)
				local i = temp.id
				temp.label:setPos(self._inventoryX, self._inventoryY+self._spaceBetweenItems*i)
				temp.label:setText(""..temp.name.."")
				textstyles.update("inventoryItem", 11, 11)
				temp.label:setTextStyle(textstyles.get("inventoryItem"), 665)
				self._inventoryBg:addChild(temp.label)
				if oldTable ~= nil then
					----print("POINTER TAB: "..self._pointerTab.." ...")
					oldTable.label:destroy( )
					table.remove(self._tabTable[self._pointerTab], oldTable.id)
				end
				log:newMessage("You picked up an item -: "..temp.name.."")
				table.insert(self._inventoryTabel, temp)
			end
		end
	--end
	self:updateInventoryAmmount( )
	self:_updateHealthModifier( )

end

function interface:addCurrentItemToFavorite(_item)
	-- loop through the items and reset the names
	for i,v in ipairs(self._inventoryTabel) do
		local resultName = string.find(v.name, "[*]")
		if resultName ~= nil then
			v.name = string.gsub(""..v.name.."", "%[%*%]", "")
		end
	end
	self._favoriteItem = nil
	--Game.favoriteItem = nil
	if _item ~= nil then
		local ___item = self._inventoryTabel[_item]
		if ___item._type == "Artefact" then
			self._favoriteItem = ___item
			Game.favoriteItem = self._favoriteItem
			___item.name = "[*]"..___item.name
		end
	end
end

function interface:triggerFavoriteItem( )
	-- check if our favorite item still exists in the inventory
	if self._favoriteItem == nil then
		if Game.favoriteItem ~= nil then
			self._favoriteItem = Game.favoriteItem
			--print("FAVORITE ITEM SHOULD BE SET TO GAME.FAVORITE ITEM")
		end
	end

	if Game.favoriteItem == nil then
		--print("THIS MOTHER FUCKER IS NILL")
	else
		--print("WE THERE! ITEM THERE")
	end

	if self._favoriteItem ~= nil then
		--print("We get here with our item")
		isItemThere = false
		for i,v in ipairs(self._inventoryTabel) do
			if v == self._favoriteItem or v == Game.favoriteItem then
				isItemThere = true
			end
			--print(""..type(self._favoriteItem).."")
		end

		--print("still going...")
		if isItemThere == true then
			--print("OK We found the item...")
			if self._favoriteItem._type == "Artefact" then
				local px, py = player:returnPosition( )
				item:doItemEffect(self._favoriteItem, px, py)
				evTurn:handlePCTurn()
			end
		else
			self._favoriteItem = nil
			if Game.favoriteItem ~= nil then
				if Game.favoriteItem._type == "Artefact" then
					local px, py = player:returnPosition( )
					item:doItemEffect(Game.favoriteItem, px, py)
					evTurn:handlePCTurn()
				end
			end
		end
	end	
end

function interface:_applyItemEffect(_item)

end

function interface:addItemToEquipment(_item, _forced)
	if _item ~= nil and #self._inventoryTabel > 0 then
		----print("_Item is: ".._item.."")

		local ___item = self._inventoryTabel[_item]
		if _forced ~= nil then
			___item = _item
		end
		local temp = {
			id = #self._equipmentTable+1,
			name = ___item.name,
			tp = ___item.tp,
			label = element.gui:createLabel( ),
			weight = ___item.weight,
			effect = ___item.effect
		}

		local addBool = true
		local checkTypeAmmount = 0
		local nrArmor, nrWeapons, nrAccessories = self:_checkNrOfItemTypesEquipped( )
		if ___item._type == "Armor" then
			if nrArmor >= self._maxArmor then
				addBool = false
				log:newMessage("Cannot equip any more armor to the armor slot!")
			end 
		elseif ___item._type == "Weapon" then
			if nrWeapons >= self._maxWeapon then
				addBool = false
				log:newMessage("You are already weilding a weapon!")
			end
		elseif ___item._type == "Accessories" then
			if nrAccessories >= self._maxAccessories then
				addBool = false
				log:newMessage("You cannot carry any more Bling!")
			end
		end
		if addBool == true then
			if tostring(___item._type) ~= "Potion" and tostring(___item._type) ~= "misc" and tostring(___item._type) ~= "Scroll" and tostring(___item._type) ~= "Artefact" and tostring(___item._type) ~= "Goal" then

				--if ___item._type ~= nil then
				temp.weapon_dmg = ___item.weapon_dmg
				temp.weapon_multi = ___item.weapon_multi
				temp.spell_atune = ___item.spell_atune
				temp.spell_dmg = ___item.spell_dmg
				temp.armor_def = ___item.armor_def
				temp.armor_arcane_def = ___item.armor_arcane_def
				temp._type = ___item._type
				temp.gfxID = ___item.gfxID
				temp.effect = ___item.effect
				temp.value = ___item.value
				temp.color = ___item.color
				temp.description = ___item.description
				temp.spawnChance = ___item.spawnChance
				temp.modifierType = ___item.modifierType
				temp.modifier = ___item.modifier
				--end
				temp.label:setDim(50, 4)
				local i = temp.id
				temp.label:setPos(self._equipmentX, self._equipmentY+self._spaceBetweenItems*i)
				temp.label:setText(""..temp.name.."")
				textstyles.update("inventoryItem", 11, 11)
				temp.label:setTextStyle(textstyles.get("inventoryItem"), 1337)
				self._inventoryBg:addChild(temp.label)

				table.insert(self._equipmentTable, temp)
				if ___item.label ~= nil then
					___item.label:destroy( )
				end

				if _forced == nil then
					table.remove(self._inventoryTabel, _item)
					--print("TABLE SIZE LEFT: "..#self._inventoryTabel.."")
				end

				sound:play(Game.pickupSound)
			else
				-- apply heal effect :D
				--player:healPlayer( )
				if ___item._type == "Scroll" then
					player:_trainSpell( )
				end
				

				if tostring(___item._type) ~= "Artefact" and tostring(___item._type) ~= "Goal" then
					___item.label:destroy( )
					table.remove(self._inventoryTabel, _item)
				end

				if tostring(___item._type) == "Potion" then
					sound:play(Game.potionSound)
				end
				
				local px, py = player:returnPosition( )
				--[[if ___item.effect == "heal" then
					item:createItemEffect_HEAL(px, py)
				else
					item:createItemEffect_FIRE(px, py)
				end--]]
				item:doItemEffect(___item, px, py)
				evTurn:handlePCTurn()
				self._showInventory = false

			end
		end

		--self:inventoryResetAllItems( )
	end
	self:_updateHealthModifier( )
end


function interface:_throwItem(_item, _orientation)

	local didWeThrow = false
	----print("TYPE OF _ITEM: "..type(_item).."")
	local _nItem = _item
	if type(_item) == "Table" then
		_nItem = _item.gfxID
	end
	if _item ~= nil and #self._inventoryTabel > 0 then
		local dItem = self._tabTable[self._pointerTab][_nItem]
		if dItem ~= nil then
			----print("^^^^&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
			--item:throwSetStats(dItem.gfxID, _orientation)
			item:throwSetStats(dItem.gfxID, _orientation, nil, nil, nil, dItem.weapon_dmg,  dItem.name,  dItem.weapon_multi,  dItem.armor_def,  dItem.armor_arcane_def)
			 
			dItem.label:destroy( )
			log:newMessage("You threw a <c:a9a9a9>"..dItem.name.."</c>.")
			table.remove(self._tabTable[self._pointerTab], _item)
			didWeThrow = true
			self._showInventory = false
		end
	end
	self:_updateHealthModifier( )
	self:updateInventoryAmmount( )
	return didWeThrow
	
end

function interface:returnEquipmentBonus( )
	local weapon_damage = 0
	local weapon_multi = 0

	for i,v in pairs(self._equipmentTable) do
		weapon_damage = weapon_damage + v.weapon_dmg
		weapon_multi = weapon_multi + v.weapon_multi
	end

	return weapon_damage, weapon_multi
end

function interface:dropItemToGround(_item)
	
	if _item ~= nil then
		local dItem = self._tabTable[self._pointerTab][_item]
		if dItem ~= nil then
			sound:play(Game.dropItem)
			local px, py = player:returnPosition( )
			--item:new(px, py, dItem.gfxID)
			--_x, _y, _item, _dmg, _name, _multi, _armor_def, _armor_arcane_def
			for i,v in pairs(dItem) do
				--print("I: "..i.."")
			end
			item:newSetStats(px, py, dItem.gfxID, dItem.weapon_dmg, dItem.name,  dItem.weapon_multi,  dItem.armor_def,   dItem.armor_arcane_def)
			log:newMessage("You dropped "..dItem.name.."")
			dItem.label:destroy( )
			table.remove(self._tabTable[self._pointerTab], _item)
		end
	end
	self:updateInventoryAmmount( )
	self:_updateHealthModifier( )
	self:decPointer( )
end

function interface:_showFullLog( )
	self._logPointer = 0
	self._showLog = not self._showLog
	if self._showLog == true then
		interface:updateLogDispaly( )
	end
	self._showInventory = false
	element.gui:setFocus(self._logBG)
end

function interface:_getLogOpenedStatus( )
	return self._showLog
end

function interface:_showFullLogAlways( )
	self._showLog = true
	self._showInventory = false
	element.gui:setFocus(self._logBG)
end

function interface:_getLogOrInventoryStatus( )
	local bool = false
	if self._showInventory == true then bool = true end
	if self._showLog == true then bool = true end
	return bool
end

function interface:_closeLog( )
	self._showLog = false
end
function interface:update( )
	if self._showInventory == true then
		self._inventoryBg:setPos(0, 12)
		element.gui:setFocus(self._inventoryBg)
	else
		self._inventoryBg:setPos(-110, 0)
	end

	if self._showLog == true then
		self._logBG:setPos(0, 15)
	else
		self._logBG:setPos(0, -100)
	end
	self:doAttackAnim( )
	self:updateAffinities( )
	local stats = player:returnPlayerStats( )
	self._statsLabel:setText("Health: "..stats.hp.."/"..stats.initial_health+stats.healthModifier.." | Carry: "..self._inventoryBurdenMax.." / "..self._maxWeightToCarry.."")
	----print("POINTER TAB: "..self._pointerTab.." Pos: "..self._pointerPos.."")
	if stats.hp < stats.initial_health/4 then
		Game.lightFactor = 2.5
	elseif stats.hp < stats.initial_health/3 then
		Game.lightFactor = 2
	elseif stats.hp < stats.initial_health/2 then
		Game.lightFactor = 1.5
	elseif stats.hp < stats.initial_health/1.5 then
		Game.lightFactor = 1
	elseif stats.hp < stats.initial_health/1.25 then
		Game.lightFactor = 0.5
	else
		Game.lightFactor = 0
	end
	element.gui:setFocus(self._inventoryBg)
end


function interface:debugTesting( )
	--
	local rows = 2
	local nrLabels = 10
	topTextLabel = element.gui:createLabel( )
	topTextLabel:setDim(100, 4)
	topTextLabel:setPos(1, 5)

	textstyles.update("default", 14, 14)
	textstyles.update("stats", 24, 14)
	topTextLabel:setTextStyle(textstyles.get("stats"), 54)
	topTextLabel:setText("<c:FFFF00>*-</c><c:FFF>Inventory</c><c:FFFF00>------------------------------*</c>")

	for i = 1, 10 do
		local label = element.gui:createLabel( )
		label:setDim(100, 5)
		label:setPos(2, 5*i)
		self._inventoryBg:addChild(label)
		label:setText(""..itemFakeLabel[i].."")
	end
end

function interface:updateFPS( )
	--FRAME = MOAISim.getPerformance ()
	--self._fpsCounter:setText(""..math.floor(FRAME) .."")
end

function interface:setDefeatState(_state)
	self._tweenDefeat = _state
end

--[[
			BACKUP
function interface:pushLogMessage(_string)
	-- first, get the log table and it's size
	local logTable = log:getLogTable( )
	local logTableSize = #logTable

	-- for every message in the log table, create a new string (max of 4 strings)
	self:destroyLog( )

	local idx = 0
	self._logStringTable = { }
	if logTableSize < 4 then
		for i,v in ipairs(logTable) do
			local logString = element.gui:createLabel( )
			self._blackBG:addChild(logString)
			logString:setDim(100, 4)
			logString:setPos(0,idx*4-idx)
			logString:setText(" <c:FFF>"..v.content.."</c>")
			logString:setTextStyle(textstyles.get("log"), 54)
			----print("LOG SIZE I: "..i.."")
			table.insert(self._logStringTable, logString)
			idx = idx + 1
		end
	else
		for i,v in ipairs(logTable) do
			if i >= logTableSize-3 then
				local logString = element.gui:createLabel( )
				self._blackBG:addChild(logString)
				logString:setDim(100, 4)
				logString:setPos(0,idx*4-idx)
				logString:setText(" <c:FFF>"..v.content.."</c>")
				logString:setTextStyle(textstyles.get("log"), 54)
				----print("LOG SIZE I: "..i.."")
				table.insert(self._logStringTable, logString)
				idx = idx + 1
			end
		end
	end
	local v = log:getLogTable( )[#log:getLogTable()]
	self._logTextBox:addText(""..v.content.."")
	self._logTextBox:newLine( )
	self._logTextBox:_setScrollToDown( )
	self._logTextBox:_setTextStyle("logTextBox")
	--interface:updateFullLog( )
end

]]

function interface:_clearAndBurnTheLog( )
	if self._logStringTable ~= nil then
		for j = 1, #self._logStringTable+1 do
			for i,v in ipairs(self._logStringTable) do
				v:destroy( )
				table.remove(self._logStringTable, i)
			end
		end
	end

	if self._logTableLabels ~= nil then
		for j = 1, #self._logTableLabels+1 do
			for i,v in ipairs(self._logTableLabels) do
				v:destroy( )
				table.remove(self._logTableLabels, i)
			end
		end
	end

	log:RESET_LOG_TABLE( )
end

function interface:pushLogMessage(_string)
	--[[local text = self._logLabel:getText( )
	self._logLabel:addText(""..text.." <c:FFF>".._string.."</c>")--]]
	-- first, get the log table and it's size
	local logTable = log:getLogTable( )
	local logTableSize = #logTable

	--[[if logTableSize > 60 then
		log:RESET_LOG_TABLE( )
		logTable = log:getLogTable( )
		logTableSize = #logTable
	end--]]
	self:destroyLog( )

	local idx = 0
	self._logStringTable = { }
	if logTableSize < 4 then
		for i,v in ipairs(logTable) do
			local logString = element.gui:createLabel( )
			self._blackBG:addChild(logString)
			logString:setDim(100, 4)
			logString:setPos(0,3+idx*4-idx)
			logString:setText(" <c:a9a9a9>"..v.content.."</c>")
			logString:setTextStyle(textstyles.get("log"), 54)
			table.insert(self._logStringTable, logString)
			idx = idx + 1
			table.insert(self._logTableLabels, logString)
		end
	else
		for i,v in ipairs(logTable) do
			if i >= logTableSize-3 then
				local logString = element.gui:createLabel( )
				self._blackBG:addChild(logString)
				logString:setDim(100, 4)
				logString:setPos(0,3+idx*4-idx)
				logString:setText(" <c:a9a9a9>"..v.content.."</c>")
				logString:setTextStyle(textstyles.get("log"), 54)
				table.insert(self._logStringTable, logString)
				idx = idx + 1
				table.insert(self._logTableLabels, logString)
			end
		end
	end
	--interface:updateLogDispaly(logTableSize)
end

function interface:_push40Messages( )
	--[[for i = 1, 40 do
		log:newMessage("Message NR: "..i.."")
	end--]]
end

function interface:updateLogDispaly(_logTableSize)
	local displayLines = 16
	local logSize = #log:getLogTable( )
	if logSize > displayLines then
		self._logTextBox:_clear( )
		start = logSize - displayLines - self._logPointer
		if start <= 1 then
			start = 1
		end
		for i = start, logSize - self._logPointer  do
			local v = log:getLogTable( )[i]
			self._logTextBox:addText(""..v.content.."")
			self._logTextBox:newLine( )
			self._logTextBox:_setScrollToDown( )
			self._logTextBox:_setTextStyle("logTextBox")
		end
	else
		local v = log:getLogTable( )[logSize]
		if v ~= nil then
			self._logTextBox:addText(""..v.content.."")
			self._logTextBox:newLine( )
			self._logTextBox:_setScrollToDown( )
			self._logTextBox:_setTextStyle("logTextBox")
		end
	end
end

function interface:_increaseLogPointer( )
	local displayLines = 16
	--local logTableSize = #log:getLogTable( )
	if self._logPointer < #log:getLogTable( )-displayLines then
		self._logPointer = self._logPointer + 1
		interface:updateLogDispaly(logTableSize)
	end
	
end

function interface:_decreaseLogPointer( )
	--local logTableSize = #log:getLogTable( )
	if self._logPointer - 1 > 0 then
		self._logPointer = self._logPointer - 1
		interface:updateLogDispaly(logTableSize)
	end
	
end
function interface:destroyLog( )
	-- for every message in the log table, create a new string (max of 4 strings)
	for i = 1, #self._logStringTable do
		self._logStringTable[i]:destroy( )
	end
end

function interface:appendLogMessage(_string)

end


function _handleQuitToMM( )

end

function interface:destroyLogTableStrings( )
	for i,v in ipairs(self._logTableLabels) do
		v:destroy()
	end
end



function interface:destroyUI ( )
	self._showLog = false
	self._logBG:setPos(0, -100)
	self._logTextBox:destroy( )


	self:saveInventory( )
	self:_clearAndBurnTheLog( )
	self:destroyLog( )
	self:destroyLogTableStrings( )
	self._logLabel:destroy( )
	self._logTextBox:destroy( )
	self._logBG:destroy( )
	--self._fpsCounter:destroy( )
	self._inventoryBg:destroy( )
	self._blackBG:destroy( )
	self._gameOverScreen:destroy( )
	self._itemNameLabel:destroy( )
	self._itemDamageLabel:destroy( )
	self._itemMultiplierLabel:destroy( )
	self._itemDefenseLabel:destroy( )
	self._itemArcaneDefenseLabel:destroy( )
	self._itemValueLabel:destroy( )
	self._descriptionTextBox:_clear( )
	self._descriptionTextBox:destroy( )
	
end

function interface:pushKeyInfo( )
	log:newMessage("Movement: <c:9FC43A>W A S D</c> | Camera turn: <c:9FC43A>Q</c> | <c:9FC43A>E</c>")
	log:newMessage("Actions: <c:9FC43A>O</c>pen, <c:9FC43A>P</c>ickup, <c:9FC43A>I</c>nventory, <c:9FC43A>V</c>iew")
	log:newMessage("<c:9FC43A>I</c>nventory: <c:9FC43A>T</c>hrow, (<c:9FC43A>P</c>)Drop, (<c:9FC43A>Space</c>)Use/Equip")
end