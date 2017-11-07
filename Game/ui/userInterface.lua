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

interface = {}
element = {}

require "Game.ui.intro_moai"


function interface:init(_gui, _resources)
	local g = _gui
	local resources = _resources
	local roots, widgets, groups = g:loadLayout(resources.getPath("isoPanel.lua"))
	element.roots = roots 
	element.widgets = widgets
	element.groups = groups
	element.resources = resources
	element.gui = _gui

	self._bottomY = 1
	self._bottomX = 1
	self._buttonWidth = 14
	self._buttonHeight = 18

	self._picWidth = 8
	self._picHeight = 12


	self._gameState = nil

	self._offsetAndroidX = 0

	self._targetX = 5000
	self._targetY = 5000
	self._ptargetX = 5000
	self._ptargetY = 5000	

	self._towerGenerated = false
	-- make alpha sign
	--alpha_tex = image:newTexture("Game/alpha_sign.png", g_ActionPhase_UI_Layer, "alpha_sign_tex")
	--alpha_sign = image:newImage(alpha_tex, resX-323, resY)

end

function interface:setGameState(_state)
	self._gameState = _state
end

function interface:initAP( )
	interface:init_ap_buttons( )
	interface:_buy_menu_init( )
end

function interface:setup_cursors( )
	--[[alpha_pic = element.gui:createImage( )
	alpha_pic:setDim(18, 24)
	alpha_pic:setPos(82, 0)
	alpha_pic:setImage(element.resources.getPath("alpha_sign.png"))--]]
	
	cursor_tex = wimage:newTexture("media/cursor.png", 2, "cursor_tex")
	Game.cursorX = 5
	Game.cursorY = 5
	if cursor_anim == nil then
		cursor_tex_anim = wanim:newDeck("media/cursor_animation.png", 48, g_ActionPhase_UI_Layer)
		cursor_anim = anim:newAnim(cursor_tex_anim, 8, Game.cursorX*32, Game.cursorY*32, 1)
		anim:setSpeed(cursor_anim, 0.2)

		anim:createState("NORMAL_CURSOR", 1, 4, 0.2)
		anim:createState("DEL_CURSOR", 5, 8, 0.2)
		anim:setState(cursor_anim, "NORMAL_CURSOR")


		target_tex_anim = wanim:newDeck("media/target_sprite.png", 48, g_ActionPhase_UI_Layer)
		target_anim = anim:newAnim(target_tex_anim, 4, 200, 200, 1)
		anim:setSpeed(target_anim, 0.14)
	end

	--anim:addToPool(target_anim)
	--cursor_img = image:newImage(cursor_tex, 1, 1)
end

function interface:_updateGameCursor( )
	-- if cursor < 3 then move map x. If bigger then 17 move map x + 1
	-- same on y
	if unit:getOnUi( ) == false then
		local MapSizeX, MapSizeY = map:getSize( )

		if Game.cursorX > MapSizeX then
			Game.cursorX = MapSizeX
		elseif Game.cursorX < 1 then
			Game.cursorX = 1
		end

		if Game.cursorY < 1 then
			Game.cursorY = 1
		elseif Game.cursorY > MapSizeY then
			Game.cursorY = MapSizeY
		end

		local ac = (Game.cursorX-1)*32+map.offX-8
		local bc = (Game.cursorY-1)*32+map.offY-8
		--print("X: "..ac.." Y "..bc.."")

		if bc > 280 then
			map:updateScreen(0, -32)
		elseif bc < 64 then
			print("PE 512")
			map:updateScreen(0, 32)
		end

		if ac < 64 then
			map:updateScreen(32, 0)
		elseif ac > 512 then
			map:updateScreen(-32, 0)
		end
	end

end

function interface:update_cursor( )
	local offsetX, offsetY = map:returnOffset( )

	local msx = math.floor( (Game.mouseX-map.offX) /map.gridSize) 
	local msy = math.floor( (Game.mouseY-map.offY) /map.gridSize)
	--print("X: "..msx.." Y: "..msy.."")

	if cursor_anim ~= nil then
		if Game.cursorEnabled == true then
			anim:updateAnim(cursor_anim, (Game.cursorX-1)*32+map.offX-8, (Game.cursorY-1)*32+map.offY-8)
		else
			if cursor_anim ~= nil then
				anim:updateAnim(cursor_anim, (20000-1)*32+map.offX-8, (20000-1)*32+map.offY-8)
			end
		end
		anim:updateAnim(target_anim, self._targetX*32-32+map.offX-8, self._targetY*32-32+map.offY-5-8 )



	end
	

end

function interface:setTargetAtLoc(_x, _y, _color)
	if _color == 1 then
		anim:setState(target_anim, "NORMAL_CURSOR")
	else
		anim:setState(target_anim, "DEL_CURSOR")
	end
	self._targetX = _x
	self._targetY = _y
end

function interface:updateTargetReticle( )
	local px, py = anim:getPosition(target_anim)
	local _px = px * 32 - 32 + map.offX
	local _py = px * 32 - 32 + map.offY
end


function interface:updateInLoop( )
	interface:update_cursor( )
end

function interface:updatePanels( )
	interface:_actionPanelUpdate( )
	interface:_ap_update( )
	interface:_tweenBuyMenu( )
end

