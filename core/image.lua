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

image = {}
--[[
	Module: @Image.lua, under Game
	How to:
	image:init() must be called before using any features in the image class.

	How to: rendering in MOAI works like this:
	A Quad is created. A texture is then applied to said quad.
	From that quad we create a prop (sprite). It takes on the appearence of the quad including size and aspect.
	The prop is later on inserted into a layer. Once inserted, it remains there until removed.
	The tricky part (for some) is this: MOAI rendering is a simulation and not a draw loop. We can only update
	our props and sprites, not render them, moai handles the rendering part.

--]]

function image:init( )
	self.imageTable = {}
	self.propTable = {}
	self.animTable = {}

	self._filter = MOAITexture.GL_NEAREST

	--[[file = assert ( io.open ( 'shader.vsh', mode ))
	self._vsh = file:read ( '*all' )
	file:close ()

	file = assert ( io.open ( 'shader.fsh', mode ))
	self._fsh = file:read ( '*all' )
	file:close ()

	self._program = MOAIShaderProgram.new ()

	self._program:setVertexAttribute ( 1, 'position' )
	self._program:setVertexAttribute ( 2, 'uv' )
	self._program:setVertexAttribute ( 3, 'color' )

	self._program:reserveUniforms ( 1 )
	self._program:declareUniform ( 1, 'maskColor', MOAIShaderProgram.UNIFORM_VECTOR_F4 )

	--self._program:load ( vsh, fsh )

	self._shader = MOAIShader.new ()
	self._shader:setProgram ( program )
	self._shader:setAttrLink ( 1, color, MOAIColor.COLOR_TRAIT )--]]

end

--[[
	image:newTexture:
	Parameters: 
		_fileName = Name of the image file we want to load
		_parrentLayer = the ID of the layer we want to use it in
		_name = the name through which we will reffer to the texture (used in image:newImage)
	Description: image:newTexture() creates a QUAD and loads an image from the harddrive. The image
	is used to texture the quad and specify it's height and width.

	Returns: @Param 1: Name of the texture, @Param 2: pointer to the main quad.
--]]
function image:dropTexture(_texture)

end

function image:newTexture(_fileName, _parrentLayer, _name, _isDeck, _tileSize)

	local temp = {
		id = #self.imageTable + 1,
		pathToImage = _fileName,
		image = nil,
		prop = nil,
		layer = _parrentLayer,
		name = _name,
		texture = nil,
		isDeck = false,
	}
	table.insert(self.imageTable, temp)

	local tableIndex = #self.imageTable
	
	self.imageTable[tableIndex].texture = MOAITexture.new ()

	if self.imageTable[tableIndex].texture ~= nil then
		--print("TEXTURE ARRAY = OK")
	else
		--print("TEXTURE ARRAY = NO NO")
	end

	


	self.imageTable[tableIndex].texture:load(_fileName)
	self.imageTable[tableIndex].texture:setWrap( false )
	self.imageTable[tableIndex].texture:setFilter ( self._filter)
	local xtex, ytex = self.imageTable[tableIndex].texture:getSize()
	if _isDeck == nil or _isDeck == false then
		

		self.imageTable[tableIndex].image = MOAIGfxQuad2D.new( )
		self.imageTable[tableIndex].image:setTexture( self.imageTable[tableIndex].texture )
		self.imageTable[tableIndex].image:setRect(0, 0, xtex, ytex)
		self.imageTable[tableIndex].image:setUVRect( 0, 0, 1, 1 )




		
	else -- then we are dealing with a deck
		self.imageTable[tableIndex].isDeck = true
		self.imageTable[tableIndex].image = MOAITileDeck2D.new ()

		self.imageTable[tableIndex].image:setTexture ( self.imageTable[tableIndex].texture )


		self.imageTable[tableIndex].image:setSize ( xtex/_tileSize, ytex/_tileSize )
		--self.imageTable[tableIndex].image:setRect ( 0, _tileSize, _tileSize, 0)
		--self.imageTable[tableIndex].image:setShape( MOAIGridSpace.OBLIQUE_SHAPE)
		--self.imageTable[tableIndex].image:setRect(-xtex/_tileSize, -ytex/_tileSize, xtex/_tileSize, ytex/_tileSize)
		--self.imageTable[tableIndex].image:setUVRect( 0, 0, _tileSize, _tileSize )		
	end

	--print("New image created in self.ImageTable with id: "..temp.id.."")
	--print("Table now contains: "..tableIndex.." images")
	return temp.name, self.imageTable[tableIndex].image, self.imageTable[tableIndex].texture
end

function image:newDeckTexture(_fileName, _parrentLayer, _name, _tileSize, _isGrid)

	local temp = {
		id = #self.imageTable + 1,
		pathToImage = _fileName,
		image = nil,
		prop = nil,
		layer = _parrentLayer,
		name = _name,
		texture = nil,
		isDeck = false,
	}
	table.insert(self.imageTable, temp)

	local tableIndex = #self.imageTable

	self.imageTable[tableIndex].texture = MOAITexture.new ()

	if self.imageTable[tableIndex].texture ~= nil then
		--print("TEXTURE ARRAY = OK")
	else
		--print("TEXTURE ARRAY = NO NO")
	end
	--self.imageTable[tableIndex].texture:setFilter ( self._filter )
	self.imageTable[tableIndex].texture:setWrap( false )
	self.imageTable[tableIndex].texture:setFilter ( self._filter)	
	self.imageTable[tableIndex].texture:load(_fileName)
	--self.imageTable[tableIndex].texture:setWrap( true )
	self.imageTable[tableIndex].texture:setFilter ( self._filter)
	local xtex, ytex = self.imageTable[tableIndex].texture:getSize()

	self.imageTable[tableIndex].isDeck = true
	self.imageTable[tableIndex].image = MOAITileDeck2D.new ()

	self.imageTable[tableIndex].image:setTexture ( self.imageTable[tableIndex].texture )


	self.imageTable[tableIndex].image:setSize ( xtex/_tileSize, ytex/_tileSize)
	if _isGrid ~= nil then
		self.imageTable[tableIndex].image:setRect ( 0.25, _tileSize+0.25, _tileSize+0.25, 0+0.25)
	end
		--self.imageTable[tableIndex].image:setShape( MOAIGridSpace.OBLIQUE_SHAPE)
		--self.imageTable[tableIndex].image:setRect(-xtex/_tileSize, -ytex/_tileSize, xtex/_tileSize, ytex/_tileSize)
		--self.imageTable[tableIndex].image:setUVRect( 0, 0, _tileSize, _tileSize )		
	
	--print("DECKS... ARE DECKS OK?")
	--print("New image created in self.ImageTable with id: "..temp.id.."")
	--print("Table now contains: "..tableIndex.." images")
	return temp.name, self.imageTable[tableIndex].image, self.imageTable[tableIndex].texture
end


--[[
	image:newImage:
	Parameters: 
		_image = the name of the Quad/Texture we want to base our sprite on
		_x = position on the X axis at which the image will be drawn once inserted
		_y = position on the Y axis at which the image will be drawn once inserted
	Description: creates a prop (sprite), sets the parrent Quad/Texture from the "Deck" and
	inserts it into layer 1. [L1 only for now]
	Returns: @Param 1: the position of the new prop(sprite) inside our PROP Table
--]]
function image:newDeckImage(_image, _x, _y, _deckTile)
	
	local imageToRender = nil 
	local imageID = image:returnImageId(_image)



	if imageID > 0 then
		local temp = {
			id = #self.propTable + 1,
			prop = nil,
			texBase = nil,
			timer = MOAISim.getElapsedTime( ),
		}
		table.insert(self.propTable, temp)

		local tableIndex = #self.propTable
		
		self.propTable[tableIndex].prop = MOAIProp.new()
		self.propTable[tableIndex].prop:setDeck(self.imageTable[imageID].image)
		--self.propTable[tableIndex].prop:setCullMode(MOAIProp.CULL_BACK)
		self.propTable[tableIndex].texBase = imageID
		core:returnLayerTable( )[self.imageTable[imageID].layer].layer:insertProp( self.propTable[tableIndex].prop )
		self.propTable[tableIndex].prop:setIndex(_deckTile)	
		self.propTable[tableIndex].prop:setLoc(_x, _y)
		self.propTable[tableIndex]._x = _x
		self.propTable[tableIndex]._y = _y
		--self.propTable[tableIndex].color = {r = 1, g = 1, b = 1, a = 1}
		return temp.id
	else
		--print("Cannot draw image, Name: ")
		return 0
	end

end

function image:newImage(_image, _x, _y)
	
	local imageToRender = nil 
	local imageID = image:returnImageId(_image)



	if imageID > 0 then
		local temp = {
			id = #self.propTable + 1,
			prop = nil,
			texBase = nil,
			timer = MOAISim.getElapsedTime( ),
		}
		table.insert(self.propTable, temp)

		local tableIndex = #self.propTable
		
		self.propTable[tableIndex].prop = MOAIProp2D.new()
		self.propTable[tableIndex].prop:setDeck(self.imageTable[imageID].image)
		--self.propTable[tableIndex].prop:setCullMode(MOAIProp.CULL_BACK)
		self.propTable[tableIndex].texBase = imageID
		core:returnLayerTable( )[self.imageTable[imageID].layer].layer:insertProp( self.propTable[tableIndex].prop )	
		self.propTable[tableIndex].prop:setLoc(_x, _y+_gAndroidOffset)
		self.propTable[tableIndex]._x = _x
		self.propTable[tableIndex]._y = _y+_gAndroidOffset
		return temp.id
	else
		--print("Cannot draw image, Name: ")
		return 0
	end

end

function image:new3DTexture(_fileName, _parrentLayer, _name)
local temp = {
		id = #self.imageTable + 1,
		pathToImage = _fileName,
		image = nil,
		prop = nil,
		layer = _parrentLayer,
		name = _name,
		texture = nil,
		isDeck = false,
	}
	table.insert(self.imageTable, temp)

	local tableIndex = #self.imageTable
	
	self.imageTable[tableIndex].texture = MOAITexture.new ()

	if self.imageTable[tableIndex].texture ~= nil then
		--print("TEXTURE ARRAY = OK")
	else
		--print("TEXTURE ARRAY = NO NO")
	end

	


	self.imageTable[tableIndex].texture:load(_fileName)
	self.imageTable[tableIndex].texture:setWrap( false )
	self.imageTable[tableIndex].texture:setFilter ( self._filter)
	local xtex, ytex = self.imageTable[tableIndex].texture:getSize()
	if _isDeck == nil or _isDeck == false then
		

		self.imageTable[tableIndex].image = MOAIGfxQuad2D.new( )
		self.imageTable[tableIndex].image:setTexture( self.imageTable[tableIndex].texture )
		self.imageTable[tableIndex].image:setRect(0, 0, xtex, ytex)
		self.imageTable[tableIndex].image:setUVRect( 0, 0, 1, 1 )




		
	else -- then we are dealing with a deck
		self.imageTable[tableIndex].isDeck = true
		self.imageTable[tableIndex].image = MOAITileDeck2D.new ()

		self.imageTable[tableIndex].image:setTexture ( self.imageTable[tableIndex].texture )


		self.imageTable[tableIndex].image:setSize ( xtex/_tileSize, ytex/_tileSize )
		--self.imageTable[tableIndex].image:setRect ( 0, _tileSize, _tileSize, 0)
		--self.imageTable[tableIndex].image:setShape( MOAIGridSpace.OBLIQUE_SHAPE)
		--self.imageTable[tableIndex].image:setRect(-xtex/_tileSize, -ytex/_tileSize, xtex/_tileSize, ytex/_tileSize)
		--self.imageTable[tableIndex].image:setUVRect( 0, 0, _tileSize, _tileSize )		
	end

	--print("New image created in self.ImageTable with id: "..temp.id.."")
	--print("Table now contains: "..tableIndex.." images")
	return temp.name, self.imageTable[tableIndex].image, self.imageTable[tableIndex].texture
end

function image:new3DImage( _image, _x, _y, _z, _parrentLayer, _disableDepth)
		local temp = {
			id = #self.propTable + 1,
			prop = nil,
			texBase = nil,
			timer = MOAISim.getElapsedTime( ),
			layer = _parrentLayer,
		}
		table.insert(self.propTable, temp)

		local tableIndex = #self.propTable
		
		temp.prop = MOAIProp.new()
		temp.prop:setDeck(_image)
		temp.prop:setLoc(_x, _y, _z)
		temp.prop:setShader ( MOAIShaderMgr.getShader ( MOAIShaderMgr.MESH_SHADER ))
		temp.prop:setCullMode ( MOAIProp.CULL_BACK )
		core:returnLayerTable( )[temp.layer].layer:insertProp( temp.prop )	
		temp.prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
		--temp.prop:setBlendMode(MOAIProp2D.GL_SRC_ALPHA, MOAIProp2D.GL_ONE_MINUS_SRC_ALPHA)
		--temp.prop:setColor(1,1,1,0.9)
		--DEPTH_TEST_DISABLE for skybox
		if _disableDepth ~= nil then
			temp.prop:setDepthTest( MOAIProp.DEPTH_TEST_ALWAYS )
		else
			temp.prop:setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL)
		end
		--GL_SRC_COLOR,  MOAIProp.GL_ONE_MINUS_SRC_ALPHA
		temp.prop:setDepthMask(true)
		
		MOAIGfxDevice.getFrameBuffer ():setClearDepth ( true )		
		if _image == nil then
		--	print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
		end
		self.propTable[tableIndex]._x = _x
		self.propTable[tableIndex]._y = _y
		--print("HAPPENING")
		return temp.id
end

function image:setTexture(_prop, _texture)
	self.propTable[_prop].prop:setTexture(_texture)
end

function image:set3DDeck(_prop, _deck)
	self.propTable[_prop].prop:setDeck(_deck)
end

function image:setVisible3D(_prop, bool)
	self.propTable[_prop].prop:setVisible(bool)
end

function image:getRot3D(_prop)
	self.propTable[_prop].prop:getRot( )
end

function image:set3DIndex(_prop, _idx)
	self.propTable[_prop].prop:setIndex(_idx)
end

function image:disableDepthmask(_prop)
	self.propTable[_prop].prop:setDepthMask(false)
	self.propTable[_prop].prop:setPriority(1)
end

function image:seekLoc(_prop, _x, _y, _z, _time)
	self.propTable[_prop].prop:seekLoc( _x, _y, _z, _time)
end

function image:setRot3D(_prop, _x, _y, _z, _time)
	if _prop ~= nil then
		if self.propTable[_prop].prop ~= nil then
			self.propTable[_prop].prop:setRot( _x, _y, _z)
		end
	end
end

function image:seekRot3D(_prop, _x, _y, _z, _time)
	--print("Prop name: ".._prop.."")
	self.propTable[_prop].prop:seekRot( _x, _y, _z, _time)
end

function image:setLoc(_prop, _x, _y, _z )
	self.propTable[_prop].prop:setLoc(_x, _y, _z)
end

function image:setPiv(_prop, _x, _y, _z )
	self.propTable[_prop].prop:setPiv(_x, _y, _z)
end

function image:moveRot(_prop, _x, _y, _z, _time)
	self.propTable[_prop].prop:moveRot( _x, _y, _z, 0.1 )
end
--[[
	image:updateImage:
	Parameters: 
		_image = the prop we want to update
		_x = new X position of our image
		_y = new Y position of our image
	Description: updates the location of a prop, in the layer
	Returns: nil
--]]
function image:updateImage(_image, _x, _y)
	local imageID = _image
	if imageID ~= nil then
		if imageID > 0 then
			local tableIndex = #self.propTable
			if self.propTable[imageID]._x ~= _x or self.propTable[imageID]._y ~= _y then
				--if MOAISim.getElapsedTime() > self.propTable[imageID].timer + 5 then
					self.propTable[imageID].prop:setLoc(_x, _y)
					self.propTable[imageID]._x = _x
					self.propTable[imageID]._y = _y
				--	self.propTable[imageID].timer = MOAISim.getElapsedTime()
				--end
			end
		else
			--print("PAHIL IN UPDATE IMAGE")
		end
	end
end

function image:getProp(_image)
	local imageID = _image
	if imageID > 0 then
		return self.propTable[imageID].prop
	else
		--print("WRONG IMAGE")
		return nil
	end
end

function image:setVisible(_image, bool)
	local imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:setVisible(bool)
	else

	end
end

function image:setScale(_image, _scx, _scy, _time)
	local imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:seekScl(_scx, _scy, _time, MOAIEaseType.EASE_OUT)
	end
end

function image:set3DScale(_image, _scx, _scy, _scz)
	local imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:setScl(_scx, _scy, _scz)
	end
end

function image:_setScale(_image, _scx, _scy, _time)
	local imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:setScl(_scx, _scy)
	end
end

function image:_flipX(_image)

end

function image:getScale(_image)
	local imageID = _image
	local imageProp = self.propTable[imageID].prop
	local scx = 0
	local scy = 0
	if imageProp ~= nil then
		scx, scy = imageProp:getScl()
	else
		--print("CANNOT SET INDEX")
	end
	return scx, scy
end

function image:removeProp(_image, _layer)
	if self.propTable[_image] ~= nil then
		local imageID = _image
		if imageID > 0 then
			local lr
			if _layer ~= nil then
				lr = _layer
			else
				lr = 1
			end
			core:returnLayerTable()[lr].layer:removeProp(self.propTable[imageID].prop)
			self.propTable[imageID].prop = nil
			--table.remove(self.propTable, _image)
		else
			--print("WOOPS, something went wrong with image REMOVAL!")
		end
	end
end

function image:dropProps( )
	for i,v in ipairs(self.propTable) do
		core:returnLayerTable( )[1].layer:removeProp( v.prop )	
	end
	self.propTable = {}
end

function image:returnImageId(_imageName)
	for i,v in ipairs(self.imageTable) do
		if v.name == _imageName then
			return i
		end
	end	
	return 0
end

function image:dropImage(_image)
	local imageID = image:returnImageId(_image)
	if imageID > 0 then
		--print("REMOVING PROP: "..imageID.."")
		core:returnLayerTable( )[1].layer:removeProp( self.imageTable[imageID].prop )		
	end
end

function image:returnNumberOfProps( )
	return #self.propTable
end

function image:textureGetSize(_image)
	local imageID = image:returnImageId(_image)

	if imageID > 0 then
		local texW, texH = self.imageTable[imageID].texture:getSize( )
		return texW, texH
	else
		return nil, nil
	end


end

function image:getWidth(_image)
	local imageID = image:returnImageId(_image)

	if imageID > 0 then
		local texW, texH = self.imageTable[imageID].texture:getSize( )
		return texW
	else
		return nil, nil
	end
end

function image:getHeight(_image)
	local imageID = image:returnImageId(_image)

	if imageID > 0 then
		local texW, texH = self.imageTable[imageID].texture:getSize( )
		return texH
	else
		return nil, nil
	end
end

--[[
	image:getSize( ) <-- used for props size. To not be confuzed with textureGetSize, getWidth of getHeight
	which only apply to the texture deck, not the actual prop!
	]]
function image:getSize(_image) 
	local imageID = _image
	if imageID > 0 then
		local texID = self.propTable[imageID].texBase

		local szX, szY = self.imageTable[texID].texture:getSize( )
		return szX, szY
	else
		--print(" NOPE! IMAGE:GETSIZE() HAS A PHAIL!")
		return nil, nil
	end
end

function image:dropAllImages( )
	for i,v in ipairs(self.propTable) do
		image:removeProp(v.id)
		--image:setVisible(v.id,false)
	end
	self.propTable = {}
end

function image:setPriority(_image, _priority)
	imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:setPriority( _priority )
	else
		--print("CANNOT SET PRIORITY FOR IMAGE")
	end
end

function image:setColor(_image,r,g,b,alpha)
	imageID = _image
	if imageID > 0 then
		local _prop = self.propTable[imageID]
		if _prop.r ~= r or _prop.g ~= g or _prop.b ~= b or _prop.a ~= alpha then
			self.propTable[imageID].prop:setColor(r,g,b,alpha)
			_prop.r = r
			_prop.g = g
			_prop.b = b
			_prop.a = a
		end

	else
		--print("CANNOT SET COLOR FOR IMAGE: "..imageID.."")
	
	end
end

function image:seekColor(_image,r,g,b,alpha, _time)
	imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:seekColor(r,g,b,alpha, _time)

	else
		--print("CANNOT SET COLOR FOR IMAGE: "..imageID.."")
	
	end
end

function image:setTexture(_image, _texture)
	imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:setTexture(_texture)

	else
		--print("CANNOT SET COLOR FOR IMAGE: "..imageID.."")
	
	end
end

function image:propExists( _image )
	local imageID = _image

	if self.propTable[imageID].prop ~= nil then

		return true
	else
		return false
	end
end

function image:moveProp( _image, _x, _y )
	local imageID = _image
	local imageProp = self.propTable[imageID].prop
	if imageProp ~= nil then
		imageProp:seekLoc(_x, _y)
		--return true
	else
		--print("CANNOT SEEK LOC WITH IMAGE:moveProp")
		--return false
	end
end

function image:setGrid(_image, _grid)
	local imageID = _image
	local imageProp = self.propTable[imageID].prop
	if imageProp ~= nil then
		imageProp:setGrid(_grid)
	else
		--print("CANNOT SET GRID")
	end
end

function image:setIndex(_image, _index)
	local imageID = _image
	if self.propTable[imageID] ~= nil then
		local imageProp = self.propTable[imageID].prop
		if imageProp ~= nil then
			imageProp:setIndex( _index)
		else
			--print("CANNOT SET INDEX")
			--print("CANNOT SET INDEX")
			--print("CANNOT SET INDEX")
			--print("CANNOT SET INDEX")
			--print("CANNOT SET INDEX")
			--print("CANNOT SET INDEX")
			--print("CANNOT SET INDEX")
		end
	end
	
end
function image:newAnim(_startFrame, _endFrame, _deck, _deckSize)
	local temp = {
		id = #self.animTable+1,
		deck = image:newDeckTexture("Game/media/".._deck.."", 1, " tex ".._deck.."_anim", _deckSize, "NotNill"),
		startFrame = _startFrame,
		endFrame = _endFrame,
		currentFrame = _startFrame,
	}
	temp.img = image:newDeckImage(temp.deck, 32, 32, temp.startFrame)
	table.insert(self.animTable, temp)
	--print("TEMP IMG: "..temp.img.."")
	return temp.img
end

function image:playAnim(_img, _x, _y, _startFrame, _endFrame, _delay)
	local imageID = _img
	local imageProp = self.propTable[imageID].prop
	if imageProp ~= nil then
		performWithDelay(_delay, image._animAdvance, _endFrame-_startFrame+1, self, imageProp, _x, _y, _startFrame, _endFrame)
		--image:_animAdvance(imageProp, _x, _y, _startFrame, _endFrame)
	else
		--print("ANIM PROP IS NIL")
	end
end

function image:_animIncIndex(_index, _start, _max)
	local idx = _index
	if idx < _max then
		idx = idx + 1
	else
		idx = _start
	end
	--print("IDX AT WORK"..idx.."")
	return idx
end

function image:_animAdvance(_prop, _x, _y, _start, _end)
	_prop:setIndex(image:_animIncIndex(_prop:getIndex(), _start, _end) )
	_prop:setLoc(_x, _y)
	--print("ADVANCING")
end

function image:_removeAnim(_image)
	local imageID = _image
	local imageProp = self.propTable[imageID].prop
	if imageProp ~= nil then
		core:returnLayerTable()[1].layer:removeProp(self.propTable[imageID].prop)
		self.propTable[imageID].prop = nil
		--table.remove()
	end

end

function image:_dropEntirePropTable( )
	for i = 1, #self.propTable, -1 do
		tableIndex = 0
		table.remove(self.propTable, i)
		if i then
			image:_dropEntirePropTable( )
		end
	end
	self.propTable = {}
end

function image:_dropEntireImageTable( )
	for i = 1, #self.imageTable, -1 do
		table.remove(self.imageTable, i)
		if i then
			image:_dropEntireImageTable( )
		end
	end
	self.imageTable = {}
end

function image:_count( )
	local img = #self.imageTable
	local prop = #self.propTable
	for i = 1, 20 do
		--print("IMG: "..img.." PROP: "..prop.."")
	end

	MOAISim.forceGarbageCollection ()
end