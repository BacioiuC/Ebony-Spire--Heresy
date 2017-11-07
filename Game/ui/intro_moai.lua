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

function interface:_setupLoadScreen( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("intro_file.lua"), "")

	-- load sounds here
	Game:prepareAllSounds( )

	
	self._introImage = 1
	self._MoaiIntrotimer = Game.worldTimer
end

function interface:_switchTo_introText( )
	if Game.worldTimer > self._MoaiIntrotimer + 2 and self._introImage == 1 then
		print("WELLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL")
		Game:dropUI(g, resources )
		local roots, widgets, groups = element.gui:loadLayout(resources.getPath("story_file.lua"), "")
		self._introImage = 3
		self._newTimer = Game.worldTimer
	end

	if self._introImage == 3 then
		print("moving to MAIN MENU")
		
		_bGuiLoaded = false
		_bGameLoaded = false
		Game:dropUI(g, resources )
		currentState = 2
	end
end

function interface:_introGetIntroState( )
	return self._introImage
end

function interface:_setIntroState( state )
	self._introImage = 3
end