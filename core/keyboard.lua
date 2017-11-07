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

softKeyBoard = {}

function softKeyBoard:createKeyboard(_gui, _keyWidth, _keyHeight)
	self.keyBoard = {}
	self.gui = _gui
	self._bgPanel = self.gui:createImage( )
	self._bgPanel:setDim(100, 100)
	self._bgPanel:setPos(0, 0)

	self.keyWidth = _keyWidth
	self.keyHeight = _keyHeight
	self.maxKeyX = 11
	self.keySpaceX = 1 -- space between the keys
	self.keySpaceY = 2
	self.x = 1
	self.y = 20
	self.ox = 1
	self.oy = 120
	self._rowCount = 0
	self._colCount = 0

	self._outputField = nil
end

function softKeyBoard:setOutputField(_field)
	self._outputField = _field
	if self._outputField ~= nil then self.gui:setFocus(self._outputField) end

end

function softKeyBoard:bindToPanel(_daddyPanel)
	_daddyPanel:addChild(self._bgPanel)
end

function softKeyBoard:setY(_y)
	self.y = _y
end

function softKeyBoard:addKey(_char)
	if _char ~= "" then
		self.keyBoard[_char] = self.gui:createButton( )
		self.keyBoard[_char]:setPos(self.x + self._rowCount, self.y + self._colCount)
		self.keyBoard[_char]:setDim(self.keyWidth, self.keyHeight)
		self.keyBoard[_char]:setText(_char)
		self.keyBoard[_char]:setNormalImage(resources.getPath("/keyboard/key_bg.png") )
		data = {}
		if _char == "BKP" then
			data.character = 8
		else
			data.character = string.byte(_char)
		end

		self.keyBoard[_char]:registerEventHandler(self.keyBoard[_char].EVENT_BUTTON_CLICK, nil, keyClick, data)

		self._bgPanel:addChild(self.keyBoard[_char])
	end
    self._rowCount = self._rowCount + self.keyWidth + self.keySpaceX
    if self._rowCount >= self.maxKeyX* (self.keyWidth+self.keySpaceX) then
    	self._rowCount = 0
    	self._colCount = self._colCount + self.keyHeight + self.keySpaceY
    end
end

function softKeyBoard:returnOutputField( )
	return self._outputField
end

function softKeyBoard:returnGui( )
	return self.gui
end

function keyClick(event, data)
	local output = softKeyBoard:returnOutputField( )
	local _gui = softKeyBoard:returnGui( )
	
	if output ~= nil then _gui:setFocus(output) end
	_gui:injectKeyDown(data.character)
    _gui:injectKeyUp(data.character)
	--print("A KEY WUZ PRESSED")
end


function softKeyBoard:destroyKeyboard( )

end