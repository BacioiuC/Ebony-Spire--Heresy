--[[
* The MIT License
* Copyright (C) 2014 Bacioiu "Zapa" Ciprian (bacioiu.ciprian@gmail.com).  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom th be Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]
Game = {} -- MAIN CLASS

Game.modInUse = "infinite_mode" --

Game.permaDeath = true

local Grid = require ("Game.lib.jumper.grid")
-- Calls the pathfinder class
local Pathfinder = require ("Game.lib.jumper.pathfinder")



-------------------------------------------
--------- GAME FILES ----------------------
--------------------------------------------
-- needed to allow images and animations to be loaded from /mods
-- doing this to avoid having to mantain two separate versions of my /Chaurus framework from /core
require "Game.wrapper.wImage"
require "Game.wrapper.wAnim"
require "Game.wrapper.wEffect"

require "Game.include_list"

--- WOOOHOO works!
for i,v in ipairs(includeList) do
	if v ~= "" then
		local prePath = "mods."..Game.modInUse.."."

		if isModuleAvailable(""..prePath..""..v.."") == false then
			prePath = "Game."
			local string = ""..prePath..""..v..""
			require("Game."..v.."")
		else
			--print("GOING FOR MODS")

			local string = ""..prePath..""..v..""
			require(""..prePath..""..v.."")	
		end
	end

end

require "core.StateMachine"
--------------------------------------
---- PATHFINDER INCLUDES -------------
---------------------------------------

require "gui/support/class"

zKey = false


Game.inventorySave = { }
Game.playerStatsSave = { }
Game.dungeoNLevel = 1
Game.classOptions = { }
Game.portalID = 1
Game.favoriteItem = nil
Game.scoreTable = {
	id = 0,
	name = "Sir Zapa-nald",
	turns = 0,
	lvDeath = "",
	killedBy = "",
	score = 0,
	valuableItem = "",
}
Game.lightFactor = 0
Game.score = 0
Game.movement = false
Game.attack = false
Game.Turn = 1
Game.turn = 1
Game.globalUn = nil
Game.targetAcquired = false
Game.disableDock = false
walkable = 0--1073741825--1
Game.levelString = "lv_1"
Game.dungeonType = 1
Game.grid = nil
Game.mapFile = "mirrormantis"
Game.fromEditor = false
_gTouchPressed = false -- global TOUCH PRESSED 
Game.firstTurn = 1
Game.victor = nil
Game.buildingID = nil
Game.iteration = 0
Game.bgColor = {}
Game.bgColor[1] = { r = 0, g = 0.3, b = 0.8 }
Game.bgColor[2] = { r = 0.99, g = 0.2, b = 0.2 }
Game.bgColor[3] = { r = 1, g = 1, b = 1 }
Game._currentScale = 1
Game.wantedScale = 1
Game.oldScale = 1
zoomInProgress = false
Game.disableInteraction = false
Game.masterVolume = 0.9
Game.commander = {}
Game.player1 = "Human"
Game.player2 = "Computer"
Game.lastState = 2
Game.winCondition = 1
Game.tileset = "tileset_ground.png"
Game.victory = false
Game.globalFogOfWar = false
Game.optionControls = { }

Game.cursorX = 5
Game.cursorY = 5
Game.cursorEnabled = false
Game.key = nil
Game.keyTimer = Game.worldTimer
Game.persistantKey = false

Game.optionControls.soundVolume = Game.masterVolume
Game.optionControls.fullScreen = false
Game.isMultiplayer = false
Game.isFullscreen = false
Game.saveSystem = { }
Game.optionSettings = { }
Game.optionSettings.permaDeath = 1
Game.optionSettings.scanLine = 1
Game.optionSettings.infinite_mode = 0
Game.clearFlag = false
Game.levelSeed = nil
Game._LevelsClearFlags = {}
for i = 1, 10 do
	Game._LevelsClearFlags[i] = false
end


function Game:exportOptions(_music, _audio, _perma, _scanLine, _infinite_mode)
	--print("HAPPENING")
	Game.optionSettings.musicLevel = _music
	Game.optionSettings.audioLevel = _audio
	Game.optionSettings.permaDeath = _perma
	Game.optionSettings.scanLine = _scanLine
	Game.optionSettings.infinite_mode = _infinite_mode
	--print("MUSIC: ".._music.." | AUDIO: ".._audio.." Death: ".._perma.."")
	table.save(Game.optionSettings, "settings.lua")
end

function Game:importOptions( )
	local newOptions = table.load("settings.lua")
	if newOptions ~= nil then
		Game.optionSettings.musicLevel = newOptions.musicLevel
		Game.optionSettings.audioLevel = newOptions.audioLevel
		Game.optionSettings.permaDeath = newOptions.permaDeath
		Game.optionSettings.scanLine = newOptions.scanLine
		Game.optionSettings.infinite_mode = newOptions.infinite_mode
		--print("IMPORT ##########")
		--print("MUSIC: "..newOptions.musicLevel.." | AUDIO: "..newOptions.audioLevel.." Death: "..newOptions.permaDeath.."")
	else
		Game.optionSettings.musicLevel = 50
		Game.optionSettings.audioLevel = 25
		Game.optionSettings.permaDeath = 1	
		Game.optionSettings.scanLine = 1	
		Game.optionSettings.infinite_mode = 0	
	end
end



function Game:exportSaveInfo(_portalX, _portalY)
	local saveLevel = 1
	saveLevel = Game.dungeoNLevel 
	Game.saveSystem.level = saveLevel
	Game.saveSystem.playerData = player:returnPlayerStats( )
	Game.saveSystem.inventoryContent = interface:_getInventoryTable( )
	Game.saveSystem.equipmentContent = interface:_getEquipmentTable( )
	local px, py = player:returnPosition( )
	Game.saveSystem.coordinates = { x = px, y = py }
	Game.saveSystem.portalCoordinates = { x = _portalX, y = _portalY}
	Game.saveSystem.clearFlag = Game._LevelsClearFlags
	Game.saveSystem.seed = Game.levelSeed

	print("############################ ################### ############ EXPORTING SAVE")
	table.save(Game.saveSystem, "saves/current_run.lua")
end

function Game:deleteSave( )
	if Game.optionSettings.permaDeath == 1 then
		os.remove("saves/current_run.lua")
	end
end

function Game:importSaveInfo( )
	print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTING SAVE")
	local saveGameData = table.load("saves/current_run.lua")
	if saveGameData ~= nil then
		player.isSleeping = false
		--Game.dungeonType = 1
		player:_setStats(saveGameData.playerData)
		interface:loadInventoryFromSaveGame(saveGameData.inventoryContent)
		interface:loadEquipmentFromSaveGame(saveGameData.equipmentContent)
		if saveGameData.coordinates.x ~= nil and saveGameData.coordinates.y ~= nil then
			player:setPosition(saveGameData.coordinates.x, saveGameData.coordinates.y)
		end

		if saveGameData.coordinates.x ~= nil and saveGameData.coordinates.y ~= nil then
			player:setPosition(saveGameData.portalCoordinates.x, saveGameData.portalCoordinates.y)
		end
		Game.levelSeed = saveGameData.seed
		Game._LevelsClearFlags = saveGameData.clearFlag
		print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORT SUCCESSFULL")
		return Game.levelSeed
	end
	
end

function Game:importDungeonLevel( )
	local saveGameData = table.load("saves/current_run.lua")
	--Game.dungeonType = 1
	Game.dungeoNLevel = saveGameData.level
end

function performWithDelay (delay, func, repeats, ...)
	local t = MOAITimer.new()
	t:setSpan( delay/100 )
	t:setListener( MOAITimer.EVENT_TIMER_LOOP,
	   function ()
	     t:stop()
	     t = nil
	     func( unpack( arg ) )
	        if repeats then
	            if repeats > 1 then
	                performWithDelay( delay, func, repeats - 1, unpack( arg ) )
	            elseif repeats == 0 then
	               performWithDelay( delay, func, 0, unpack( arg ) )
	            end
	        end
	   end
	 )
	t:start()
 end
--Game.freeCam = false
function Game:initGui( )
	
	g:addToResourcePath(filesystem.pathJoin("resources", "fonts"))
	g:addToResourcePath(filesystem.pathJoin("resources", "gui"))
	g:addToResourcePath(filesystem.pathJoin("resources", "media"))
	g:addToResourcePath(filesystem.pathJoin("resources", "themes"))
	g:addToResourcePath(filesystem.pathJoin("resources", "layouts"))

	layermgr.addLayer("gui", 99999, g:layer())
	g:setTheme(THEME_NAME)
	g:setCurrTextStyle("default")

	--- Background STATIC IMAGE

	--self.bg_l3_grid = mGrid:new(50, 50, 32, "Game/media/MGL_Clouds02.png", 1, "BLABLA", g_BackgroundLayer)
end

function Game:handleTurns(_turn)

end

function Game:prepareAllSounds( )
	--[[
	Game.optionSettings.musicLevel = 50
	Game.optionSettings.audioLevel = 25

	]]
	--sound:new(SOUND_MAIN_MENU, "Game/media/audio/bgmusic/grace_song_1_menus.ogg", Game.masterVolume, true, false)
	Game.mainMenuSound = sound:new(1, "sounds/global_resonance_menu.ogg", Game.optionSettings.musicLevel/100, true, false)
	Game.inGameSound = sound:new(2, "sounds/dungeon002_0.ogg", Game.optionSettings.musicLevel/100, true, false)
	Game.uiSwitch = sound:new(3, "sounds/interface1.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.attack = sound:new(4, "sounds/sword-unsheathe4.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.walk = sound:new(5, "sounds/walk.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.dropItem = sound:new(5, "sounds/drop_item.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.potionSound = sound:new(5, "sounds/potion_use.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.pickupSound = sound:new(5, "sounds/pickup_sound.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.gun = sound:new(5, "sounds/gun.ogg", Game.optionSettings.audioLevel/100, false, false)
	MOAIUntzSystem:setVolume(Game.masterVolume)

	Game.music = { }
	Game.music[1] = 1
	Game.music[2] = 2

	Game.soundList = { }
	Game.soundList[1] = 3
	Game.soundList[2] = 4
	Game.soundList[3] = 5

end

function Game:init( )


	Game:importOptions( )
	image:init()
	mGrid:init( )
	anim:init(0.01)
	mAnim:init(0.01)
	font:init( )
	effect:init( )
	Game:initGui( )
	interface:init(g, resources)
	initStates( )
	Game:loadOptionsState( )
	self:prepareAllSounds( )
	
	
end

function Game:update( )


	Game.worldTimer = MOAISim.getElapsedTime( )
	--mGrid:_debugAnim(self.bg_l3_grid, 1, 5)
	Game:loopPersistantKeyPressed( )
	anim:update(Game.worldTimer)
	mAnim:update( )
	handleStates( )
	Game:cameraUpdate( )
end


function Game:draw( )


end

function Game:touchRight( )

end

function Game:revealAll( )
	map:revealAll( )
	items:revealAll( )
	sound:play(sound.revealEffect)
end

function Game:keypressed( key )
	
	--print("KEY IS: "..key.."")
	Game.persistantKey = true
	Game.key = key
	Game.keyTimer = Game.worldTimer
	local _st = state[currentState]
	if _st == "GlobalGameJam" then
		--print("KEY PRESSED HERE IN GGJ")
		if player.isSleeping == false then
			--print("BUT NOT PRESSED HERE")
			--if item:getThrowProcessing( ) == false then
			player:keypressed( key )
			--end
		else
			-- wake up roll
			local chanceToWakeup = 25
			local roll = math.random(1, 100)
			if roll <= chanceToWakeup then
				player.isSleeping = false
				log:newMessage("You woke up")
			end
		end
	elseif _st == "MainMenu" then
		interface:_mmKeyPressed( key )
	elseif _st == "CLASSSEL" then
		interface:_classKeyPressed( key )
	elseif _st == "GAME_OPTIONS" then
		interface:_optionsKeyPressed( key )
	elseif _st == "HIGHSCORE" then
		interface:_highScoreKeyPressed( key )
	elseif _st == "HALP" then
		interface:_helpMenuKeyPressed( key ) 
	elseif _st == "VICTORY" then
		interface:_setupVictoryKeyPressed( key )
	elseif _st == "EDITOR" then
		editor:handleInput( key )
	end

	if key == KEY_PLUS then
		if core:file_exists("enableFullScreen.txt") then
			Game.isFullscreen = not Game.isFullscreen
			core:setFullscreen(Game.isFullscreen)
		end
	end

end

function Game:loopPersistantKeyPressed( )
	if Game.persistantKey == true then
		if Game.worldTimer > Game.keyTimer + 0.5 then
			if _st == "GlobalGameJam" then
				local key = Game.key
				player:keypressed( key )
			elseif _st == "EDITOR" then
				editor:handleInput( key )
			end
		end


	end
end

function Game:keyreleased( key )
	local _st = state[currentState]
	Game.persistantKey = false
	if _st == "ActionPhase" or _st == "MultiplayerPhase" then
		

	end
end

function Game:touchPressed (_idx)
	if Game.disableInteraction == false then
		_gTouchPressed = true
		local _st = state[currentState]

	end
end

function Game:touchLeftReleased ( )
	if Game.disableInteraction == false then
		local _st = state[currentState]

		_gTouchPressed = false
	end
end

function Game:dropUI(_gui, _resources)
	if (nil ~= _gui) then
		if (nil ~= widgets) then
        	unregisterScreenWidgets(widgets)
       	end
        _gui:layer():clear()
	end
end

function Game:touchReleased ( )
	if Game.disableInteraction == false then
		local _st = state[currentState]
		if _st == "Levels" then
			MouseDown = false
			camera:setJoystickHidden( )	
		elseif _st == "LevelEditor" then

		end
	end
	
end

function Game.touchLocation( x, y )
	
	Game.mouseX, Game.mouseY = core:returnLayerTable( )[1].layer:wndToWorld(x, y)
	Game.msX, Game.msY = x, y

	
	

end

function Game:cameraUpdate( )
	if Game.disableInteraction == false then 
		local _st = state[currentState]
		if _st == "ActionPhase"  or _st == "MultiplayerPhase" then
			unit:touchlocation(Game.mouseX, Game.mouseY)
		elseif _st == "Levels" then
			worldMap:touchlocation(Game.mouseX, Game.mouseY)
		elseif _st == "LevelEditor" then
			if _gTouchPressed == true then
				lEditor:touchpressed( )
			end
		end
	end
end

function Game:ViewportScale(_ammX, _ammY)
	core:returnViewPort( )[1].viewPort:setScale(core:returnVPWidth()/_ammX, -core:returnVPHeight()/_ammY)
end
--MOAIInputMgr.device.pointer:setCallback(Game.touchLocation)


function Game:initPathfinding(__grid)
	--grid = Grid(_grid) 
	
	--pather = Jumper(_grid, walkable, false)
	grid = Grid(__grid, false)
	_grid = Grid(__grid, false)
	pather = Pathfinder(grid, 'ASTAR', walkable)
	pather:setMode("ORTHOGONAL")
	
end

function Game:updatePathfinding()
	--grid = Grid(_grid) 
	--grid = Grid(_grid)
	--_grid = Grid(Game.grid)
	--pather = Pathfinder(_grid, 'JPS', walkable)
	--pather = Jumper(Game.grid, walkable, false)
	grid = Grid(Game.grid, false)
	--_grid = Grid(__grid, false)
	pather = Pathfinder(grid, 'ASTAR', walkable)
	pather:setMode("ORTHOGONAL")
end

function Game:setCollisionAt(_x, _y, _state)
	if _state == true then
		Game.grid[_x][_y] = walkable+200
	else
		Game.grid[_x][_y] = walkable
	end
	----print("GRID WIDTH: "..#Game.grid.." AND HEGHT: "..#Game.grid[#Game.grid].."")
	self:updatePathfinding( )
	Game:updatePathfinding()
end

function Game:loop( )
	Game:update( )
	Game:draw( )
end

function Game:drop( )
	
end

function onMouseLeftEvent(down)
  if (down) then
    g:injectMouseButtonDown(inputconstants.LEFT_MOUSE_BUTTON)
  else
    g:injectMouseButtonUp(inputconstants.LEFT_MOUSE_BUTTON)
  end
end

function Game:saveOptionsState( )
	local saveFile = "config.sv"
	--table.save(tb, "map/".._name..".col")
	local result = MOAIFileSystem.checkPathExists(pathToWrite.."config/")
	if result == false then
		MOAIFileSystem.affirmPath(pathToWrite.."config/")
	end
	table.save(Game.optionControls, ""..pathToWrite.."config/"..saveFile.."" )
	--print("SAVED INFO FROM OPTIONS MENU")
end

function Game:loadOptionsState( )
	local saveFile = ""..pathToWrite.."config/config.sv"
	local tb = table.load(saveFile)
	--print("LOADED TABLE!!!!!")
--
	--for i,v in pairs(tb) do
		--print(""..i.."")
	--end
	local bool = false
	if tb ~= nil then
		bool = true
	end
	return tb, bool
end

function Game:RESET( )
		

	Game.inventorySave = { }
	Game.playerStatsSave = { }
	Game.dungeoNLevel = 1
	Game.classOptions = { }
	Game.portalID = 1
	Game.scoreTable = {
		id = 0,
		name = "Sir Zapa-nald",
		turns = 0,
		lvDeath = "",
		killedBy = "",
		score = 0,
		valuableItem = "",
	}
	Game.score = 0
	Game.movement = false
	Game.attack = false
	Game.Turn = 1
	Game.turn = 1
	Game.globalUn = nil
	Game.targetAcquired = false
	Game.disableDock = false
	walkable = 0--1073741825--1
	Game.levelString = "lv_1"
	Game.dungeonType = 1
	Game.grid = nil
	Game.mapFile = "mirrormantis"
	Game.fromEditor = false
	_gTouchPressed = false -- global TOUCH PRESSED 
	Game.firstTurn = 1
	Game.victor = nil
	Game.buildingID = nil
	Game.iteration = 0
	Game.bgColor = {}
	Game.bgColor[1] = { r = 0, g = 0.3, b = 0.8 }
	Game.bgColor[2] = { r = 0.99, g = 0.2, b = 0.2 }
	Game.bgColor[3] = { r = 1, g = 1, b = 1 }
	Game._currentScale = 1
	Game.wantedScale = 1
	Game.oldScale = 1
	zoomInProgress = false
	Game.disableInteraction = false
	Game.masterVolume = 0.9
	Game.commander = {}
	Game.player1 = "Human"
	Game.player2 = "Computer"
	Game.lastState = 2
	Game.winCondition = 1
	Game.tileset = "tileset_ground.png"
	Game.victory = false
	Game.globalFogOfWar = false
	Game.optionControls = { }

	Game.cursorX = 5
	Game.cursorY = 5
	Game.cursorEnabled = false
	Game.key = nil
	Game.keyTimer = Game.worldTimer
	Game.persistantKey = false

	Game.optionControls.soundVolume = Game.masterVolume
	Game.optionControls.fullScreen = false
	Game.isMultiplayer = false
	Game.isFullscreen = false
	Game.saveSystem = { }

	Game:prepareAllSounds( )
end