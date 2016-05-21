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

mouse = {}

--map.offsetX-map.scale + x * (32+map.scale)
function mouse:getX( )
	local mx = love.mouse.getX()
	local rx = mx / 32
	local sx, sy = camera:returnScale()
	local px, py = camera:returnPosition( )
	return math.floor(rx)
end

function mouse:getY( )
	local my = love.mouse.getY()
	local ry = my / 32
	local sx, sy = camera:returnScale()
	local px, py = camera:returnPosition( )
	return math.floor(ry)
end

function mouse:drawPointer( )
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("line",mouse:getX()*32, mouse:getY()*32, 32, 32)
	love.graphics.setColor(255,255,255)
end

function mouse:setCalibration( _cx, _cy)
	mouse.cx = _cx
	mouse.cy = _cy

end

function mouse:setTapped(_flag)	
	mouse.tapped = _flag
end

function mouse:returnTapState( )
	return mouse.tapped
end

function mouse:returnCalibration( )
	return mouse.cx, mouse.cy
end