local textstyles = require "gui/textstyles"

function interface:setupMainMenu( )
	sound:stopAll( )

	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("ggMM.lua"), "")
	local g = element.gui

	self._mmBackground = widgets.backGround.window
	self._mmOptionpanel = widgets.mmBackPanel.window

	self._mmButtonTable = {}
	self._mmButtonText = {}
	self._mmButtonText[1] = "NEW GAME"
	self._mmButtonText[2] = "LOAD SAVED RUN"
	self._mmButtonText[3] = "SHOW HIGHSCORES"
	self._mmButtonText[4] = "HELP"
	self._mmButtonText[5] = "EXIT"

	self._mmIDX = 1
	self:_mmAddButtons( )
	self:_mmIncPointer( )
	self:_mmDecPointer( )

	sound:play(Game.mainMenuSound)
	

	interface:createTower( )

	
end

function interface:createMMCamera( )
	camera = MOAICamera.new ()
	camera:setLoc ( 0, 0, camera:getFocalLength ( 360 ))
	core:returnLayer(2):setCamera ( camera )
	core:returnLayer(1):setCamera( camera )
	core:returnLayer(g_Ui_Layer):setCamera(camera)
	camera:setOrtho(false)
	camera:setFieldOfView (FOVNORMAL)

	self._cameraX = 50/2*100
	self._cameraY = 7500
	self._cameraZ = 50/2*100

	self._cameraPos = { }
	self._cameraPos[1] = { self._cameraX, self._cameraY, self._cameraZ, 0 }
	self._cameraPos[2] = { self._cameraX, self._cameraY, self._cameraZ, self._cameraRotY }

	self._cameraRotY = 0
	self._cameraRotX = -90
	self._cameraRotZ = 0

	self._cameraStepAngle = 90

	self._orientation = 1

	--camera:setRot(self._cameraRotX, self._cameraRotY, self._cameraRotZ, 0.5)
	camera:setLoc(3500, 200, 4000, 0.5)
end

function interface:createTower( )
	if self._towerGenerated  == false then
		self:createMMCamera( )
		self._mapWidth = 70
		self._mapHeight = 50
		--local tiles = generator:CellToTiles( dungeon )

		self._mainMapLayer = 1
		self._blockSize = 100

		self._grassObjectList = { }
		self._towerBricksList = { }
		self._treeList = { }

		local grassTile = makeCube( 100, "tiles/Menu/grass2.png" )
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

		self._map = map

		-- create the central tower
		self:createCircleTower(35,25, 4)

			-- place some ripstones
		local nrStones = 60
		ripMesh = makeBox(100, 100, 0, "tiles/Menu/Tree0.png")
		treeMesh2 = makeBox(100, 100, 0, "tiles/Menu/Tree1.png")

		meshList = {}
		meshList[1] = ripMesh
		meshList[2] = treeMesh2
		core:setSordMode(1, MOAILayer.SORT_Z_ASCENDING)
		--[[for i = 1, nrStones do
			 image:new3DImage(ripMesh, math.random(10, 70)*100, 100, math.random(0, 40)*100, self._mainMapLayer)
		end--]]
		for x = 20, 60 do
			for y = 10, 38 do
				if(y > 25 and y < 30) then
					if(x < 35 or x > 40) then
						if math.random(1, 6) == 2 then
							gfx = image:new3DImage(meshList[math.random(1,2)], x*100, 100, y*100, self._mainMapLayer)
							table.insert(self._treeList, gfx)
						end
					end
				else
					if math.random(1, 6) == 2 then
						gfx = image:new3DImage(meshList[math.random(1,2)], x*100, 100, y*100, self._mainMapLayer)
						table.insert(self._treeList, gfx)
					end
				end
			end
		end
		self._towerGenerated = true
	end
end

function interface:resetTowerMenuFlag( )
	self._towerGenerated = false
end

function interface:circleTowerUpdate( )
	if(self._skyTileBg ~= nil) then

		if self._rotAngle < 360 then
			self._rotAngle = self._rotAngle + 0.05
		else
			self._rotAngle = 0
		end
		if(self._skyTileBg ~= nil) then
			image:setRot3D(self._skyTileBg, 0, self._rotAngle, 0)
		end

	end


end

function interface:createCircleTower(centerX, centerY, radius)

		local wallTile = makeCube( 100, "tiles/Menu/wall.png" )
		wallTable = { }
		wallTable[1] = makeCube( 100, "tiles/Menu/wall.png" )
        wallTable[2] = makeCube( 100, "tiles/Menu/wall2.png" )
        wallTable[3] = makeCube( 100, "tiles/Menu/brick_1.png" )
        wallTable[4] = makeBox(100, 100, 0, "tiles/Menu/window.png" )

        baseLevel = makeCube(100, "tiles/Menu/brick_1.png")
        local height = 100
        local radStep = 1/(1.5*radius)
        local towerLevels = 40
        for k = 0, towerLevels do
	        for angle = 1, math.pi+radStep, radStep do
	            local pX = math.cos( angle ) * radius * 1.5
	            local pY = math.sin( angle ) * radius
	            for i=-1,1,2 do
	                for j=-1,1,2 do
	                	if(k < 2) then
	                		 gfx = image:new3DImage(baseLevel, (centerX +  i*pX+math.random(0.0,0.2))*self._blockSize, k*height,(centerY + j*pY)*self._blockSize, self._mainMapLayer)
	                		 table.insert(self._towerBricksList, gfx)
	                			-- 
	                	elseif (k >= 2 and k < 4) then
	                		if math.random(1, 4) ~= 2 then
	                			gfx = image:new3DImage(baseLevel, (centerX +  i*pX+math.random(0.0,0.2))*self._blockSize, k*height,(centerY + j*pY)*self._blockSize, self._mainMapLayer)
	                			table.insert(self._towerBricksList, gfx)
	                		else
		                		local walLRND = math.random(1, #wallTable)
		                     	gfx = image:new3DImage(wallTable[walLRND], (centerX +  i*pX+math.random(0.0,0.2))*self._blockSize, k*height,(centerY + j*pY)*self._blockSize, self._mainMapLayer) 
		                      	table.insert(self._towerBricksList, gfx)
	                		end
	                	else
		                	if math.random(1, 6) ~= 2 then
		                		local walLRND = math.random(1, #wallTable)
		                        gfx = image:new3DImage(wallTable[walLRND], (centerX +  i*pX+math.random(0.0,0.2))*self._blockSize, k*height,(centerY + j*pY)*self._blockSize, self._mainMapLayer) 
		                        table.insert(self._towerBricksList, gfx)
		                    end
	                	end

	                end
	            end
	        end
	    end

	    -- make the sky
	    local skyTile = makeCube(-10000, "tiles/Menu/sky_backdrop.png")
	    self._skyTileBg = image:new3DImage(skyTile, 4000, 0, 0, self._mainMapLayer) 
	    self._rotAngle = 0

end

function interface:_mmAddButtons( )
	local buttonTableSz = #self._mmButtonText
	for i = 1, buttonTableSz do
		local temp = {
			id = i,
			label = element.gui:createLabel( ),
		}
		temp.label:setDim(25, 4)
		temp.label:setPos(12, 8.5+i*4-4)
		temp.label:setText(""..self._mmButtonText[i].."")
		temp.label:setTextStyle(textstyles.get("mmButtonUnselected"))
		self._mmOptionpanel:addChild(temp.label)
		table.insert(self._mmButtonTable, temp)
	end
end

function interface:_updateMmButtons( )
	local idx = self._mmIDX
	self:_resetMMButtonsColor(idx)
end

function interface:_resetMMButtonsColor(_idx)
	for i,v in ipairs(self._mmButtonTable) do
		local text_style = "mmButtonUnselected"
		local precSymbol = ""
		local surSymbol = ""
		if i == _idx then
			text_style = "mmButtonSelected"
			precSymbol = "<"
			surSymbol = ">"
		end
		
		v.label:setText(""..precSymbol.." "..self._mmButtonText[i].." "..surSymbol.."")
		v.label:setTextStyle(textstyles.get(""..text_style..""))
	end
end

function interface:_updateMainMenu( )

end

function interface:_mmIncPointer( )
	sound:play(Game.uiSwitch)
	self._mmIDX = self._mmIDX + 1
	local btnTableSize = #self._mmButtonText
	if self._mmIDX > btnTableSize then
		self._mmIDX = btnTableSize
	end
	self:_updateMmButtons( )
end

function interface:_mmDecPointer( )
	sound:play(Game.uiSwitch)
	self._mmIDX = self._mmIDX - 1
	if self._mmIDX < 1 then
		self._mmIDX = 1
	end
	self:_updateMmButtons( )
end

function interface:_mmKeyPressed(key)

	if key == 119 then -- W
		self:_mmDecPointer( )
	elseif key == 115 then -- S
		self:_mmIncPointer( )
	end

	if key == 32 then -- YO! Space to confirm
		if self._mmIDX == 1 then
			self:_destroyMainMenu( )
			self:_mmGoToGame( )
		elseif self._mmIDX == 2 then

		elseif self._mmIDX == 3 then
			self:_mmGoToHighScore( )
		elseif self._mmIDX == 4 then
			interface:_mmGoToHelp( )
		elseif self._mmIDX == 5 then
			os.exit( )
		end
	end

end

function interface:_destroyMainMenu( )
	for i,v in ipairs(self._mmButtonTable) do
		v.label:destroy( )
	end
	self._mmOptionpanel:destroy( )
	self._mmBackground:destroy( )
	
end

function interface:_mmGoToGame( )

	_bGameLoaded = false
	_bGuiLoaded = false	
	currentState = 19
end

function interface:_mmGoToHighScore( )
	self:_destroyMainMenu( )
	_bGameLoaded = false
	_bGuiLoaded = false	
	currentState = 20
end

function interface:_mmGoToHelp( )
	self:_destroyMainMenu( )
	_bGameLoaded = false
	_bGuiLoaded = false	
	currentState = 21
end

------------------------------------------------------
------------------- SETUP CLASS SCREEN ---------------
------------------------------------------------------

function interface:setupClassScreen( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("ggClassSel.lua"), "")
	local g = element.gui

--[[
classPanel
classDescription
]]
	self._classBg = widgets.backGround.window
	self._classPanel = widgets.classPanel.window
	self._classDescription = widgets.classDescription.window	

	self._idx = 1

	self._classButtonTable = { }
	self._classButtonText = { }
	self._classButtonText[1] = "Berserker"
	self._classButtonText[2] = "Night Shade"
	self._classButtonText[3] = "Scroll Mage"

	self._classDash = { }
	self._classDash[1] = "--"
	self._classDash[2] = "----"
	self._classDash[3] = "----"

	self:_classSetupClassesMenu( )
	self:_classSetupDescriptionMenu( )
	self:_createClassDescriptions( )
	self:_clsIncPointer( )
	self:_clsDecPointer( )
	
end

function interface:_createClassDescriptions( )
	self._classTable = { }

	self._classTable[1] = { 
		" The mighty berserker is known for his",
		" endurance and ruthlessness. Armed with ",
		" nothing but a sword and courage he",
		" hacks away at unsuspecting creatures and ",
		" foes alike. The berserker starts with: ",
		" - 1X Iron Sword",
		" - 1X Leather Armor",
		" ",
	} -- programmer

	self._classTable[2] = { 
		" The Night Shade cares not about the road",
		" or destination. Their only goal is to",
		" wreak havok uppon creation and probe it",
		" for any flaws he might be able to ",
		" exploit! Night Shade starts with: ",
		" - 3X Throwing Dagger",
		" - 1X Potion of Darkness",
		" - 2X Potion of Teleportation",
	} -- programmer

	self._classTable[3] = { 
		" The Scroll Mage is an odd and versatile",
		" fellow. He is not an innate caster and",
		" as such cannot cast magic by",
		" regular means. Instead he relies on",
		" Magic imbued items. The Scroll mage starts",
		" with the following items:",
		" - 2X Scroll of Magic Missile",
		" - 1X Scroll of Discharge",
		" - 1X Small Potion of Health",
	} -- programmer
	self._classInventory = { }
	self._classInventory[1] = {
		4,
		{49, 6},

	}
	self._classInventory[2] = {
		51,
		51,
		51,
		1,
		52,
		52,
	}
	self._classInventory[3] = {
		17,
		17,
		15,
		13,

	}	

--[[
		weaponAffinity = 0.4,
		spellAtunement = { },
		spellKnowdlege = 1,
		initial_health = 20,
		hp = 20,

]]
	self._classStats = { }
	self._classStats[1] = {
		weaponAffinity = 0.7,
		spellKnowdlege = 0.2,
		initial_health = 40,
		hp = 40,
	}
	self._classStats[2] = {
		weaponAffinity = 0.4,
		spellKnowdlege = 0.4,
		initial_health = 38,
		hp = 38,
	}
	self._classStats[3] = {
		weaponAffinity = 2.3,
		spellKnowdlege = 1.8,
		initial_health = 44,
		hp = 44,
	}
end

function interface:_classSetupDescriptionMenu( )
	self._headerLabel = element.gui:createLabel( )
	self._headerLabel:setDim(500, 4)
	self._headerLabel:setPos(1, 2)
	self._headerLabel:setText("--- "..self._classButtonText[self._idx].." --------------------"..self._classDash[self._idx].."")
	self._headerLabel:setTextStyle(textstyles.get("mmButtonSelected"))
	self._classDescription:addChild(self._headerLabel)

	--- Now the text box (eww)
	self._descriptionTextBox = element.gui:createTextBox( )
	self._descriptionTextBox:setDim(50, 40)
	self._descriptionTextBox:setPos(1, 10)
	self._descriptionTextBox:addText("Lorem ipsum doloret sit amet ")
	self._descriptionTextBox:setLineHeight(4)
	self._descriptionTextBox:_setTextStyle("mmButtonUnselected")
	self._classDescription:addChild(self._descriptionTextBox)
end

function interface:_classSetupClassesMenu( )
	local clsBttnTextSz = #self._classButtonText
	for i = 1, clsBttnTextSz do
		local temp = {
			id = i,
			label = element.gui:createLabel( ),
		}
		temp.label:setDim(25, 4)
		temp.label:setPos(2, 5+i*4-4)
		temp.label:setText(""..self._classButtonText[i].."")
		temp.label:setTextStyle(textstyles.get("mmButtonUnselected"))
		self._classPanel:addChild(temp.label)
		table.insert(self._classButtonTable, temp)
	end	
end

function interface:_updateClassDescription(_idx)
	self._descriptionTextBox:_clear( )
	for i = 1, #self._classTable[_idx] do
		self._descriptionTextBox:addText(""..self._classTable[_idx][i].."")
		self._descriptionTextBox:newLine( )
	end

	self._descriptionTextBox:_setTextStyle("mmButtonUnselected")
end

function interface:_updateClsButtons( )
	local idx = self._idx
	self:_resetClsButtonsColor(idx)
	self:_updateClassDescription(idx)
end

function interface:_resetClsButtonsColor(_idx)
	self._headerLabel:setText("--- "..self._classButtonText[_idx].." --------------------"..self._classDash[self._idx].."")
	for i,v in ipairs(self._classButtonTable) do
		local text_style = "mmButtonUnselected"
		local precSymbol = ""
		local surSymbol = ""
		if i == _idx then
			text_style = "mmButtonSelected"
			precSymbol = "<"
			surSymbol = ">"
		end
		
		v.label:setText(""..precSymbol.." "..self._classButtonText[i].." "..surSymbol.."")
		v.label:setTextStyle(textstyles.get(""..text_style..""))
	end
end


function interface:_clsDecPointer( )
	sound:play(Game.uiSwitch)
	self._idx = self._idx - 1
	if self._idx < 1 then
		self._idx = 1
	end
	self:_updateClsButtons( )
end

function interface:_clsIncPointer( )
	sound:play(Game.uiSwitch)
	self._idx = self._idx + 1
	local btnTableSize = #self._classButtonText
	if self._idx > btnTableSize then
		self._idx = btnTableSize
	end
	self:_updateClsButtons( )
end

function interface:_classKeyPressed( key )

	if key == 119 then -- W
		self:_clsDecPointer( )
	elseif key == 115 then -- S
		self:_clsIncPointer( )
	end

	if key == 27 then
		self:_classMenuGoTMainMenu( )
	end

	if key == 32 then -- YO! Space to confirm
		if self._idx == 1 then
			self:_classMenuGoToGame( )
		elseif self._idx == 2 then
			self:_classMenuGoToGame( )
		elseif self._idx == 3 then
			self:_classMenuGoToGame( )
		end
	end

end

function interface:_destroyClassMenu( )
	for i,v in ipairs(self._classButtonTable) do
		v.label:destroy( )
	end
	self._classPanel:destroy( )
	self._classDescription:destroy( )
	self._classBg:destroy( )

	--self._towerBricksList 
	-- self._treeList
	for i = 1, #self._towerBricksList do
		image:removeProp(self._towerBricksList[i], self._mainMapLayer)
	end

	for i = 1, #self._treeList do
		image:removeProp(self._treeList[i], self._mainMapLayer)
	end

	for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
			image:removeProp(self._map[x][y].floor, self._mainMapLayer)
			self._map[x][y].floor = nil
		end
	end

	image:removeProp( self._skyTileBg, self._mainMapLayer);
	self._skyTileBg = nil
	self._towerGenerated = false
end

function interface:_classMenuGoToGame( )
	if self._idx > #self._classButtonTable then self._idx = self._classButtonTable end
	Game.classOptions[1] = self._classInventory[self._idx] -- inventory
	Game.classOptions[2] =  self._classStats[self._idx] -- modifiers player stats
	self:_destroyClassMenu( )
	_bGameLoaded = false
	_bGuiLoaded = false	
	currentState = 14
end

function interface:_classMenuGoTMainMenu( )
	self:_destroyClassMenu( )
	_bGameLoaded = false
	_bGuiLoaded = false	
	currentState = 2
end

--self._classInventory


-----------------------------------------------------------------------
--- Highscore stuff ---------------------------------------------------
-----------------------------------------------------------------------

-----------------------------------------------------------------------
--- Highscore stuff ---------------------------------------------------
-----------------------------------------------------------------------

function interface:_initHighScore( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("highscore.lua"), "")
	local g = element.gui
	self._highScoreBg = widgets.backGround.window

	self._highScoreTable = self:_loadScore( )
	if self._highScoreTable == nil then
		self._highScoreTable = { }
	end

	self._scrollIDX = 1

	self:_initHallOfFameTitle( )
	self:_initHighScoreTable( )
end

function interface:_initHallOfFameTitle( )
	self._hallTitle = element.gui:createLabel( )
	self._hallTitle:setDim(300, 4)
	self._hallTitle:setPos(0, 0)
	self._hallTitle:setText("############################## HALL OF FAME #################################")
	self._hallTitle:setTextStyle(textstyles.get("mmButtonSelected"))
	self._highScoreBg:addChild(self._hallTitle)

	self._infoLabel = element.gui:createLabel( )
	self._infoLabel:setDim(300, 4)
	self._infoLabel:setPos(2, 94)
	self._infoLabel:setText("Use <c:FFFFFF>W</c> and <c:FFFFFF>S</c> to scroll up and down. <c:FFFFFF>ESC</c> to return to Main Menu.")
	self._infoLabel:setTextStyle(textstyles.get("mmButtonSelected"))
	self._highScoreBg:addChild(self._infoLabel)
end

function interface:_initHighScoreTable( )
	--[[
	self._descriptionTextBox:setDim(50, 40)
	self._descriptionTextBox:setPos(1, 10)
	self._descriptionTextBox:addText("Lorem ipsum doloret sit amet ")
	self._descriptionTextBox:setLineHeight(4)
	self._descriptionTextBox:_setTextStyle("mmButtonUnselected")
	self._classDescription:addChild(self._descriptionTextBox)

	]]


	--local tbToFill = self:_loadScore( )
	--print("TB TO FILL TYPE: "..type(tbToFill).."")
	--local tempTable = tbToFill
	--[[if tbToFill == nil then
		tbToFill = { }
		tempTable = {
			name = "Zapa",
			turns = 50210,
			lvDeath = "lv4",
			killedBy = "Eye of the Building Manager",
			score = 51252,
			valuableItem = "Artefact of Power",

		}

		table.insert(tbToFill, tempTable)
		self:_addScore(tbToFill)
	end--]]
 	
--[[
	Game.scoreTable = {
		id = 1,
		name = "Zapa",
		turns = 0,
		lvDeath = "lv4",
		killedBy = "Test",
		score = 5215215,
		valuableItem = "Artefact Name",
	}

]]

	--self:_scoreBoxAddContent( )
	--self:_addScore(tbToFill)
	self._highScoreTextBox = element.gui:createTextBox( )
	self._highScoreTextBox:setDim(90, 80)
	self._highScoreTextBox:setPos(5, 10)
	self._highScoreTextBox:setLineHeight(4)
	self._highScoreBg:addChild(self._highScoreTextBox)

	self._highScoreTextBox:addText("#Run     | Score     | The gory details....    ")
	self._highScoreTextBox:newLine()
	self._highScoreTextBox:_setTextStyle("mmButtonUnselected")
	self._highScoreTable = { }

	
	local bool = file_exists("HighScore.yasd")
	if bool == true then
		print("INIT : FILE EXISTS ::::::::::::::::::::::::::::::")
--		self._highScoreTable = self:_loadScore( )
		local unsortedHighScoreTable = self:_loadScore( )
		self._highScoreTable = { }

		for i, j in spairs(unsortedHighScoreTable, function(t,a,b) return t[b].score < t[a].score end) do
			j.id = i
			table.insert(self._highScoreTable, j)
		end
		----self._addScore(self._highScoreTable)
		if self._highScoreTable == nil then
			print("PROBLEM IN HIGHSCORE :( ")
		else
			print("HIGHSCORE OK! SIZE: "..#self._highScoreTable.."")
		end
		self:_scoreBoxAddContent( )
	end

end

function interface:_addScore(_table)
	print("IN ADD SCORE")
	for i,v in ipairs(_table) do
		print("ADDING SCORE: "..i.."")
		local temp = { 
			id = #self._highScoreTable+1,
			score = v.score,
			textLine1 = "<c:9FC43A>"..v.name.."</c> died on "..v.lvDeath..". He survived for "..v.turns.." turns.",
			textLine2 = "His most valauble item was: "..v.valuableItem..".",
			textLine3 = "He was killed by a <c:0B5E87>"..v.killedBy.."</c>.",
			turns = v.turns,
			name = v.name,
			lvDeath = v.lvDeath,
			killedBy = v.killedBy,
			valuableItem = v.valuableItem,
		}

		table.insert(self._highScoreTable, temp)
		print("SCORE ADDED! ")

	end

end

function interface:_scoreBoxAddContent( )
	
	for i,v in ipairs(self._highScoreTable) do
		-- now, update the text box
		print("I: "..i.."")
		self._highScoreTextBox:newLine( )
		local posText = ""..v.id.."       |"
		local scoreText = "   "..v.score.."     |"
		local contentText = "  "..v.textLine1.."\n"..v.textLine2.."\n"..v.textLine3..""
		self._highScoreTextBox:addText(""..posText..""..scoreText..""..contentText.."")
		self._highScoreTextBox:newLine()
		self._highScoreTextBox:addText("____________________________________________________________")
		self._highScoreTextBox:_setTextStyle("mmButtonUnselected")
	end

end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
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

function interface:_exportScore(_table)
	print("IN EXPORT :(")
	local bool = file_exists("HighScore.yasd")
	if bool == true then
		print("THE FILE EXISTS")
		--self._highScoreTable = table.load("HighScore.yasd")
		self._highScoreTable = { }
		local unsortedHighScoreTable = table.load("HighScore.yasd")

		for i, j in spairs(unsortedHighScoreTable, function(t,a,b) return t[b].score < t[a].score end) do
			j.id = i
			table.insert(self._highScoreTable, j)
		end
		self:_addScore(_table)
		os.remove("HighScore.yasd")
		print("SAVING EDITS")
		table.save(self._highScoreTable, "HighScore.yasd")
		print("SAVED")
	else
		print("WE GOT HERE :(")
		self._highScoreTable = { }
		for i,v in ipairs(_table) do
			print("I :" ..i.." type v: "..type(v).."")
		end
		self:_addScore(_table)
		table.save(self._highScoreTable, "HighScore.yasd")
	end
end

function interface:_loadScore( )
	local tb = table.load("HighScore.yasd")
	return tb
end

function interface:_increaseScrollIDX( )
	sound:play(Game.uiSwitch)
	local pageSize = math.floor(self._highScoreTextBox:_getNumItem( )/4)
	self._scrollIDX = self._scrollIDX + pageSize
	if self._scrollIDX > self._highScoreTextBox:_getNumItem( )-4 then 
		self._scrollIDX = self._highScoreTextBox:_getNumItem( )-4
	end
	self._highScoreTextBox:_setCurItem(self._scrollIDX)
	self._highScoreTextBox:_displayLines()
	print("====== INC ======================")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._highScoreTextBox:_getNumItem( ).."")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._highScoreTextBox:_getNumItem( ).."")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._highScoreTextBox:_getNumItem( ).."")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._highScoreTextBox:_getNumItem( ).."")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._highScoreTextBox:_getNumItem( ).."")
	print("====== END INC ==================")
end

function interface:_decreaseScrollIDX( )
	sound:play(Game.uiSwitch)
	local pageSize = math.floor(self._highScoreTextBox:_getNumItem( )/4)
	self._scrollIDX = self._scrollIDX - pageSize
	if self._scrollIDX < 1 then self._scrollIDX = 1 end
	self._highScoreTextBox:_setCurItem(self._scrollIDX)
	self._highScoreTextBox:_displayLines()

end

function interface:_highScoreKeyPressed( key )

	-- scroll up and down :)
	if key == 119 then -- W
		self:_decreaseScrollIDX( )
	elseif key == 115 then --s
		self:_increaseScrollIDX( )
	end


	if key == 13 or key == 27 then
		self:_returnToMainMenu( )
	end
end

function interface:_returnToMainMenu( )
	self._highScoreBg:destroy( )
	_bGameLoaded = false
	_bGuiLoaded = false	
	currentState = 2
end


-----------------------------------------------------------------------
--- Help Menu Stuff ---------------------------------------------------
-----------------------------------------------------------------------
function interface:_initHelpMenu( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("highscore.lua"), "")
	local g = element.gui
	self._menuBG = widgets.backGround.window



	self._scrollIDX = 1

	self:_initHelpTitle( )
	self:_createHelpTextBox( )
end

function interface:_createHelpTextBox( )
	self._bgTextBox = element.gui:createImage( )
	self._bgTextBox:setDim(90, 80)
	self._bgTextBox:setPos(5, 10)
	self._bgTextBox:setImage(resources.getPath("../gui/ggMM/bg_ui_option.png"), 1, 1, 1, 1)
	self._menuBG:addChild(self._bgTextBox)	

	self._helpTextBox = element.gui:createTextBox( )
	self._helpTextBox:setDim(90, 80)
	self._helpTextBox:setPos(0, 0)
	self._helpTextBox:setLineHeight(4)
	self._menuBG:addChild(self._helpTextBox)	
	self._helpTextBox:_setTextStyle("mmButtonUnselected")
	self._bgTextBox:addChild(self._helpTextBox)

	self:_createHelpText( )
end

--[[

**ES:Heresy** is a **first person roguelike** in which the player (a **berserker**, **night shade** or **scroll mage**) invades the *sacred tower* of *Dae'eria*, 
the *Ebony Spire*, in an attempt to slay the fervent goddess! 
The player has to climb up all 10 tower levels to reach the most sacred of places. 
Each floor contains one or more portals to other realms that the player must visit in order to obtain equipment that can aid him in his quest.
]]
function interface:_createHelpText( )
	self._helpTextBox:addText("<c:9FC43A>Introduction</c>")
	self._helpTextBox:newLine()
	self._helpTextBox:addText("<c:9FC43A>-------------</c>")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("Ebony Spire: Heresy is an all 3D dungeon crawling roguelike")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("for PC (Windows and Linux), that takes inspiration from")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("games such as ADOM and Cardinal Quest. The action")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("takes place inside the Ebony Spire, where you play as a berserker,")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("night shade or a scroll mage. Your goal is to invade the sacred tower" )
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("of Dae'eria, in an attempt to slay the fervent goddess!")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )

	self._helpTextBox:addText("How to play <c:9FC43A>Ebony Spire: Heresy</c>")
	self._helpTextBox:newLine()
	self._helpTextBox:addText("------------------")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )

	self._helpTextBox:addText("Moving in the 3D space is performed with the keyboard.")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("The keys <c:9FC43A>W</c>, <c:9FC43A>A</c>, <c:9FC43A>S</c>, <c:9FC43A>D</c> cause your character to advance ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("one unit forward, left, back or right. The camera")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("can be rotated left or right using the keys <c:9FC43A>Q</c> and <c:9FC43A>E</c>.")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("To attack a creature or another target in melee you need")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("to face it and ”move” towards his spot. Instead of taking his")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("occupied space you will deal damage to that enemy. Damage done")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("is calculated based on your weapon proficiency (+ weapon stats) ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("and the enemies armor. Enemies will try and engage you in melee ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("combat the same as you do, by moving towards your character.")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("To cast a spell press <c:9FC43A>I</c> to bring up the inventory screen. ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("Select the Spell/Scroll/Artifact from your inventory that you want ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("to cast and trigger it using <c:9FC43A> < Space Bar > </c>.")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("Depending on the type of spell you cast it will either:")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("- fly towards where you are facing")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("- affect the character/item one step in front of you")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("- fly outwards in a radius affecting everything in it's path")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("- affect only your character")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )

------------------------- ITEMS ------------------------------------------------------------

	self._helpTextBox:addText("Items are objects (such as weapons, scrolls, armor or food)")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("that can be found on the ground, in storage compartments, dropped by")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("enemies or bought from item vendors. Items found on the ground ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("can be picked up by pressing the key <c:9FC43A> P </c> and accessed")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("from the <c:9FC43A>inventory (key I)</c>. Once the inventory screen is opened, it")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("will display a list with all the items available, split into two parts:")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("- Inventory " )
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("- Equipment " )
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("You can navigate between the items in one screen using <c:9FC43A>W</c> and <c:9FC43A>S</c> and jump through " )
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("the tabs using <c:9FC43A>A</c> and </c>D</c>. You can also drop an item from your inventory by pressing")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("the <c:9FC43A>P</c> key with the inventory screen open. Items can be thrown")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("using the key <c:9FC43A>T</c>. The distance and damage are directly proportional to the ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("thrown object's weight. Some objects (such as potion bottles) will break upon impact.")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )


------------------------- DARKNESS ------------------------------------------------------------
	self._helpTextBox:addText("Patches of 'darkness' are present in every level. They are the manifestation of evil's ") 
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("presence in the world. This patches retreat as you draw near. Those that don't will “blind”")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("the player and make him vulnerable to the creatures that dwell within it (yes, it is possible")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("to die by spending too much time in persistent dark patches).")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )


------------------------- MESSAGE LOG -------------------------------------------------------
	self._helpTextBox:addText("The message log (present in the middle upper part of the screen) conveys information")
	self._helpTextBox:addText("on your character's status and observations. For a full Log press the <c:9FC43A>L</c> key ")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )

	self._helpTextBox:addText("<c:9FC43A> The first level </c> ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("<c:9FC43A>----------------------</c>")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("When you first start the game, via the New Game option, you are ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("of classes which affect your starting gear and stats. Select one of ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("the three options and wait for the level to be generated.")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("Once the level starts you will see the environment around you")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("from a first person perspective. From there on you're free to run")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("through the gauntlet up till you reach level 10 and find the amulet of")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("mobility. The first level is used to familiarize you with the game's")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("concepts and mechanics. Most enemies you will meet on this level can be ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("taken care of lightly and those that can't can be avoided. Spend some")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("time collecting items (scrolls, potions, swords and armor) before")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("moving up to the next, harder, levels. Pickup items with the <c:9FC43A><P></c> key ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("and access the inventory using the <c:9FC43A><I></c> key. At the start of the game")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("your maximum carrying capacity is <c:9FC43A>100</c> stones and your inventory is ")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("limited <c:9FC43A>to a maximum of 23 items</c>. Surpassing any of the two limits won't")
	self._helpTextBox:newLine( )
	self._helpTextBox:addText("allow you to pick up new items.")
	self._helpTextBox:newLine( )
	self._helpTextBox:newLine( )

	self._helpTextBox:_setTextStyle("mmButtonUnselected")
end

function interface:_increaseScrollIDX_HALP( )
	sound:play(Game.uiSwitch)
	local pageSize = math.floor(self._helpTextBox:_getNumItem( )/4)
	self._scrollIDX = self._scrollIDX + pageSize
	if self._scrollIDX > self._helpTextBox:_getNumItem( )-4 then 
		self._scrollIDX = self._helpTextBox:_getNumItem( )-4
	end
	self._helpTextBox:_setCurItem(self._scrollIDX)
	self._helpTextBox:_displayLines()
	print("====== INC ======================")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._helpTextBox:_getNumItem( ).." PAGE SIZE: "..pageSize.."")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._helpTextBox:_getNumItem( ).." PAGE SIZE: "..pageSize.."")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._helpTextBox:_getNumItem( ).." PAGE SIZE: "..pageSize.."")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._helpTextBox:_getNumItem( ).." PAGE SIZE: "..pageSize.."")
	print("SCROLLIDX: "..self._scrollIDX.." NUM ITEMS: "..self._helpTextBox:_getNumItem( ).." PAGE SIZE: "..pageSize.."")
	print("====== END INC ==================")
end

function interface:_decreaseScrollIDX_HALP( )
	sound:play(Game.uiSwitch)
	local pageSize = math.floor(self._helpTextBox:_getNumItem( )/4)
	self._scrollIDX = self._scrollIDX - pageSize
	if self._scrollIDX < 1 then self._scrollIDX = 1 end
	self._helpTextBox:_setCurItem(self._scrollIDX)
	self._helpTextBox:_displayLines()

end


function interface:_initHelpTitle( )
	self._helpTitle = element.gui:createLabel( )
	self._helpTitle:setDim(300, 4)
	self._helpTitle:setPos(0, 0)
	self._helpTitle:setText("<c:9FC43A>############################## In-Game Manual #################################</c>")
	self._helpTitle:setTextStyle(textstyles.get("mmButtonSelected"))
	self._menuBG:addChild(self._helpTitle)

	self._infoHelpLabel = element.gui:createLabel( )
	self._infoHelpLabel:setDim(300, 4)
	self._infoHelpLabel:setPos(2, 94)
	self._infoHelpLabel:setText("<c:9FC43A>Use</c> <c:FFFFFF>W</c> <c:9FC43A>and</c> <c:FFFFFF>S</c> <c:9FC43A>to scroll up and down.</c> <c:FFFFFF>ESC</c> <c:9FC43A>to return to Main Menu.</c>")
	self._infoHelpLabel:setTextStyle(textstyles.get("mmButtonSelected"))
	self._menuBG:addChild(self._infoHelpLabel)
end

function interface:_helpMenuKeyPressed( key )
	if key == 27 then
		self:_helpMenuGoTMainMenu( )
	end
	if key == 119 then -- W
		self:_decreaseScrollIDX_HALP( )
	elseif key == 115 then --s
		self:_increaseScrollIDX_HALP( )
	end
end

function interface:_helpMenuGoTMainMenu( )
	self._infoHelpLabel:destroy( )
	self._helpTitle:destroy( )
	self._menuBG:destroy( )
	_bGameLoaded = false
	_bGuiLoaded = false	
	currentState = 2
end


------------------------------------------------------------------
----------------------- VICTORY SCREEN ---------------------------
------------------------------------------------------------------

function interface:_setupVictoryScreen( )
	local g = element.gui
	self._bgVictoryImage = element.gui:createImage( )
	self._bgVictoryImage:setDim(100, 100)
	self._bgVictoryImage:setPos(0, 0)
	self._bgVictoryImage:setImage(resources.getPath("../gui/ggWin/victory_bg_fake.png"))
	player:exportScore(math.random(200000, 215157))
end

function interface:_victoryGoToMainMenu( )
	self._bgVictoryImage:destroy( )
	self._towerGenerated = false
	_bGameLoaded = false
	_bGuiLoaded = false	
	currentState = 2
end

function interface:_setupVictoryKeyPressed(key)
	if key == 27 then
		self:_victoryGoToMainMenu( )
	end
end