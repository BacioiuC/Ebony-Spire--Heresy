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

mCamera = { }

function mCamera:init( )
	self._cameraTable = { }
	self._anchorTable = { }
end

function mCamera:new(_layersNr)
	local temp = {
		id = #self._cameraTable+1,
		cam = MOAICamera2D:new(),
	}
	--print("ID IS: "..temp.id.."")

	-- add it to a layer
	for i = 1, _layersNr do
		if i ~= 3 then
			core:returnLayer(i):setCamera(temp.cam)
		end
	end

	table.insert(self._cameraTable, temp)

	return temp.cam, temp.id
end


function mCamera:newAnchor()
	local temp = {
		id = #self._anchorTable+1,
		anchor = MOAICameraAnchor2D.new (),
	}

	table.insert(self._anchorTable, temp)

	temp.anchor:setRect(0, 0, 32, 32)

	return anchor, id
end

function mCamera:setWorldBounds(_x, _y, _x2, _y2)

end

function mCamera:setPos(_camera, _x, _y)
	local cam = _camera
	cam:seekLoc(_x-224, _y-108)
end

function mCamera:getPos(_camera)
	local cam = _camera
	return cam:getLoc( )
end

function mCamera:updateMouse(_camera)
	if MouseDown == true then
		local difMouseX = math.floor((Game.pressedX - Game.mouseX))
   		local difMouseY = math.floor((Game.pressedY - Game.mouseY))


		local cam = _camera
		local camX, camY = cam:getLoc( )

		local camnX = camX - difMouseX
		local camnY = camY - difMouseY
		cam:setLoc(camnX, camnY)
	end
end

function mCamera:setAnchorProp(_id, _prop)
	local image = image:getProp(_prop)
	local anchor = self._anchorTable[_id].anchor:setParent(image)
end
