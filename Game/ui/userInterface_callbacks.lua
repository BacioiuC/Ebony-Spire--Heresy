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

function _handleAttackPressed( )
	interface:raiseTauntPanel( )
	if Game.disableDock == false then
		if Game.attack == false then
			print("ATTACK MODE")
			Game.movement = false
			Game.attack = true
			attackButton:setNormalImage(element.resources.getPath("attack_button_pushed.png") )
			moveButton:setNormalImage(element.resources.getPath("movement_button.png") )
		elseif Game.attack == true then
			print("ATTACK OFF")
			Game.movement = false
			Game.attack = false
			attackButton:setNormalImage(element.resources.getPath("attack_button.png") )
			unit:resetAllTargets( )
		end
	end	
end

function _handleMovePressed( )
	if Game.disableDock == false then
		if unit:_returnAttackFlag( ) == true then
			if Game.movement == false then
				Game.movement = true
				--moveButton:setEnabled(false)
				moveButton:setNormalImage(element.resources.getPath("movement_button_pushed.png") )
				attackButton:setNormalImage(element.resources.getPath("attack_button.png") )
				Game.attack = false
				unit:resetAllTargets( )
				print("FREE TO MOVE")
			elseif Game.movement == true then
				Game.movement = false
				Game.attack = false
				--moveButton:setEnabled(true)
				moveButton:setNormalImage(element.resources.getPath("movement_button.png") )
				unit:resetAllTargets( )
				print("DISABLED MOVEMENT")
			end
		end
	end
end

function _handleEndPressed( )
	if Game.disableDock == false then
		if Game.Turn == 1 then
			interface:changeQuote()
			
			Game.Turn = 2
			Game.disableDock = true
			Game.movement = false
			Game.attack = false
			attackButton:setNormalImage(element.resources.getPath("attack_button.png") )
			moveButton:setNormalImage(element.resources.getPath("movement_button.png") )

			unit:pc_reset( )
			unit:resetFlags( ) -- reset restored flags
			unit:_restoreHpOnBase() -- < I'm an idiot! 

		elseif Game.Turn == 2 then

			Game.Turn = 1
			Game.disableDock = false
		end
		print("YOUR MOVE")
	end
end

function _handlePausePressed( )
	_resetGame_vars( )
	unit:dropTable( )
	_bGuiLoaded = false
	_bGameLoaded = false
	Game:dropUI(g, resources )
	mGrid:destroy(3)
	mGrid:destroy(2)
	mGrid:destroy(1)
	image:_dropEntirePropTable( )
	image:_dropEntireImageTable( )
	_bGuiLoaded = false
	image:_count( )
	currentState = 2 -- Main Menu
end

function _handlebMmBttnPressed( )
	dropAllAndChangeState(2)
end

function _handlebLsBttnPressed( )
	dropAllAndChangeState(4)


end

function dropAllAndChangeState(_state)
	_resetGame_vars( )
	unit:dropTable( )
	_bGuiLoaded = false
	_bGameLoaded = false
	Game:dropUI(g, resources )
	mGrid:destroy(3)
	mGrid:destroy(2)
	mGrid:destroy(1)
	image:_dropEntirePropTable( )
	image:_dropEntireImageTable( )
	_bGuiLoaded = false
	image:_count( )
	currentState = _state -- Main Menu
end

function _resetGame_vars( )
	interface:setGameState(nil)
	Game.movement = false
	Game.attack = false
	Game.Turn = 1
	Game.globalUn = nil
	Game.targetAcquired = false
	Game.disableDock = false
end