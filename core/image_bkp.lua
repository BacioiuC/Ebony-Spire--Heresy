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
		print("TEXTURE ARRAY = OK")
	else
		print("TEXTURE ARRAY = NO NO")
	end
	--self.imageTable[tableIndex].texture:setFilter ( MOAITexture.GL_LINEAR_MIPMAP_LINEAR )
	self.imageTable[tableIndex].texture:load(_fileName)
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
		--self.imageTable[tableIndex].image:setRect(-xtex/_tileSize, -ytex/_tileSize, xtex/_tileSize, ytex/_tileSize)
		--self.imageTable[tableIndex].image:setUVRect( 0, 0, _tileSize, _tileSize )		
	end

	print("New image created in self.ImageTable with id: "..temp.id.."")
	print("Table now contains: "..tableIndex.." images")
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
function image:newImage(_image, _x, _y)
	
	local imageToRender = nil 
	local imageID = image:returnImageId(_image)



	if imageID > 0 then
		local temp = {
			id = #self.propTable + 1,
			prop = nil,
			texBase = nil,
		}
		table.insert(self.propTable, temp)

		local tableIndex = #self.propTable
		
		self.propTable[tableIndex].prop = MOAIProp2D.new()
		self.propTable[tableIndex].prop:setDeck(self.imageTable[imageID].image)
		self.propTable[tableIndex].texBase = imageID
		core:returnLayerTable( )[self.imageTable[imageID].layer].layer:insertProp( self.propTable[tableIndex].prop )	
		self.propTable[tableIndex].prop:setLoc(_x, _y)

		return temp.id
	else
		print("Cannot draw image, Name: ")
		return 0
	end

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

	if imageID > 0 then
		local tableIndex = #self.propTable
		self.propTable[imageID].prop:setLoc(_x, _y)
	else
		print("PAHIL IN UPDATE IMAGE")
	end
end

function image:setVisible(_image, bool)
	local imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:setVisible(bool)
	else

	end
end

function image:setScale(_image, _scx, _scy)
	local imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:setScl(_scx, _scy)
	end
end

function image:removeProp(_image)
	if self.propTable[_image] ~= nil then
		local imageID = _image
		if imageID > 0 then
			core:returnLayerTable()[1].layer:removeProp(self.propTable[imageID].prop)
			self.propTable[imageID].prop = nil
		else
			print("WOOPS, something went wrong with image REMOVAL!")
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
		print("REMOVING PROP: "..imageID.."")
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
		print(" NOPE! IMAGE:GETSIZE() HAS A PHAIL!")
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
		print("CANNOT SET PRIORITY FOR IMAGE")
	end
end

function image:setColor(_image,r,g,b,alpha)
	imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:setColor(r,g,b,alpha)

	else
		print("CANNOT SET COLOR FOR IMAGE: "..imageID.."")
	
	end
end

function image:setTexture(_image, _texture)
	imageID = _image
	if imageID > 0 then
		self.propTable[imageID].prop:setTexture(_texture)

	else
		print("CANNOT SET COLOR FOR IMAGE: "..imageID.."")
	
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
		print("CANNOT SEEK LOC WITH IMAGE:moveProp")
		--return false
	end
end

function image:setGrid(_image, _grid)
	local imageID = _image
	local imageProp = self.propTable[imageID].prop
	if imageProp ~= nil then
		imageProp:setGrid(_grid)
	else
		print("CANNOT SET GRID")
	end
end