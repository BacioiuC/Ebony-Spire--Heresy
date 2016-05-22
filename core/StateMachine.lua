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

state = {}
_bGuiLoaded = false
function initStates( )
	state[1] = "Intro"
	state[2] = "MainMenu"
	state[3] = "Options"
	state[4] = "Levels"
	state[5] = "ActionPhase"
	state[6] = "Pause"
	state[7] = "EndScreen"
	state[8] = "Drop"
	state[9] = "LevelEditor"
	state[10] = "FreeBattle"
	state[11] = "LayoutStuff"
	state[12] = "MultiplayerLobby"
	state[13] = "MultiplayerPhase"
	state[14] = "GlobalGameJam"
	state[15] = "GGJMainMenu"
	state[16] = "SOLVEMYPROBLEMSSTATE"
	state[17] = "DeathScreen"
	state[18] = "QUITTOMAINMENU"
	state[19] = "CLASSSEL"
	state[20] = "HIGHSCORE"
	state[21] = "HALP"
	state[22] = "VICTORY"
	currentState = 2

	_bGuiLoaded = false
	_bGameLoaded = false
end

function handleStates( )

	local _st = state[currentState]
	--print("CURRENT STATE: ".._st.."")

	if _st == "Intro" then
		introLoop( )
	elseif _st == "MainMenu" then
		ammLoop( )
	elseif _st == "Options" then
		optionsMenu( )
	elseif _st == "Levels" then
		lvsLoop( )
	elseif _st == "ActionPhase" then
		apLoop( )
	elseif _st == "Pause" then

	elseif _st == "EndScreen" then
		endScrLoop( )
	elseif _st == "Drop" then

	elseif _st == "LevelEditor" then
		lvEditorLoop( )
	elseif _st == "FreeBattle" then
		freeBattleMenu( )
	elseif _st == "LayoutStuff" then
		layoutTesting( )
	elseif _st == "MultiplayerLobby" then
		multiplayerLobby( )
	elseif _st == "MultiplayerPhase" then
		multiplayerPhase( )
	elseif _st == "GlobalGameJam" then
		ggjPhase( )
	elseif _st == "GGJMainMenu" then
		ggjMM( )
	elseif _st == "DeathScreen" then
		deathScreen( )
	elseif _st == "SOLVEMYPROBLEMSSTATE" then
		fixitplox( )
	elseif _st == "QUITTOMAINMENU" then
		fixitploxMainMenu( )
	elseif _st == "CLASSSEL" then
		ggjClassSel( )
	elseif _st == "HIGHSCORE" then
		ggHighScore( )
	elseif _st == "HALP" then
		ggjHalp( )
	elseif _st == "VICTORY" then
		ggjVictory( )
	else
		print("STATE OUT OF BOUNDS")
	end
end

function ggjVictory( )
	
	if _bGameLoaded == false then

		_bGameLoaded = true
	
	else

	end

	if _bGuiLoaded == false then
		interface:_setupVictoryScreen( )
		
	
		_bGuiLoaded = true

	else
		
	end		
end

function fixitplox( )
	--_handleQuitToMM( )
	for i = 1, 6 do
		rngMap:destroyMap( )
		item:removeAll( )
		entity:removeAll( )
		interface:destroyUI ( )
		item:removeAll( )
		environment:removeAll( )

	end
	player:saveStats( )
	_bGameLoaded = false
	_bGuiLoaded = false

	--if Game.dungeoNLevel < 1 then
	
	currentState = 14
	--else
	--	currentState = 22
	--end



	--currentState = 14
end

function fixitploxMainMenu( )
	--_handleQuitToMM( )
	for i = 1, 6 do
		rngMap:destroyMap( )
		item:removeAll( )
		entity:removeAll( )
		interface:destroyUI ( )
		item:removeAll( )

	end
	--player:saveStats( )
	Game.dungeoNLevel = 1
	_bGameLoaded = false
	_bGuiLoaded = false


	currentState = 2
end

function ggjPhase( )
	if _bGameLoaded == false then

		--overlay_image		


		entity:init( )
		player:init( )
		evTurn:init( )
		_bGameLoaded = true

	
	else

		player:update( )
		entity:update( )
		item:update( )
		log:listenForPing( )
	end

	if _bGuiLoaded == false then
		interface:initAP()
		_bGuiLoaded = true

	else
		interface:update( )
		interface:updateFPS( )
	end
end

function ggjMM( )
	if _bGameLoaded == false then

		_bGameLoaded = true
	
	else

	end

	if _bGuiLoaded == false then
		interface:initGGJMM(  )
		
	
		_bGuiLoaded = true

	else
		
	end
end

function ggjHalp( )
	if _bGameLoaded == false then

		_bGameLoaded = true
	
	else

	end

	if _bGuiLoaded == false then
		interface:_initHelpMenu( )
		
	
		_bGuiLoaded = true

	else
		
	end
end

function ggjClassSel( )
	if _bGameLoaded == false then

		_bGameLoaded = true
	
	else

	end

	if _bGuiLoaded == false then
		interface:setupClassScreen( )
		
	
		_bGuiLoaded = true

	else
		
	end
end

function ggHighScore( )
	if _bGameLoaded == false then

		_bGameLoaded = true
	
	else

	end

	if _bGuiLoaded == false then
		interface:_initHighScore( )
		
	
		_bGuiLoaded = true

	else
		
	end
end




function endScrLoop( )
	
	if _bGameLoaded == false then
		pgMap:init( )
		digger:init( )
		camera:init( )

		_bGameLoaded = true
	
	else
		camera:update( )
		pgMap:update( )
	end

	if _bGuiLoaded == false then
		--camera:init( )
		
	
		_bGuiLoaded = true

	else
		
	end
	
end

function layoutTesting( )

end



function introLoop( )
	if _bGameLoaded == false then
		_bGameLoaded = true
	
	else
	

	end

	if _bGuiLoaded == false then
		--camera:init( )
		
		interface:_setupLoadScreen( )
		_bGuiLoaded = true

	else
		interface:_switchTo_introText( )
	end
	
end

function freeBattleMenu( )

	if _bGameLoaded == false then
		_bGameLoaded = true
	
	else
	

	end

	if _bGuiLoaded == false then
		interface:_init_map_selection( )
		
		--camera:init( )
		
		_bGuiLoaded = true

	else

		interface:_sm_updatePanel( )
		interface:_update_map_selection( )

	end
end

function optionsMenu( )
	if _bGameLoaded == false then
		_bGameLoaded = true
	else
	
	end

	if _bGuiLoaded == false then
		
		--camera:init( )
		interface:_init_commander_sel( )
		_bGuiLoaded = true

	else
		interface:_cs_updatePanels( )

	end
end

function ammLoop( )
	if _bGameLoaded == false then
		_bGameLoaded = true
	else

	end

	if _bGuiLoaded == false then
		 interface:setupMainMenu( )
		--camera:init( )
		
		_bGuiLoaded = true

	else

		interface:circleTowerUpdate( )

	end
end

function lvsLoop( )
	if _bGuiLoaded == false then

		--interface:initLVSelect( )

		interface:_init_worldMap( )
		interface:setup_cursors( )
		_bGuiLoaded = true
		
	else

		
		--map:update( )
		
	end

	if _bGameLoaded == false then
		anim:dropAll( )
		camera:init( )
		worldMap:init( )
		_bGameLoaded = true
	else
		camera:update( )
		worldMap:loop( )--worldMap:update( )
	end
end

function apLoop( )
	

	if _bGuiLoaded == false then
		interface:_setupAlternateUiNavigation( )
		interface:initAP( )
		
		interface:setup_cursors( )	

		_bGuiLoaded = true
	else


		interface:updateInLoop( )
		interface:updatePanels( )
		interface:_handleUiNavigation( )
		interface:_updateVirtualMouse( )
	end

	if _bGameLoaded == false then
		Game.victory = false
		map:initAP (Game.mapFile)
		
		camera:init( )
		building:init(Game.mapFile)
		
		unit:init(Game.mapFile)
		player1.coins = player1.initialCoins
		player2.coins = player2.initialCoins
		map:setOffset(32, 16)
		map:_updateFogOfWar( )
		

		interface:_update_buymenu_unitList( )
		--map:_setCameraToCorrectPlayerPos( )
		_bGameLoaded = true
	else
		camera:update( )
		
		map:update( )
		building:update( )
		unit:update( )	


		if Game.cursorEnabled == true then
			interface:_handleUiNavigation( )
			interface:_updateVirtualMouse( )
		end
	end

end

function lvEditorLoop( )
	if _bGuiLoaded == false then

		interface:level_editor_init( )
		
		_bGuiLoaded = true
	else
		interface:updateInLoop( )

	end

	if _bGameLoaded == false then
		
		lEditor:init( )
		
		
		_bGameLoaded = true
	else
		lEditor:update( )
		camera:update( )
		
	end



end

function multiplayerLobby( )
	if _bGuiLoaded == false then

		interface:initLobbyUi( )
		
		_bGuiLoaded = true
	else


	end

	if _bGameLoaded == false then
		

		multiplayer:lobbyInit( )
		
		_bGameLoaded = true
	else
		
		
	end
end

function multiplayerPhase( )

	if _bGuiLoaded == false then
		interface:_setupAlternateUiNavigation( )
		interface:initAP( )
		
		interface:setup_cursors( )	

		_bGuiLoaded = true
	else


		interface:updateInLoop( )
		interface:updatePanels( )
		interface:_handleUiNavigation( )
		interface:_updateVirtualMouse( )
	end

	if _bGameLoaded == false then
		Game.victory = false
		map:initAP (Game.mapFile, true)
		
		camera:init( )
		unit:init(Game.mapFile, true)
		building:init(Game.mapFile, true)
		
		player1.coins = player1.initialCoins
		player2.coins = player2.initialCoins
		map:setOffset(32, 16)
	--	map:_updateFogOfWar( )
		

		interface:_update_buymenu_unitList( )
		--map:_setCameraToCorrectPlayerPos( )
		_bGameLoaded = true
	else
		
		camera:update( )
		
		map:update( )
		building:update( )
		unit:update( )

		if Game.cursorEnabled == true then
			interface:_handleUiNavigation( )
			interface:_updateVirtualMouse( )
		end
	end
end

function drop( )
	_bGuiLoaded = false
end