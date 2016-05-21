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
core = {}

camera = MOAICamera.new ()

function core:init( )
	self.viewPortTable = {}

	self.layerTable = {}
	self.imageTable = {}

	self._vpW = 1
	self._vpH = 1
end

function core:returnLayerTable( )
	return self.layerTable
end

function core:seWindow(_screenWidth, _screenHeight)
	local screenWidth = MOAIEnvironment.horizontalResolution
	local screenHeight = MOAIEnvironment.verticalResolution

	if screenWidth == nil then screenWidth = _screenWidth end
	if screenHeight == nil then screenHeight = _screenHeight end

	MOAISim.openWindow(app_name,screenWidth,screenHeight)
	--self:setFullscreen(true)
	--core:initFont( )
end

function core:initFont( )
	font = MOAIFont.new ()
	charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'

	bitmapFontReader = MOAIBitmapFontReader.new ()
	bitmapFontReader:loadPage ( "Game/media/FontVerdana18.png", charcodes, 16 )
	font:setReader ( bitmapFontReader )
	glyphCache = MOAIGlyphCache.new ()
	glyphCache:setColorFormat ( MOAIImage.COLOR_FMT_RGBA_8888 )
	font:setCache ( glyphCache )

	self._boxTable = {}
end

function core:newTextbox(_x, _y, _width, _height, _string)
--[[	local temp = {
		id = #self._boxTable+1,
		box = MOAITextBox.new( ),
	}
	temp.box:setString(_string)
	temp.box:setFont(font)
	temp.box:setTextSize(12)
	temp.box:setRect(_x, _y, _x + _width, _y + _height)
	temp.box:setAlignment ( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
	table.insert(self._boxTable, temp)
	
	self.layerTable[#self.layerTable].layer:insertProp( temp.box )--]]


	--[[textbox = MOAITextBox.new ()
	textbox:setString ( text )
	textbox:setFont ( font )
	textbox:setTextSize ( 16 )
	textbox:setRect ( -150, -230, 150, 230 )
	textbox:setAlignment ( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
	textbox:setYFlip ( true )--]]
	


end

function core:setViewPort(_layer, _viewPort, _viewPortWidth, _viewPortHeight, _vp2, _vp3, _scaleRatio)
	viewportWidth, viewportHeight = MOAIGfxDevice.getViewSize()
	local temp = {
		id = #self.viewPortTable + 1,
		viewPort = _viewPort,
		width = _viewPortWidth,
		height = _viewPortHeight,
		offsetX = 1,
		offsetY = 1,
		scaleRation = _scaleRatio,
	}
	table.insert(self.viewPortTable, temp)

	unitsX = units_x

	unitsY = units_y

	self.viewPortTable[#self.viewPortTable].viewPort = MOAIViewport.new()
	self.viewPortTable[#self.viewPortTable].viewPort:setSize(_viewPortWidth, _viewPortHeight, _vp2, _vp3)
	self.viewPortTable[#self.viewPortTable].viewPort:setScale(unitsX, unitsY)
	--self.viewPortTable[#self.viewPortTable].viewPort:setOffset(-1,1)
	self._vpW = unitsX--self.viewPortTable[#self.viewPortTable].width
	self._vpH = unitsY--self.viewPortTable[#self.viewPortTable].height

	
end

function core:addGuiViewPort(_viewPort, _viewPortWidth, _viewPortHeight, _vp2, _vp3, _scaleRatio)
	--:viewport()
	local temp = {
		id = #self.viewPortTable + 1,
		viewPort = _viewPort,
		width = _viewPortWidth,
		height = _viewPortHeight,
		offsetX = 1,
		offsetY = 1,
		scaleRation = _scaleRatio,
	}
	table.insert(self.viewPortTable, temp)

end


function core:setSordMode(_layer, _mode)
	self:returnLayer(_layer):setSortMode(_mode)
end

function core:updateViewPort(_vpWidth, _vpHeight, _vp2, _vp3)
	for i,v in ipairs(self.viewPortTable) do
		v.viewPort:setSize(_vpWidth, _vpHeight, _vp2, _vp3)
		v.viewPort:setScale(unitsX,unitsY)
		
		print("WIDTH: ".._vpWidth.." HEIGHT: ".._vpHeight.." VP2: ".._vp2.." VP3: ".._vp3.."")
		print(i)
	end
end

function core:offsetViewport(_x, _y)
	core:returnViewPort()[1].viewPort:setOffset(_x, _y)
end

function core:returnViewPort( )
	return self.viewPortTable
end

function core:returnVPWidth() 
	return self._vpW--self.viewPortTable[1].width
end

function core:returnVPHeight( )
	return self._vpH--self.viewPortTable[1].height
end


function core:newLayer(_layerName, _parrentViewPort)
	local temp = {
		id = #self.layerTable + 1,
		name = _LayerName,
		layer = nil,
		viewPortParrent = _parrentViewPort,
	}	
	table.insert(self.layerTable, temp)
	self.layerTable[#self.layerTable].layer = MOAILayer.new()
	self.layerTable[#self.layerTable].layer:setViewport( self.viewPortTable[ _parrentViewPort ].viewPort )
	--self.layerTable[#self.layerTable].layer:setCamera ( camera )
	self.layerTable[#self.layerTable].layer:showDebugLines(true)
end

function core:layerSetPartition(_layer, _partition)
	self.layerTable[_layer].layer:setPartition ( _partition )
end

function core:returnLayer(_id)
	return self.layerTable[_id].layer
end

function core:_debugSetCamera( )
	--print("DIS")
	--print("DIS")
	--print("DIS")
	--print("DIS")
	--print("DIS")

	dcamera = MOAICamera.new ()


	dcamera:setRot (0, 0, 0)
	core:returnLayer(1):setCamera ( dcamera )
	core:returnLayer(2):setCamera ( dcamera )
	core:returnLayer(3):setCamera ( dcamera )
	core:returnLayer(4):setCamera ( dcamera )
	core:returnLayer(5):setCamera ( dcamera )


end

function core:_debugRenderLayer( _id )
	MOAIRenderMgr.pushRenderPass(self.layerTable[_id].layer)
end

function core:render(_id)
	MOAIRenderMgr.setRenderTable(self.layerTable[_id].layer)
end

function core:setFullscreen(_bool)
	if _bool == true then
		MOAISim.enterFullscreenMode ()
	elseif _bool == false then
		MOAISim.exitFullscreenMode ()
	end
end


--[[
	Got it from here: http://stackoverflow.com/questions/15429236/how-to-check-if-a-module-exists-in-lua
	by finnw
]]

function isModuleAvailable(name)
	if package.loaded[name] then
		return true
	else
		for _, searcher in ipairs(package.searchers or package.loaders) do
			local loader = searcher(name)
			if type(loader) == 'function' then
				package.preload[name] = loader
			return true
			end
		end
		return false
	end
end

function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end