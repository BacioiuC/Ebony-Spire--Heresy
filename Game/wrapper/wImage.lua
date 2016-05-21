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

wimage = { }

--[[
	Basic idea: Use a wrapper to check if file exists under /mods/whatever instead of Game/what ever. If that is the case, load it from there
	Going to do the same for animation and everything



]]
function wimage:newTexture(_fileName, _parrentLayer, _name, _isDeck, _tileSize)
	local path = "mods/"..Game.modInUse.."/"
	if file_exists(""..path.."".._fileName.."") == false then
		path = "Game/"
	
	end
	--temp.name, self.imageTable[tableIndex].image, self.imageTable[tableIndex].texture
	local name, tImage, tTexture = image:newTexture(""..path.."".._fileName.."", _parrentLayer, _name, _isDeck, _tileSize)
	return name, tImage, tTexture
end
	

function wimage:newDeckTexture(_fileName, _parrentLayer, _name, _tileSize, _isGrid)
	local path = "mods/"..Game.modInUse.."/"
	if file_exists(""..path.."".._fileName.."") == false then
		path = "Game/"
	end
	local name, tImage, tTexture = image:newDeckTexture(""..path.."".._fileName.."", _parrentLayer, _name, _tileSize, _isGrid)
	return name, tImage, tTexture
end
